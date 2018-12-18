﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QL_NHAHANG.DTO
{
     public class Table
    {
        public Table(int id, string name,string status)
        {
            this.ID = id;
            this.Name = name;
            this.Status = status;
        }
        private string status;
        private string name;
        private int iD;

        public int ID { get => iD; set => iD = value; }
        public string Name { get => name; set => name = value; }
        public string Status { get => status; set => status = value; }
        public Table(DataRow row)
        {
            this.ID = (int)row["id"];
            this.name = row["name"].ToString();
            this.status = row["status"].ToString();
        }
    }
}