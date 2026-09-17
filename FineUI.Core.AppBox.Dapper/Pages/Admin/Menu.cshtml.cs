using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using Dapper;
using FineUI.Core;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json.Linq;

namespace FineUI.Core.AppBox.Dapper.Pages.Admin
{
    [CheckPower(Name = "CoreMenuView")]
    public partial class MenuModel : BaseAdminModel
    {
        #region Fields

        public List<Menu> Menus { get; set; }

        #endregion

        #region Page_Load

        protected async Task Page_LoadAsync(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var powerCoreMenuNew = CheckPower("CoreMenuNew");
                var powerCoreMenuEdit = CheckPower("CoreMenuEdit");
                var powerCoreMenuDelete = CheckPower("CoreMenuDelete");

                // 根据用户权限控制页面控件的可用状态
                btnNew.Enabled = powerCoreMenuNew;

                // 行内编辑按钮的权限
                Grid1.FindCommand("Edit").Enabled = powerCoreMenuEdit;
                // 行内删除按钮的权限
                Grid1.FindCommand("Delete").Enabled = powerCoreMenuDelete;


                // 初始化页面控件属性


                await LoadDataAsync();
            }
        }

        private async Task LoadDataAsync()
        {
            Grid1.DataSource = await DB.QueryAsync<Menu>("SELECT * FROM Menus ORDER BY SortIndex ASC");
            Grid1.DataBind();
        }

        #endregion


        #region Events

        protected async Task Window1_CloseAsync(object sender, WindowCloseEventArgs e)
        {
            await LoadDataAsync();
        }




        #endregion


        #region Grid1_RowCommand

        protected async Task Grid1_RowCommandAsync(object sender, GridRowCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                // 删除行
                var rowID = Convert.ToInt32(e.RowID);

                // 在操作之前进行权限检查
                if (!CheckPower("CoreMenuDelete"))
                {
                    CheckPowerFailWithAlert();
                    return;
                }


                int childCount = await DB.QuerySingleOrDefaultAsync<int>("SELECT COUNT(*) FROM Menus WHERE ParentID = @ParentID", new { ParentID = rowID });
                if (childCount > 0)
                {
                    Alert.ShowInTop("删除失败！请先删除子菜单！");
                    return;
                }

                // 从数据库中删除
                await DB.ExecuteAsync("DELETE FROM Menus WHERE ID = @ID", new { ID = rowID });

                await LoadDataAsync();
            }
        }

        #endregion


    }
}
