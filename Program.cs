using System;
using System.Data;
using System.Globalization;
using System.Text.RegularExpressions;
using Dapper;
using HelloWorld.Data;
using HelloWorld.Models;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace HelloWorld
{
    internal class Program
    {
        static void Main(string[] args)
        {
            IConfiguration config = new ConfigurationBuilder().AddJsonFile("appSettings.json").Build();
            DataContextDapper dapper = new DataContextDapper(config);
            DataContextEF entityFramework = new DataContextEF(config);

            DateTime rightNow = dapper.LoadDataSingle<DateTime>("SELECT GETDATE()");
            // Console.WriteLine(rightNow.ToString());

            Computer myComputer = new Computer()
            {
                ComputerId = 0,
                Motherboard = "Z690",
                HasWifi = true,
                HasLTE = false,
                ReleaseDate = DateTime.Now,
                Price = 943.87m,
                VideoCard = "RTX 2060"
            };

            Console.WriteLine(myComputer.ComputerId);

            /* Entity Framework */
            // entityFramework.Add(myComputer);
            // entityFramework.SaveChanges();

            string sql = @"INSERT INTO tutorialSchema.Computer (
                Motherboard,
                HasWifi,
                HasLTE,
                ReleaseDate,
                Price,
                VideoCard
            ) VALUES ('" + myComputer.Motherboard
                    + "','" + myComputer.HasWifi
                    + "','" + myComputer.HasLTE
                    + "','" + myComputer.ReleaseDate.ToString("yyyy-MM-dd")
                    + "','" + myComputer.Price.ToString("0.00", CultureInfo.InvariantCulture)
                    + "','" + myComputer.VideoCard
            + "')";

            bool result = dapper.ExecuteSql(sql);
            // Console.WriteLine(result);

            string sqlSelect = @"
            SELECT 
                Computer.ComputerId,
                Computer.Motherboard,
                Computer.HasWifi,
                Computer.HasLTE,
                Computer.ReleaseDate,
                Computer.Price,
                Computer.VideoCard
             FROM tutorialSchema.Computer";

            IEnumerable<Computer> computers = dapper.LoadData<Computer>(sqlSelect);

            /* generare un file di output */
            //File.WriteAllText("log.txt", "\n" + sql + "\n"); //non fa l'append, ricera il file ogni volta
            using StreamWriter openFile = new("log.txt", append: true);
            openFile.WriteLine("Dapper:");
            openFile.WriteLine("'ComputerId','Motherboard','HasWifi','HasLTE','ReleaseDate'" + ",'Price','VideoCard'");

            foreach (Computer singleComputer in computers)
            {
                openFile.WriteLine("'" + singleComputer.ComputerId
                    + "','" + singleComputer.Motherboard
                    + "','" + singleComputer.HasWifi
                    + "','" + singleComputer.HasLTE
                    + "','" + singleComputer.ReleaseDate.ToString("yyyy-MM-dd")
                    + "','" + singleComputer.Price.ToString("0.00", CultureInfo.InvariantCulture)
                    + "','" + singleComputer.VideoCard + "'");
            }

            /* Entity Framework */
            // IEnumerable<Computer>? computersEf = entityFramework.Computer?.ToList<Computer>();
            // if (computersEf != null)
            // {
            //     openFile.WriteLine("Entity Framework:");
            //     openFile.WriteLine("'ComputerId','Motherboard','HasWifi','HasLTE','ReleaseDate'" + ",'Price','VideoCard'");
            //     foreach(Computer singleComputer in computersEf)
            //     {
            //         openFile.WriteLine("'" + singleComputer.ComputerId 
            //             + "','" + singleComputer.Motherboard
            //             + "','" + singleComputer.HasWifi
            //             + "','" + singleComputer.HasLTE
            //             + "','" + singleComputer.ReleaseDate.ToString("yyyy-MM-dd")
            //             + "','" + singleComputer.Price.ToString("0.00", CultureInfo.InvariantCulture)
            //             + "','" + singleComputer.VideoCard + "'");
            //     }
            // }

            openFile.Close();
        }
    }
}