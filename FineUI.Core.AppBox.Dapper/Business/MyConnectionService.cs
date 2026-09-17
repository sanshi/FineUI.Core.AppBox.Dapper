using Microsoft.Extensions.Configuration;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace FineUI.Core.AppBox.Dapper
{
    /// <summary>
    /// 管理数据库连接实例
    /// Add by sanshi@上思20200217
    /// </summary>
    public class MyConnectionService : IDisposable
    {
        public string DBType { get; set; } = "MySQL";
        public string DBConnectionString { get; set; }

        private IDbConnection _connection { get; set; }

        public MyConnectionService(IConfiguration configuration)
        {
            DBConnectionString = configuration.GetConnectionString(DBType);
        }

        public MyConnectionService(string dbConnectionString)
        {
            DBConnectionString = dbConnectionString;
        }

        /// <summary>
        /// 数据库连接实例
        /// </summary>
        /// <returns></returns>
        public IDbConnection GetDbConnection()
        {
            if (_connection == null)
            {
                // 目前仅MySQL数据库测试通过
                if (DBType == "MySQL")
                {
                    _connection = new MySqlConnection(DBConnectionString);
                }
                else
                {
                    _connection = new SqlConnection(DBConnectionString);
                }

                // 打开数据库连接（在一次 HTTP 请求中，第一次调用 GetDbConnection() 方法时打开数据库连接，当本次 HTTP 结束时才由 Dispose() 负责关闭数据库连接）
                _connection.Open();
            }

            return _connection;
        }

        public void Dispose()
        {
            // 在当前 HTTP 请求结束时释放数据库连接
            if (_connection != null)
            {
                _connection.Dispose();
            }
        }
    }
}
