using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QL_NHAHANG.DTO
{
     public class Bill
    {
        public Bill(int id,DateTime? dateCheckIn,DateTime? dateCheckOut,int status,int discount=0)
        {
            this.ID = id;
            this.dateCheckIn = dateCheckIn;
            this.dateCheckOut = dateCheckOut;
            this.Status = status;
            this.Discount = discount;
        }
        public Bill(DataRow row)
        {
            this.ID = (int)row["id"];
            this.dateCheckIn = (DateTime?)row["dateCheckIn"];
            var dateCheckOutTmp = row["dateCheckout"];
            if(dateCheckOutTmp.ToString()!="")
            this.dateCheckOut = (DateTime?)row["dateCheckOut"];
            this.Status = (int)row["status"];

            if(row["discount"].ToString()!="")
                this.Discount = (int)row["discount"];

        }
        private int discount;
        private int Status;
        private int iD;
        private DateTime? dateCheckOut;
        private DateTime? dateCheckIn;

        public DateTime? DateCheckIn { get => dateCheckIn; set => dateCheckIn = value; }
        public DateTime? DateCheckOut { get => dateCheckOut; set => dateCheckOut = value; }
        public int Status1 { get => Status; set => Status = value; }
        public int ID { get => iD; set => iD = value; }
        public int Discount { get => discount; set => discount = value; }
    }
}
