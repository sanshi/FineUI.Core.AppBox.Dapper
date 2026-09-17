using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using Dapper;
using FineUI.Core;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace FineUI.Core.AppBox.Dapper.Pages.Admin
{
    [CheckPower(Name = "CoreUserView")]
    public partial class UserViewModel : BaseAdminModel
    {
        #region Fields

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
                // 用户所属角色
                var roleNames = await DB.QueryAsync<string>("SELECT Roles.Name FROM RoleUsers LEFT JOIN Roles ON RoleUsers.RoleID = Roles.ID WHERE RoleUsers.UserID = @UserID", new { UserID = CurrentUser.ID });
                labRoles.Text = String.Join(",", roleNames.ToArray());

                // 用户的职称列表
                var titleNames = await DB.QueryAsync<string>("SELECT Titles.Name FROM TitleUsers LEFT JOIN Titles ON TitleUsers.TitleID = Titles.ID WHERE TitleUsers.UserID = @UserID", new { UserID = CurrentUser.ID });
                labTitles.Text = String.Join(",", titleNames.ToArray());


                // 用户所属的部门
                if (CurrentUser.DeptID != null)
                {
                    labDept.Text = CurrentUser.DeptName;
                }

                labEnabled.Text = CurrentUser.Enabled ? "启用" : "禁用";
            }
        }

        #endregion


        #region Events

        

        #endregion
    }
}
