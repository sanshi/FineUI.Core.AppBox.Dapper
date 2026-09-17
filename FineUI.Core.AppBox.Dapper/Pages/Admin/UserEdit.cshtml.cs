using Dapper;
using FineUI.Core;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Transactions;

namespace FineUI.Core.AppBox.Dapper.Pages.Admin
{
    [CheckPower(Name = "CoreUserEdit")]
    public partial class UserEditModel : BaseAdminModel
    {
        #region Fields
        
        [BindProperty]
        public User CurrentUser { get; set; }

        #endregion

        #region OnGet

        public async Task<IActionResult> OnGetAsync(int id)
        {
            CurrentUser = await GetUserByIDAsync(id);

            if (CurrentUser == null)
            {
                return Content("无效参数！");
            }

            if (CurrentUser.Name == "admin" && GetIdentityName() != "admin")
            {
                return Content("你无权编辑超级管理员！");
            }

            return Page();
        }


        #endregion

        #region Page_Load

        protected async Task Page_LoadAsync(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 初始化用户所属的角色
                await InitUserRoleAsync();

                // 初始化用户拥有的职称
                await InitUserTitleAsync();

                // 初始化用户所属的部门
                await InitUserDeptAsync();

            }
        }

        #endregion

        #region InitUserDept

        private async Task InitUserDeptAsync()
        {
            // 用户所属部门
            if (CurrentUser.DeptID != null)
            {
                ddbDept.Value = CurrentUser.DeptID.ToString();
                ddbDept.Text = CurrentUser.DeptName;
            }

            gridDept.DataSource = await DB.QueryAsync<Dept>("SELECT * FROM Depts ORDER BY SortIndex ASC");
            gridDept.DataBind();
        }

        #endregion

        #region InitUserRole

        private async Task InitUserRoleAsync()
        {
            // 用户所属角色
            var roles = await DB.QueryAsync<Role>("SELECT * FROM Roles INNER JOIN RoleUsers ON Roles.ID = RoleUsers.RoleID WHERE RoleUsers.UserID = @UserID", new { UserID = CurrentUser.ID });
            if (roles.Count() > 0)
            {
                ddbRoles.Values = roles.Select(u => u.ID.ToString()).ToArray();
                ddbRoles.Texts = roles.Select(u => u.Name).ToArray();
            }

            cblRoles.DataSource = await DB.QueryAsync<Role>("SELECT * FROM Roles");
            cblRoles.DataBind();

        }
        #endregion

        #region InitUserTitle

        private async Task InitUserTitleAsync()
        {
            // 用户拥有职称
            var titles = await DB.QueryAsync<Title>("SELECT * FROM Titles INNER JOIN TitleUsers ON Titles.ID = TitleUsers.TitleID WHERE TitleUsers.UserID = @UserID", new { UserID = CurrentUser.ID });
            if (titles.Count() > 0)
            {
                ddbTitles.Values = titles.Select(u => u.ID.ToString()).ToArray();
                ddbTitles.Texts = titles.Select(u => u.Name).ToArray();
            }

            cblTitles.DataSource = await DB.QueryAsync<Title>("SELECT * FROM Titles");
            cblTitles.DataBind();
        }
        #endregion

        #region Events

        protected async Task btnSaveClose_ClickAsync(object sender, EventArgs e)
        {
            // 不对 Name 和 Password 进行模型验证
            ModelState.Remove("CurrentUser.Name");
            ModelState.Remove("CurrentUser.Password");

            if (!ModelState.IsValid)
            {
                return;
            }

            // 更新部分字段（先从数据库检索用户，再覆盖用户输入值，注意没有更新Name，Password，CreateTime等字段）
            var _user = await GetUserByIDAsync(CurrentUser.ID);

            // 回发带回来的主键是页面上的隐藏字段，可以被篡改，所以要把 OnGet 里的那两道判断原样再做一遍：
            // 只在打开页面时判过，拥有编辑权限的普通用户改一下隐藏字段就能编辑超级管理员
            if (_user == null)
            {
                Alert.Show("无效参数！");
                return;
            }

            if (_user.Name == "admin" && GetIdentityName() != "admin")
            {
                Alert.Show("你无权编辑超级管理员！");
                return;
            }

            _user.ChineseName = CurrentUser.ChineseName;
            _user.Gender = CurrentUser.Gender;
            _user.Enabled = CurrentUser.Enabled;
            _user.Email = CurrentUser.Email;
            _user.CompanyEmail = CurrentUser.CompanyEmail;
            _user.OfficePhone = CurrentUser.OfficePhone;
            _user.OfficePhoneExt = CurrentUser.OfficePhoneExt;
            _user.HomePhone = CurrentUser.HomePhone;
            _user.CellPhone = CurrentUser.CellPhone;
            _user.Remark = CurrentUser.Remark;

            // 如果选择了部门，则更新部门ID，否则设置为null
            if (!String.IsNullOrEmpty(ddbDept.Value))
            {
                _user.DeptID = Convert.ToInt32(ddbDept.Value);
            }
            else
            {
                _user.DeptID = null;
            }

            using (var transactionScope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                // 更新用户
                await ExecuteUpdateAsync<User>(DB, _user);

                // 更新用户所属角色
                int[] roleIDs = ddbRoles.Values.Select(u => Convert.ToInt32(u)).ToArray();
                await DB.ExecuteAsync("DELETE FROM RoleUsers WHERE UserID = @UserID", new { UserID = _user.ID });
                await DB.ExecuteAsync("INSERT RoleUsers (UserID, RoleID) VALUES (@UserID, @RoleID)", roleIDs.Select(u => new { UserID = _user.ID, RoleID = u }).ToList());

                // 更新用户所属职务
                int[] titleIDs = ddbTitles.Values.Select(u => Convert.ToInt32(u)).ToArray();
                await DB.ExecuteAsync("DELETE FROM TitleUsers WHERE UserID = @UserID", new { UserID = _user.ID });
                await DB.ExecuteAsync("INSERT TitleUsers (UserID, TitleID) VALUES (@UserID, @TitleID)", titleIDs.Select(u => new { UserID = _user.ID, TitleID = u }).ToList());


                transactionScope.Complete();
            }

            // 用户的角色集合变了，其在线会话的权限缓存作废
            InvalidatePermissionCaches();

            // 关闭本窗体（触发窗体的关闭事件）
            ActiveWindow.HidePostBack();

        }

        #endregion

    }
}
