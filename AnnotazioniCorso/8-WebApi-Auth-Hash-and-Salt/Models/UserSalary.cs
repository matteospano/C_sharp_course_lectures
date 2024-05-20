namespace DotnetAPI.Models
{
    public partial class UserSalary //'partial' class can be added from another file
    {
        public int UserId {get; set;}
        public decimal Salary {get; set;} 
    }
}