namespace DotnetAPI.Models
{
    public partial class UserJobInfo //'partial' class can be added from another file
    {
        public int UserId {get; set;}
        public string JobTitle {get; set;}
        public string Department {get; set;}
        public UserJobInfo()
        {
            if (JobTitle == null)
                JobTitle = "";
            if (Department == null)
                Department = "";
        }
    }
}