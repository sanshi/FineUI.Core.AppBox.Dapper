using Dapper;
using FineUI.Core;
using MySql.Data.MySqlClient;
using System;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace FineUI.Core.AppBox.Dapper
{
    public class QueryableBuilder<T> where T : class
    {
        private DynamicParameters _parameters = new DynamicParameters();

        public DynamicParameters Parameters
        {
            get { return _parameters; }
            set { _parameters = value; }
        }

        private List<string> _wheres = new List<string>();

        public List<string> Wheres
        {
            get { return _wheres; }
            set { _wheres = value; }
        }


        private string _fromSql = String.Empty;

        public string FromSql
        {
            get { return _fromSql; }
            set { _fromSql = value; }
        }


        /// <summary>
        /// 添加检索条件
        /// </summary>
        /// <param name="item"></param>
        public void AddWhere(string item)
        {
            _wheres.Add(item);
        }


        /// <summary>
        /// 添加条件参数
        /// </summary>
        /// <param name="name"></param>
        /// <param name="value"></param>
        public void AddParameter(string name, object value)
        {
            _parameters.Add(name, value);
        }

        #region CountAsync

        /// <summary>
        /// 获取总记录数
        /// </summary>
        /// <param name="builder"></param>
        /// <returns></returns>
        /// <summary>
        /// 拼接 ORDER BY 子句。排序字段与方向来自客户端表格状态（随回发上送、可被篡改），
        /// 不能直接拼进 SQL：字段名只接受「标识符」或「表名.标识符」，方向只接受 ASC/DESC，
        /// 不合法即不排序。
        /// </summary>
        private static string BuildOrderBy(Grid grid)
        {
            var field = grid.SortField;
            if (String.IsNullOrEmpty(field) || !Regex.IsMatch(field, @"^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)?$"))
            {
                return String.Empty;
            }

            var direction = "DESC".Equals(grid.SortDirection, StringComparison.OrdinalIgnoreCase) ? "DESC" : "ASC";
            return " ORDER BY " + field + " " + direction;
        }

        public async Task<int> CountAsync()
        {
            var sql = FromSql;
            if (String.IsNullOrEmpty(sql))
            {
                // 约定：类型 User 对应的数据库表名 users
                sql = typeof(T).Name.ToLower() + "s";
            }

            sql = "SELECT COUNT(*) FROM " + sql;

            if (Wheres.Count > 0)
            {
                sql += " WHERE " + String.Join(" AND ", Wheres);
            }

            var conn = BaseModel.GetDbConnection();
            return await conn.QuerySingleOrDefaultAsync<int>(sql, Parameters);
        }

        #endregion

        #region SortAndPageAsync

        /// <summary>
        /// 排序
        /// </summary>
        /// <param name="grid"></param>
        /// <returns></returns>
        public async Task<List<T>> SortAsync(Grid grid)
        {
            // sql: users
            // sql: SELECT * FROM users
            // sql: SELECT onlines.*, Users.Name UserName FROM Onlines INNER JOIN users ON Users.ID = Onlines.UserID
            var sql = FromSql;
            if (String.IsNullOrEmpty(sql))
            {
                // 约定：类型 User 对应的数据库表名 users
                sql = typeof(T).Name.ToLower() + "s";
            }

            if (!sql.StartsWith("SELECT", StringComparison.OrdinalIgnoreCase))
            {
                sql = "SELECT * FROM " + sql;
            }

            if (Wheres.Count > 0)
            {
                sql += " WHERE " + String.Join(" AND ", Wheres);
            }

            sql += BuildOrderBy(grid);

            var conn = BaseModel.GetDbConnection();
            return (await conn.QueryAsync<T>(sql, Parameters)).ToList();
        }



        /// <summary>
        /// 排序和分页
        /// </summary>
        /// <param name="grid"></param>
        /// <returns></returns>
        public async Task<List<T>> SortAndPageAsync(Grid grid)
        {
            // sql: users
            // sql: SELECT * FROM users
            // sql: SELECT onlines.*, Users.Name UserName FROM Onlines INNER JOIN users ON Users.ID = Onlines.UserID

            var sql = FromSql;
            if (String.IsNullOrEmpty(sql))
            {
                // 约定：类型 User 对应的数据库表名 users
                sql = typeof(T).Name.ToLower() + "s";
            }

            if (!sql.StartsWith("SELECT", StringComparison.OrdinalIgnoreCase))
            {
                sql = "SELECT * FROM " + sql;
            }

            if (Wheres.Count > 0)
            {
                sql += " WHERE " + String.Join(" AND ", Wheres);
            }

            sql += BuildOrderBy(grid);

            var conn = BaseModel.GetDbConnection();

            // 分页
            if (conn is MySqlConnection)
            {
                sql += " LIMIT @PageStartIndex, @PageSize";
            }
            else
            {
                sql += " OFFSET @PageStartIndex ROWS FETCH NEXT @PageSize ROWS ONLY";
            }

            Parameters.Add("PageSize", grid.PageSize);
            Parameters.Add("PageStartIndex", grid.PageSize * grid.PageIndex);


            return (await conn.QueryAsync<T>(sql, Parameters)).ToList();
        }


        #endregion
    }
}
