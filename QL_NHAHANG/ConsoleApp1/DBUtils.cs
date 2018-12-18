using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace Tutorial.SqlConn
{
    class DBUtils
    {
        public static SqlConnection GetDBConnection()
        {
            string datasource = @"DESKTOP-595V239\SQL";

            string database = "QLNhaHang";
            string username = "admin";
            string password = "123";

            return DBSQLServerUtils.GetDBConnection(datasource, database, username, password);
        }
    }

}
