
using Dapper;
using FineUI.Core;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace FineUI.Core.AppBox.Dapper.Pages
{
    public partial class LoginModel : PageBase
    {
        #region Fields



        #endregion

        #region Page_Init

        public void Page_Init(object sender, EventArgs e)
        {
            // 已登录用户打开登录地址时直接跳到首页，框架随后跳过登录页模板和 Page_Load。
            if (!IsPostBack && User.Identity.IsAuthenticated)
            {
                Response.Redirect("/");
            }
        }

        #endregion

        #region Page_Load

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Window1.Title = String.Format("FineUI.Core.AppBox.Dapper v{0}", GetProductVersion());
            }
        }


        #endregion


        #region Events

        protected async Task btnSubmit_ClickAsync(object sender, EventArgs e)
        {
            string userName = tbxUserName.Text.Trim();
            string password = tbxPassword.Text.Trim();

            var user = await DB.QueryFirstOrDefaultAsync<User>("SELECT * FROM Users WHERE Name = @Name", new { Name = userName });

            if (user != null)
            {
                if (PasswordUtil.ComparePasswords(user.Password, password))
                {
                    if (!user.Enabled)
                    {
                        Alert.Show("用户未启用，请联系管理员！");
                    }
                    else
                    {
                        // 登录成功
                        await LoginSuccess(user);

                        // 重定向到登录后首页
                        Response.Redirect("/Index");
                    }
                }
                else
                {
                    Alert.Show("用户名或密码错误！");
                }
            }
            else
            {
                Alert.Show("用户名或密码错误！");
            }
        }


        private async Task LoginSuccess(User user)
        {
            await RegisterOnlineUserAsync(user.ID);


            // 用户所属的角色字符串，以逗号分隔
            string roleIDs = String.Empty;
            var roleIdList = DB.Query<int>("SELECT RoleID FROM RoleUsers WHERE UserID = @UserID", new { UserID = user.ID });
            if (roleIdList.Count() > 0)
            {
                roleIDs = String.Join(",", roleIdList);
            }



            var claims = new[] { new Claim("UserID", user.ID.ToString()), new Claim("UserName", user.Name), new Claim("RoleIDs", roleIDs) };
            var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            ClaimsPrincipal userInfo = new ClaimsPrincipal(claimsIdentity);

            await HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                userInfo,
                new AuthenticationProperties()
                {
                    IsPersistent = false
                });

            // 与身份绑定的会话缓存必须显式清掉：身份 Cookie 过期后换个账号登进来时，
            // 浏览器的会话还是原来那个，不清就会沿用上一个人的权限列表
            HttpContext.Session.Remove(SK_USER_POWER_LIST);
            HttpContext.Session.Remove(SK_USER_POWER_VERSION);
            HttpContext.Session.Remove(SK_ACTIVE_CHECKED_AT);

        }

        #endregion

    }
}
