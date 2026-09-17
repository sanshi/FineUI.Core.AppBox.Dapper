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
    public partial class ChangePasswordModel : BaseAdminModel
    {
        #region Fields



        #endregion

        #region Page_Load

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

            }
        }

        #endregion


        #region Events

        protected async Task btnSave_ClickAsync(object sender, EventArgs e)
        {
            int? id = GetIdentityID();

            // 检查当前密码是否正确
            string oldPass = tbxOldPassword.Text.Trim();
            string newPass = tbxNewPassword.Text.Trim();
            string confirmNewPass = tbxConfirmNewPassword.Text.Trim();

            if (newPass != confirmNewPass)
            {
                tbxConfirmNewPassword.MarkInvalid("确认密码和新密码不一致！");
                return;
            }
            
            //User user = await DB.QuerySingleOrDefaultAsync<User>("SELECT * FROM Users WHERE ID = @UserID", new { UserID = id });
            User current = await FindByIDAsync<User>(id.Value);

            if (current != null)
            {
                if (!PasswordUtil.ComparePasswords(current.Password, oldPass))
                {
                    tbxOldPassword.MarkInvalid("当前密码不正确！");
                }
                else
                {
                    current.Password = PasswordUtil.CreateDbPassword(newPass);
                    //await DB.ExecuteAsync("UPDATE Users SET Password = @Password WHERE ID = @ID", current);
                    await ExecuteUpdateAsync<User>(current, "Password");

                    Alert.ShowInTop("修改密码成功！");
                }
            }
            
        }


        #endregion


    }
}