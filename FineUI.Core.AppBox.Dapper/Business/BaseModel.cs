using System;
using System.Collections.Generic;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Xml;
using FineUI.Core;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Data.SqlClient;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Mvc.Filters;
using System.Reflection;
using System.Data;
using Dapper;
using Microsoft.Extensions.Configuration;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Components;

namespace FineUI.Core.AppBox.Dapper
{
    public class BaseModel : PageModel
    {
        #region IsPostBack

        /// <summary>
        /// 是否页面回发
        /// </summary>
        public bool IsPostBack
        {
            get
            {
                return FineUI.Core.PageContext.IsFineUIAjaxPostBack();
            }
        }

        #endregion

        #region RegisterStartupScript

        /// <summary>
        /// 注册客户端脚本
        /// </summary>
        /// <param name="scripts"></param>
        public void RegisterStartupScript(string scripts)
        {
            FineUI.Core.PageContext.RegisterStartupScript(scripts);
        }

        #endregion

        #region ViewBag

        private DynamicViewData _viewBag;

        /// <summary>
        /// Add ViewBag to PageModel
        /// https://forums.asp.net/t/2128012.aspx?Razor+Pages+ViewBag+has+gone+
        /// https://github.com/aspnet/Mvc/issues/6754
        /// </summary>
        public dynamic ViewBag
        {
            get
            {
                if (_viewBag == null)
                {
                    _viewBag = new DynamicViewData(ViewData);
                }
                return _viewBag;
            }
        }
        #endregion

        #region 只读静态变量

        private static readonly string SK_ONLINE_UPDATE_TIME = "OnlineUpdateTime";

        /// <summary>会话键：当前用户拥有的权限名列表缓存</summary>
        protected static readonly string SK_USER_POWER_LIST = "UserPowerList";
        /// <summary>会话键：上面那份缓存是按哪个权限版本号算出来的</summary>
        protected static readonly string SK_USER_POWER_VERSION = "UserPowerVersion";
        /// <summary>会话键：上次复核「用户仍存在且启用」的时间</summary>
        protected static readonly string SK_ACTIVE_CHECKED_AT = "ActiveCheckedAt";

        /// <summary>复核用户是否仍然有效的间隔（秒）</summary>
        private const int ACTIVE_CHECK_INTERVAL_SECONDS = 60;

        /// <summary>
        /// 全局权限版本号：角色的权限集合、用户的角色集合一有变化就加一，
        /// 各会话据此丢弃自己缓存的权限列表。
        ///
        /// 它是本进程内的静态计数：多实例部署时各实例互不通知，被改动的那台之外仍会用旧缓存
        /// 到会话结束；真要做集群，把它换成共享存储（如 Redis）里的一个计数或按用户的失效标记。
        /// </summary>
        /// <remarks>
        /// 从 1 开始，不能从 0 开始：会话里没存过版本号时 GetObject&lt;long&gt; 返回 0，
        /// 只有让 0 不等于任何有效版本，「有列表但没版本号」才会被判成过期而重算。
        /// </remarks>
        private static long _permissionVersion = 1;

        public static readonly string CHECK_POWER_FAIL_PAGE_MESSAGE = "您无权访问此页面！";
        public static readonly string CHECK_POWER_FAIL_ACTION_MESSAGE = "您无权进行此操作！";

        #endregion

        #region OnActionExecuting

        /// <summary>
        /// 页面处理器调用之前执行
        /// </summary>
        /// <param name="context"></param>
        public override void OnPageHandlerExecuting(PageHandlerExecutingContext context)
        {
            base.OnPageHandlerExecuting(context);

            // 如果用户已经登录，更新在线记录
            if (User.Identity.IsAuthenticated)
            {
                UpdateOnlineUser(GetIdentityID());
            }
        }

        /// <summary>
        /// 每个请求都复核一次「这个会话对应的用户是否仍然存在且启用」。
        ///
        /// 登录身份是登录那一刻的快照，账号事后被禁用或删除，他已经登录的会话不会自动失效。
        /// 复核结果按固定间隔缓存在会话里：不缓存就是每个请求一条查询，缓存太久则禁用迟迟不生效。
        /// 失效即登出——首屏跳登录页，回发返回 401，由客户端 common.js 的 F.beforeAjaxError 接住。
        /// </summary>
        public override async Task OnPageHandlerExecutionAsync(PageHandlerExecutingContext context, PageHandlerExecutionDelegate next)
        {
            // 登录页本身不做这道复核：否则浏览器里存着已禁用账号的 Cookie 时，
            // 连「换一个账号登录」都会被这里挡回去（提交登录表单也是一次回发）
            bool isLoginPage = HttpContext.Request.Path.StartsWithSegments("/Login");

            if (!isLoginPage && User.Identity.IsAuthenticated && !await IsActiveUserAsync())
            {
                await HttpContext.SignOutAsync();
                HttpContext.Session.Clear();

                if (HttpContext.Request.Method == "POST")
                {
                    // 回发返回 401 纯文本：这一步比 FineUI 的脚本管道更靠外，此时注册启动脚本不会进到响应里，
                    // 而 401 客户端本来就认得——common.js 的 F.beforeAjaxError 会提示并跳转登录页
                    context.Result = new ContentResult
                    {
                        StatusCode = StatusCodes.Status401Unauthorized,
                        ContentType = "text/plain;charset=UTF-8",
                        Content = "账号已被禁用或删除，请重新登录！"
                    };
                }
                else
                {
                    context.Result = new RedirectResult("/Login");
                }

                // 不调用 next：本次请求就此中止
                return;
            }

            await base.OnPageHandlerExecutionAsync(context, next);
        }

        /// <summary>
        /// 当前会话对应的用户是否仍然存在且启用（结果按 ACTIVE_CHECK_INTERVAL_SECONDS 秒缓存在会话里）
        /// </summary>
        protected async Task<bool> IsActiveUserAsync()
        {
            DateTime? checkedAt = HttpContext.Session.GetObject<DateTime?>(SK_ACTIVE_CHECKED_AT);
            if (checkedAt != null && DateTime.UtcNow.Subtract(checkedAt.Value).TotalSeconds < ACTIVE_CHECK_INTERVAL_SECONDS)
            {
                return true;
            }

            int? userID = GetIdentityID();
            if (userID == null)
            {
                return false;
            }

            int count = await DB.QueryFirstOrDefaultAsync<int>(
                "SELECT COUNT(*) FROM Users WHERE ID = @UserID AND Enabled = 1", new { UserID = userID });

            bool active = count > 0;
            if (active)
            {
                // 用 UTC 记时间：本地时间遇到夏令时或对时回拨会算出负数，负数照样小于间隔，复核就被跳过了
                HttpContext.Session.SetObject<DateTime?>(SK_ACTIVE_CHECKED_AT, DateTime.UtcNow);
            }

            return active;
        }

        public override void OnPageHandlerExecuted(PageHandlerExecutedContext context)
        {
            base.OnPageHandlerExecuted(context);
        }

        #endregion

        #region 请求参数

        /// <summary>
        /// 获取查询字符串中的参数值
        /// </summary>
        protected string GetQueryValue(string queryKey)
        {
            return Request.Query[queryKey].ToString();
        }


        /// <summary>
        /// 获取查询字符串中的参数值
        /// </summary>
        protected int GetQueryIntValue(string queryKey)
        {
            int queryIntValue = -1;
            try
            {
                queryIntValue = Convert.ToInt32(Request.Query[queryKey]);
            }
            catch (Exception) { }

            return queryIntValue;
        }

        #endregion

        #region GetRequestEventArguments

        /// <summary>
        /// 获取回发的目标控件
        /// </summary>
        /// <returns></returns>
        public string GetRequestEventTarget()
        {
            return Request.Form["__EVENTTARGET"];
        }

        /// <summary>
        /// 获取回发的参数
        /// </summary>
        /// <returns></returns>
        public string GetRequestEventArgument()
        {
            return Request.Form["__EVENTARGUMENT"];
        }

        /// <summary>
        /// 获取回发的参数列表
        /// </summary>
        /// <returns></returns>
        public string[] GetRequestEventArguments()
        {
            var arg = GetRequestEventArgument();
            return arg.Split("$");
        }
        #endregion

        #region ShowNotify

        /// <summary>
        /// 显示通知对话框
        /// </summary>
        /// <param name="message"></param>
        public virtual void ShowNotify(string message)
        {
            ShowNotify(message, MessageBoxIcon.Information);
        }

        /// <summary>
        /// 显示通知对话框
        /// </summary>
        /// <param name="message"></param>
        /// <param name="messageIcon"></param>
        public virtual void ShowNotify(string message, MessageBoxIcon messageIcon)
        {
            ShowNotify(message, messageIcon, Target.Top);
        }

        /// <summary>
        /// 显示通知对话框
        /// </summary>
        /// <param name="message"></param>
        /// <param name="messageIcon"></param>
        /// <param name="target"></param>
        public virtual void ShowNotify(string message, MessageBoxIcon messageIcon, Target target)
        {
            Notify n = new Notify
            {
                Target = target,
                Message = message,
                MessageBoxIcon = messageIcon,
                PositionX = Position.Center,
                PositionY = Position.Top,
                DisplayMilliseconds = 3000,
                ShowHeader = false
            };

            n.Show();
        }


        #endregion

        #region 在线用户相关

        protected void UpdateOnlineUser(int? userID)
        {
            if (userID == null)
            {
                return;
            }

            DateTime now = DateTime.Now;
            object lastUpdateTime = HttpContext.Session.GetObject<DateTime>(SK_ONLINE_UPDATE_TIME);
            if (lastUpdateTime == null || (now.Subtract(Convert.ToDateTime(lastUpdateTime)).TotalMinutes > 5))
            {
                // 记录本次更新时间
                HttpContext.Session.SetObject<DateTime>(SK_ONLINE_UPDATE_TIME, now);

                Online online = DB.QueryFirstOrDefault<Online>("SELECT * FROM Onlines WHERE UserID = @UserID", new { UserID = userID });

                if (online != null)
                {
                    DB.Execute("UPDATE Onlines SET UpdateTime = @UpdateTime WHERE UserID = @UserID", new { UpdateTime = now, UserID = userID });
                }

            }
        }

        protected async Task RegisterOnlineUserAsync(int userID)
        {
            DateTime now = DateTime.Now;

            Online online = await DB.QueryFirstOrDefaultAsync<Online>("SELECT * FROM Onlines WHERE UserID = @UserID", new { UserID = userID });

            // 如果不存在，就创建一条新的记录
            var isNew = false;
            if (online == null)
            {
                isNew = true;
                online = new Online();
            }
            online.UserID = userID;
            online.IPAdddress = Request.HttpContext.Connection.RemoteIpAddress.ToString();
            online.LoginTime = now;
            online.UpdateTime = now;

            if (isNew)
            {
                await ExecuteInsertAsync<Online>(online, "UserID", "IPAdddress", "LoginTime", "UpdateTime");
            }
            else
            {
                await ExecuteUpdateAsync<Online>(online, "UserID", "IPAdddress", "LoginTime", "UpdateTime");
            }

            // 记录本次更新时间
            HttpContext.Session.SetObject<DateTime>(SK_ONLINE_UPDATE_TIME, now);
        }

        /// <summary>
        /// 在线人数
        /// </summary>
        /// <returns></returns>
        protected async Task<int> GetOnlineCountAsync()
        {
            DateTime lastM = DateTime.Now.AddMinutes(-15);

            return await DB.QueryFirstOrDefaultAsync<int>("SELECT COUNT(*) FROM Onlines WHERE UpdateTime > @LastUpdateTime", new { LastUpdateTime = lastM });
        }

        #endregion

        #region 当前登录用户信息

        // http://blog.163.com/zjlovety@126/blog/static/224186242010070024282/
        // http://www.cnblogs.com/gaoshuai/articles/1863231.html
        /// <summary>
        /// 当前登录用户的角色列表
        /// </summary>
        /// <returns></returns>
        protected List<int> GetIdentityRoleIDs()
        {
            return GetIdentityRoleIDs(HttpContext);
        }

        #endregion

        #region 权限检查

        /// <summary>
        /// 检查当前用户是否拥有某个权限
        /// </summary>
        /// <param name="powerType"></param>
        /// <returns></returns>
        protected bool CheckPower(string powerName)
        {
            return CheckPower(HttpContext, powerName);
        }

        /// <summary>
        /// 获取当前登录用户拥有的全部权限列表
        /// </summary>
        /// <param name="roleIDs"></param>
        /// <returns></returns>
        protected List<string> GetRolePowerNames()
        {
            return GetRolePowerNames(HttpContext);
        }

        /// <summary>
        /// 检查权限失败（页面第一次加载）
        /// </summary>
        public static void CheckPowerFailWithPage(HttpContext context)
        {
            string PageTemplate = "<!DOCTYPE html><html><head><meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\"/><head><body>{0}</body></html>";
            context.Response.WriteAsync(String.Format(PageTemplate, CHECK_POWER_FAIL_PAGE_MESSAGE));
        }

        /// <summary>
        /// 检查权限失败（页面回发）
        /// </summary>
        public static void CheckPowerFailWithAlert()
        {
            FineUI.Core.PageContext.RegisterStartupScript(Alert.GetShowInTopReference(CHECK_POWER_FAIL_ACTION_MESSAGE));
        }

        /// <summary>
        /// 检查当前用户是否拥有某个权限
        /// </summary>
        /// <param name="context"></param>
        /// <param name="powerName"></param>
        /// <returns></returns>
        public static bool CheckPower(HttpContext context, string powerName)
        {
            // 如果权限名为空，则放行
            if (String.IsNullOrEmpty(powerName))
            {
                return true;
            }

            // 当前登陆用户的权限列表
            List<string> rolePowerNames = GetRolePowerNames(context);
            if (rolePowerNames.Contains(powerName))
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// 获取当前登录用户拥有的全部权限列表
        /// </summary>
        /// <param name="roleIDs"></param>
        /// <returns></returns>
        public static List<string> GetRolePowerNames(HttpContext context)
        {
            // 版本号要在查库之前取：万一取完之后有人改了权限，最坏是「新数据配旧版本号」，
            // 下次不匹配再算一遍而已。反过来先查库后取版本号，会存下「新版本号配旧数据」，那就永远不会再重算了
            long version = Interlocked.Read(ref _permissionVersion);

            // 权限列表缓存在会话里，避免一个请求里反复查库（页面级判一次、每个按钮判一次、事件里再判一次）。
            // 光判「有没有缓存」是不够的：那样管理员改了角色权限，当事人要重新登录才生效。
            // 所以连同「算这份缓存时的版本号」一起存，版本对不上就重算。
            var cached = context.Session.GetObject<List<string>>(SK_USER_POWER_LIST);
            if (cached != null && context.Session.GetObject<long>(SK_USER_POWER_VERSION) == version)
            {
                return cached;
            }

            var db = BaseModel.GetDbConnection();

            List<string> rolePowerNames;

            // 超级管理员拥有所有权限
            if (GetIdentityName(context) == "admin")
            {
                rolePowerNames = db.Query<string>("SELECT Name FROM Powers").ToList();
            }
            else
            {
                // 按用户主键重新查角色，不用身份信息里的角色标识：那是登录那一刻的快照，
                // 管理员给某人换了角色之后，只有重新查库才能拿到新的角色集合
                int? userID = GetIdentityID(context);

                rolePowerNames = db.Query<string>(
                    "SELECT DISTINCT Powers.Name FROM Powers"
                    + " INNER JOIN RolePowers ON Powers.ID = RolePowers.PowerID"
                    + " INNER JOIN RoleUsers ON RoleUsers.RoleID = RolePowers.RoleID"
                    + " WHERE RoleUsers.UserID = @UserID",
                    new { UserID = userID }).ToList();
            }

            context.Session.SetObject<List<string>>(SK_USER_POWER_LIST, rolePowerNames);
            context.Session.SetObject<long>(SK_USER_POWER_VERSION, version);

            return rolePowerNames;
        }

        /// <summary>
        /// 让所有会话缓存的权限列表作废：凡是改动了「用户—角色—权限」三者关系的地方都要调用，
        /// 受影响的用户下一次请求就会按新权限判定，不必重新登录。
        ///
        /// 禁用或删除用户不必调用它：那两件事由每请求的账号有效性复核兜住（最迟 60 秒生效）。
        /// </summary>
        public static void InvalidatePermissionCaches()
        {
            Interlocked.Increment(ref _permissionVersion);
        }

        // http://blog.163.com/zjlovety@126/blog/static/224186242010070024282/
        // http://www.cnblogs.com/gaoshuai/articles/1863231.html
        /// <summary>
        /// 当前登录用户的角色列表
        /// </summary>
        /// <returns></returns>
        public static List<string> GetIdentityRoleNames(HttpContext context)
        {
            List<string> roleNames = new List<string>();

            var db = BaseModel.GetDbConnection();

            if (context.User.Identity.IsAuthenticated)
            {
                // 超级管理员拥有所有权限
                if (GetIdentityName(context) == "admin")
                {
                    return new List<string> { "超级管理员" };
                }
                else
                {
                    List<int> roleIDs = GetIdentityRoleIDs(context);

                    roleNames = db.Query<string>("SELECT Roles.Name FROM Roles WHERE ID IN @RoleIDs", new { RoleIDs = roleIDs }).ToList();
                }
            }

            return roleNames;
        }

        public static List<int> GetIdentityRoleIDs(HttpContext context)
        {
            List<int> roleIDs = new List<int>();

            if (context.User.Identity.IsAuthenticated)
            {
                string userData = context.User.Claims.Where(x => x.Type == "RoleIDs").FirstOrDefault().Value;

                foreach (string roleID in userData.Split(','))
                {
                    if (!String.IsNullOrEmpty(roleID))
                    {
                        roleIDs.Add(Convert.ToInt32(roleID));
                    }
                }
            }

            return roleIDs;
        }


        /// <summary>
        /// 当前登录用户名
        /// </summary>
        /// <returns></returns>
        protected string GetIdentityName()
        {
            return GetIdentityName(HttpContext);
        }

        /// <summary>
        /// 当前登录用户名
        /// </summary>
        /// <returns></returns>
        public static string GetIdentityName(HttpContext context)
        {
            if (!context.User.Identity.IsAuthenticated)
            {
                return null;
            }

            var userName = context.User.Claims.Where(x => x.Type == "UserName").FirstOrDefault().Value;
            return userName;
        }

        /// <summary>
        /// 当前登录用户标识符
        /// </summary>
        /// <returns></returns>
        protected int? GetIdentityID()
        {
            return GetIdentityID(HttpContext);
        }

        /// <summary>
        /// 当前登录用户标识符
        /// </summary>
        /// <returns></returns>
        public static int? GetIdentityID(HttpContext context)
        {
            if (!context.User.Identity.IsAuthenticated)
            {
                return null;
            }

            var userID = context.User.Claims.Where(x => x.Type == "UserID").FirstOrDefault().Value;
            return Convert.ToInt32(userID);
        }

        #endregion

        #region GetProductVersion

        protected string GetProductVersion()
        {
            Version v = Assembly.GetExecutingAssembly().GetName().Version;
            return String.Format("{0}.{1}.{2}", v.Major, v.Minor, v.Build);
        }

        #endregion

        #region DB

        private IDbConnection _db;
        /// <summary>
        /// 每个请求共享一个数据库连接实例
        /// </summary>
        protected IDbConnection DB
        {
            get
            {
                if (_db == null)
                {
                    _db = BaseModel.GetDbConnection();
                }
                return _db;
            }
        }

        /// <summary>
        /// 获取数据库连接实例（静态方法）
        /// </summary>
        /// <returns></returns>
        public static IDbConnection GetDbConnection()
        {
            var myConnectionService = FineUI.Core.PageContext.GetRequestService<MyConnectionService>();
            return myConnectionService?.GetDbConnection();
        }

        #region GetReflectionProperties

        /// <summary>
        /// 获取实例的属性名称列表
        /// </summary>
        /// <param name="instance"></param>
        /// <returns></returns>
        private string[] GetReflectionProperties(object instance)
        {
            var result = new List<string>();
            foreach (PropertyInfo property in instance.GetType().GetProperties(BindingFlags.Instance | BindingFlags.Public))
            {
                var propertyName = property.Name;
                // NotMapped特性
                var notMappedAttr = property.GetCustomAttribute<NotMappedAttribute>(false);
                if (notMappedAttr == null && propertyName != "ID")
                {
                    result.Add(propertyName);
                }
            }
            return result.ToArray();
        }

        #endregion

        #region ExecuteUpdateAsync/ExecuteInsertAsync


        /// <summary>
        /// 执行数据库更新操作
        /// </summary>
        /// <param name="instance">模型实例</param>
        /// <param name="fields">更新的表字段</param>
        /// <returns></returns>
        protected async Task<int> ExecuteUpdateAsync<T>(T instance, params string[] fields)
        {
            return await ExecuteUpdateAsync<T>(DB, instance, fields);
        }

        /// <summary>
        /// 执行数据库更新操作
        /// </summary>
        /// <param name="conn"></param>
        /// <param name="instance"></param>
        /// <param name="fields"></param>
        /// <returns></returns>
        protected async Task<int> ExecuteUpdateAsync<T>(IDbConnection conn, T instance, params string[] fields)
        {
            // 约定：类型 User 对应的数据库表名 users
            string tableName = typeof(T).Name.ToLower() + "s";

            if (fields.Length == 0)
            {
                fields = GetReflectionProperties(instance);
            }

            var fieldsSql = String.Join(",", fields.Select(field => field + " = @" + field));

            var sql = String.Format("UPDATE {0} SET {1} WHERE ID = @ID", tableName, fieldsSql);

            return await conn.ExecuteAsync(sql, instance);
        }


        protected async Task<int> ExecuteInsertAsync<T>(T instance, params string[] fields)
        {
            return await ExecuteInsertAsync<T>(DB, instance, fields);
        }

        /// <summary>
        /// 执行数据库插入操作
        /// </summary>
        /// <param name="instance">模型实例</param>
        /// <param name="tableName">模型对应的表名</param>
        /// <param name="fields">插入的表字段</param>
        /// <returns>新插入的行ID</returns>
        protected async Task<int> ExecuteInsertAsync<T>(IDbConnection conn, T instance, params string[] fields)
        {
            // 约定：类型 User 对应的数据库表名 users
            string tableName = typeof(T).Name.ToLower() + "s";

            if (fields.Length == 0)
            {
                fields = GetReflectionProperties(instance);
            }

            var fieldsSql1 = String.Join(",", fields);
            var fieldsSql2 = String.Join(",", fields.Select(field => "@" + field));

            var sql = String.Format("INSERT {0} ({1}) VALUES ({2});", tableName, fieldsSql1, fieldsSql2);

            if (conn is MySqlConnection)
            {
                sql += "SELECT last_insert_id();";
            }
            else
            {
                sql += "SELECT @@IDENTITY;";
            }

            return await conn.QuerySingleAsync<int>(sql, instance);
        } 
        #endregion

        #region FindByIDAsync
        /// <summary>
        /// 检索对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="paramID"></param>
        /// <returns></returns>
        protected async Task<T> FindByIDAsync<T>(int paramID)
        {
            return await FindByIDAsync<T>(DB, paramID);
        }

        /// <summary>
        /// 检索对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="conn"></param>
        /// <param name="paramID"></param>
        /// <returns></returns>
        protected async Task<T> FindByIDAsync<T>(IDbConnection conn, int paramID)
        {
            // 约定：类型 User 对应的数据库表名 users
            var tableName = typeof(T).Name.ToLower() + "s";

            return await conn.QuerySingleOrDefaultAsync<T>("SELECT * FROM " + tableName + " WHERE ID = @ParamID", new { ParamID = paramID });
        }


        /// <summary>
        /// 获取用户信息（返回的数据中包含用户所属的部门信息）
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        protected async Task<User> GetUserByIDAsync(int userID)
        {
            return await DB.QuerySingleOrDefaultAsync<User>("SELECT Users.*, Depts.Name DeptName FROM Users LEFT JOIN Depts ON Users.DeptID = Depts.ID WHERE Users.ID = @UserID", new { UserID = userID });
        }

        #endregion

        #endregion


    }
}
