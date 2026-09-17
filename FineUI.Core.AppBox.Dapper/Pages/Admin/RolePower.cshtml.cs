using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Transactions;

using Dapper;
using FineUI.Core;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json.Linq;

namespace FineUI.Core.AppBox.Dapper.Pages.Admin
{
    [CheckPower(Name = "CoreRolePowerView")]
    public partial class RolePowerModel : BaseAdminModel
    {
        #region Fields

        public List<Role> Roles { get; set; }
        public List<GroupPowerViewModel> GroupPowers { get; set; }

        #endregion

        #region Page_Load

        protected async Task Page_LoadAsync(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var powerCoreRolePowerEdit = CheckPower("CoreRolePowerEdit");

                // 根据用户权限控制页面控件的可用状态
                btnGroupUpdate.Enabled = powerCoreRolePowerEdit;


                // 初始化左侧表格（返回左侧表格数据）
                var roles = await LoadGrid1DataAsync();
                if (roles.Count == 0)
                {
                    // 没有数据
                    Alert.Show("请先添加角色！");
                    return;
                }

                // 初始化左侧表格默认选中行
                Grid1.SelectedRowID = roles.First().ID.ToString();


                // 初始化右侧表格

                await LoadGrid2DataAsync();
            }
        }

        private async Task<List<Role>> LoadGrid1DataAsync()
        {
            var q = new QueryableBuilder<Role>();
            var roles = await q.SortAsync(Grid1);

            Grid1.DataSource = roles;
            Grid1.DataBind();

            return roles;
        }

        private async Task LoadGrid2DataAsync()
        {
            // 左侧表格选中的行
            if (String.IsNullOrEmpty(Grid1.SelectedRowID))
            {
                Grid2.DataSource = null;
                Grid2.DataBind();

                return;
            }

            var roleID = Convert.ToInt32(Grid1.SelectedRowID);

            var sql = "SELECT * FROM Powers";
            if (Grid2.SortField == "GroupName")
            {
                sql += " ORDER BY GroupName " + (Grid2.SortDirection == "ASC" ? "asc" : "desc");
            }

            var powerList = new List<string>();
            var powerDictionary = new Dictionary<string, List<Power>>();
            foreach (var p in (await DB.QueryAsync<Power>(sql)).ToList())
            {
                List<Power> powers;
                if (!powerDictionary.TryGetValue(p.GroupName, out powers))
                {
                    powerList.Add(p.GroupName);

                    powers = new List<Power>();
                    powerDictionary[p.GroupName] = powers;
                }

                powers.Add(p);
            }

            var groupPowers = powerList.Select(u => new GroupPowerViewModel
            {
                GroupName = u,
                Powers = new JArray(powerDictionary[u].Select(p =>
                {
                    JObject jo = new JObject();
                    jo.Add("id", p.ID);
                    jo.Add("name", p.Name);
                    jo.Add("title", p.Title);
                    return jo;
                }))
            });

            // 绑定表格数据
            Grid2.DataSource = groupPowers;
            Grid2.DataBind();

            // 更新当前角色的权限
            RegisterStartupScript("updateRolePowers(" + await GetRolePowerIdsAsync(roleID) + ");");
        }

        private async Task<string> GetRolePowerIdsAsync(int roleID)
        {
            // 当前选中角色拥有的权限列表
            var powerIDs = await DB.QueryAsync<int>("SELECT ID FROM Powers INNER JOIN RolePowers ON Powers.ID = RolePowers.PowerID WHERE RolePowers.RoleID = @RoleID", new { RoleID = roleID });
            return new JArray(powerIDs).ToString(Newtonsoft.Json.Formatting.None);
        }

        #endregion

        #region Grid1 Events
        protected async Task Grid1_SortAsync(object sender, GridSortEventArgs e)
        {
            // 左侧表格排序后，选中项清空，需要重新选中第一行
            var roles = await LoadGrid1DataAsync();

            // 默认选中第一个行
            Grid1.SelectedRowID = roles.First().ID.ToString();

            // 重新加载右侧表格数据
            await LoadGrid2DataAsync();
        }

        protected async Task Grid1_RowClickAsync(object sender, GridRowEventArgs e)
        {
            await LoadGrid2DataAsync();
        }

        #endregion

        #region Grid2 Events

        protected async Task Grid2_SortAsync(object sender, GridSortEventArgs e)
        {
            await LoadGrid2DataAsync();
        }

        #endregion

        #region Page_CustomEvent

        protected async Task Page_CustomEventAsync(object sender, CustomEventArgs e)
        {
            var eventName = e.EventName;
            var eventArguments = e.EventArgumentsAsJObject;

            if (eventName == "Grid2_SavePowers")
            {
                // 更新权限
                var powerIDs = eventArguments.Value<JArray>("powerIDs").ToObject<int[]>();

                // 在操作之前进行权限检查
                if (!CheckPower("CoreRolePowerEdit"))
                {
                    CheckPowerFailWithAlert();
                    return;
                }

                if (String.IsNullOrEmpty(Grid1.SelectedRowID))
                {
                    return;
                }
                var roleID = Convert.ToInt32(Grid1.SelectedRowID);

                // 当前角色新的权限列表
                using (var transactionScope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    await DB.ExecuteAsync("DELETE FROM RolePowers WHERE RoleID = @RoleID", new { RoleID = roleID });
                    await DB.ExecuteAsync("INSERT RolePowers (RoleID, PowerID) VALUES (@RoleID, @PowerID)", powerIDs.Select(u => new { PowerID = u, RoleID = roleID }).ToList());

                    transactionScope.Complete();
                }

                // 这个角色下的在线用户，下次请求即按新权限判定
                InvalidatePermissionCaches();

                Alert.ShowInTop("当前角色的权限更新成功！");

                //await LoadGrid2DataAsync();
            }

        }

        #endregion


    }
}