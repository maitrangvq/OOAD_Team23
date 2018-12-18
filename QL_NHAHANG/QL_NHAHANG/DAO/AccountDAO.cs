using QL_NHAHANG.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QL_NHAHANG.DAO
{
    public class AccountDAO
    {
        private static AccountDAO instance;
        public static AccountDAO Instance
        {
            get { if (instance == null) instance = new AccountDAO(); return instance; }
            private set {instance = value; }
        }

        private AccountDAO() { }
        public bool Login(string userName,string passWord)
        {
            string query = "USP_Login @userName , @passWord";
            DataTable result = DataProvider.Instance.ExecuteQuery(query,new object[] { userName,passWord});
            return result.Rows.Count > 0 ;
        }

        public bool UpdateAccount(string userName,string disPlayName, string pass,string newPass)
        {
            int result = DataProvider.Instance.ExecuteNonQuery("exec USP_UpdateAccount @userName , @displayName , @passWord , @newPassword ", new object[] { userName, disPlayName, pass, newPass});
            return result > 0;
        }

        public Account GetAccountByUserName(string userName)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("select * from dbo.Account where UserName = '" + userName+"'");
            foreach(DataRow item in data.Rows)
            {
                return new Account(item);
            }
            return null;
        }

    }
    
}
