using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QL_NHAHANG.DTO
{
    public class BillInfo
    {
        public BillInfo(int id ,int billID,int foodID,int count)
        {
            this.billID = id;
            this.BillID = billID;
            this.foodID = foodID;
            this.count = count;
        }
        public BillInfo(DataRow row)
        {
            this.billID = (int)row["id"] ;
            this.BillID = (int)row["idBill"];
            this.foodID = (int)row["idFood"];
            this.count = (int)row["count"];
        }
        private int iD;
        private int billID;
        private int foodID;
        private int count;

        public int BillID { get => billID; set => billID = value; }
        public int FoodID { get => foodID; set => foodID = value; }
        public int Count { get => count; set => count = value; }
        public int ID { get => iD; set => iD = value; }
    }
}
