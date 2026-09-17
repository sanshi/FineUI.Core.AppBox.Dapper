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
    [CheckPower(Name = "CoreMenuNew")]
    public partial class MenuNewModel : BaseAdminModel
    {
        #region Fields

        [BindProperty]
        public Menu Menu { get; set; }

        #endregion


        #region Page_Load

        protected async Task Page_LoadAsync(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                MenuEdit_GetIconItems().ForEach(item => rblIconList.Items.Add(item));


                // 绑定下拉树表格
                await BindParentDDBAsync();
            }
        }

        public List<RadioItem> MenuEdit_GetIconItems()
        {
            List<RadioItem> items = new List<RadioItem>();

            string[] icons = new string[] { "tag_yellow", "tag_red", "tag_purple", "tag_pink", "tag_orange", "tag_green", "tag_blue" };
            foreach (string icon in icons)
            {
                string value = String.Format("~/res/icon/{0}.png", icon);
                RadioItem item = new RadioItem
                {
                    Value = value,
                    TextRawHtml = new RawHtml(String.Format("<img style=\"vertical-align:bottom;\" src=\"{0}\" />&nbsp;{1}", Url.Content(value), icon))
                };

                items.Add(item);
            }

            return items;
        }

        #endregion

        #region BindParentDDBAsync

        private async Task BindParentDDBAsync()
        {
            Grid1.DataSource = await DB.QueryAsync<Menu>("SELECT * FROM Menus ORDER BY SortIndex ASC");
            Grid1.DataBind();
        }


        #endregion


        #region Events

        protected async Task btnSaveClose_ClickAsync(object sender, EventArgs e)
        {
            // http://fineui.com/docs/#/Questions/2000_modelstate
            // 暂时排除 ViewPowerID 属性的服务端验证，下面会单独处理 ViewPowerID 属性
            ModelState.Remove("Menu.ViewPowerID");

            if (!ModelState.IsValid)
            {
                return;
            }

            // 设置父菜单
            if (!String.IsNullOrEmpty(ddbParent.Value))
            {
                int parentID = Convert.ToInt32(ddbParent.Value);
                Menu.ParentID = parentID;
            }
            else
            {
                Menu.ParentID = null;
            }



            var viewPowerName = tbxViewPower.Text;
            if (String.IsNullOrEmpty(viewPowerName))
            {
                Menu.ViewPowerID = null;
            }
            else
            {
                var viewPowerID = await DB.QuerySingleOrDefaultAsync<int?>("SELECT Powers.ID FROM Powers WHERE Powers.Name = @ViewPowerName", new { ViewPowerName = viewPowerName });

                if (viewPowerID != null)
                {
                    Menu.ViewPowerID = viewPowerID;
                }
                else
                {
                    Alert.Show("浏览权限 " + viewPowerName + " 不存在！");
                    return;
                }
            }

            await ExecuteInsertAsync<Menu>(Menu);


            // 关闭本窗体（触发窗体的关闭事件）
            ActiveWindow.HidePostBack();

        }


        #endregion


    }
}
