/* Entity Framework */
using HelloWorld.Models;
using Microsoft.EntityFrameworkCore;

namespace HelloWorld.Data
{
    public class DataContextEF : DbContext
    {
        public DbSet<Computer>? Computer { get; set; } //search for models in the database made as the table "Computer"
        protected override void OnConfiguring(DbContextOptionsBuilder options) //access the connection string and connect to database
        {
            if (!options.IsConfigured)
            {
                //linux&Mec: options.UseSqlServer("Server=localhost;Database=DotNetCourseDatabase;Trusted_connection=false;TrustServerCertificate=True;User Id=sa;Password=SQLConnect1;",
                options.UseSqlServer("Server=localhost;Database=DotNetCourseDatabase;Trusted_Connection=true;TrustServerCertificate=true;",
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