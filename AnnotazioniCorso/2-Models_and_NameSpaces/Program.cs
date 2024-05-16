﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using HelloWorld.Models;

namespace HelloWorld
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Computer myComputer = new Computer() 
            {
                Motherboard = "Z690",
                HasWifi = true,
                HasLTE = false,
                ReleaseDate = DateTime.Now,
                Price = 943.87m, //m auto-cast a number into decimal
                VideoCard = "RTX 2060"
            };

            myComputer.Price = 888.99m; //properties can be changed
            Console.WriteLine(myComputer.Motherboard);
            Console.WriteLine(myComputer.Price);
        }
    }
}
