

using Dapper;
using FineUI.Core;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Transactions;

namespace FineUI.Core.AppBox.Dapper.Pages.Admin
{
    [CheckPower(Name = "CoreUserNew")]
    public partial class UserNewModel : BaseAdminModel
    {
        #region Fields

        [BindProperty]
        public User CurrentUser { get; set; }

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
            gridDept.DataSource = await DB.QueryAsync<Dept>("SELECT * FROM Depts ORDER BY SortIndex ASC");
            gridDept.DataBind();
        }

        #endregion

        #region InitUserRole

        private async Task InitUserRoleAsync()
        {
            cblRoles.DataSource = await DB.QueryAsync<Role>("SELECT * FROM Roles");
            cblRoles.DataBind();

        }
        #endregion

        #region InitUserTitle

        private async Task InitUserTitleAsync()
        {

            cblTitles.DataSource = await DB.QueryAsync<Title>("SELECT * FROM Titles");
            cblTitles.DataBind();

        }
        #endregion

        #region Events

        protected async Task btnSaveClose_ClickAsync(object sender, EventArgs e)
        {
            if (!ModelState.IsValid)
            {
                return;
            }


            User _user = await DB.QuerySingleOrDefaultAsync<User>("SELECT * FROM Users WHERE Name = @UserName", new { UserName = CurrentUser.Name });
            if (_user != null)
            {
                Alert.Show("用户 " + CurrentUser.Name + " 已经存在！");
                return;
            }

            // 创建保存到数据库的密码
            CurrentUser.Password = PasswordUtil.CreateDbPassword(CurrentUser.Password.Trim());
            CurrentUser.CreateTime = DateTime.Now;
			
            // 添加部门
            if (!String.IsNullOrEmpty(ddbDept.Value))
            {
                CurrentUser.DeptID = Convert.ToInt32(ddbDept.Value);
            }


            using (var transactionScope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                // 插入用户
                var userID = await ExecuteInsertAsync<User>(DB, CurrentUser);

                // 更新用户所属角色
                int[] roleIDs = ddbRoles.Values.Select(u => Convert.ToInt32(u)).ToArray();
                await DB.ExecuteAsync("DELETE FROM RoleUsers WHERE UserID = @UserID", new { UserID = userID });
                await DB.ExecuteAsync("INSERT RoleUsers (UserID, RoleID) VALUES (@UserID, @RoleID)", roleIDs.Select(u => new { UserID = userID, RoleID = u }).ToList());

                // 更新用户所属职务
                int[] titleIDs = ddbTitles.Values.Select(u => Convert.ToInt32(u)).ToArray();
                await DB.ExecuteAsync("DELETE FROM TitleUsers WHERE UserID = @UserID", new { UserID = userID });
                await DB.ExecuteAsync("INSERT TitleUsers (UserID, TitleID) VALUES (@UserID, @TitleID)", titleIDs.Select(u => new { UserID = userID, TitleID = u }).ToList());

                transactionScope.Complete();
            }

            // 新用户带了角色：他本人还没有会话，这里作废是为了与其它改动路径保持一致
            InvalidatePermissionCaches();


            // 关闭本窗体（触发窗体的关闭事件）
            ActiveWindow.HidePostBack();
        }


        #endregion

    }
}
