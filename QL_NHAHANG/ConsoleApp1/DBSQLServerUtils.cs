using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
 
 
namespace Tutorial.SqlConn
{
    class DBSQLServerUtils
    {
        
        public static SqlConnection
                 GetDBConnection(string datasource, string database, string username, string password)
        {
            //
            // Data Source=DESKTOP-595V239\SQL;Initial Catalog=simplehr;Persist Security Info=True;User ID=sa;Password=12345
            //
            string connString = @"Data Source=DESKTOP-595V239\SQL;Initial Catalog=QuanLyNhaHang;Integrated Security=True;
 
            SqlConnection conn = new SqlConnection(connString);
 
            return conn;
        }
        
  
    }
}