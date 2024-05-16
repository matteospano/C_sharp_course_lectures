/* Entity Framework */
using HelloWorld.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace HelloWorld.Data
{
    public class DataContextEF : DbContext
    {
        private IConfiguration _config;
        public DataContextEF(IConfiguration config)
        {
            _config = config;
        }
        public DbSet<Computer>? Computer { get; set; } //search for models in the database made as the table "Computer"
        protected override void OnConfiguring(DbContextOptionsBuilder options) //access the connection string and connect to database
        {
            if (!options.IsConfigured)
            {
                options.UseSqlServer(_config.GetConnectionString("DefaultConnection"),
                    options => options.EnableRetryOnFailure());
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder) //maps models into actual sql tables
        {
            modelBuilder.HasDefaultSchema("TutorialAppSchema"); //search inside this schema

            modelBuilder.Entity<Computer>().HasKey(c => c.ComputerId); //HasKey defines the primary key, otherwise use HasNoKey()
                // .ToTable("TableName", "SchemaName"); search "TableName", in "SchemaName", not in the default one
        }
        

    }
}