namespace DotnetAPI.Dtos
{
    //DTO: data transfer object. It's a piece of another object used only to tranfer data as a RequestBody or a ResponseBody
    public partial class UserToAddDto
    {
        public string FirstName {get; set;}
        public string LastName {get; set;}
        public string Email {get; set;}
        public string Gender {get; set;}
        public bool Active {get; set;}

        public UserToAddDto()
        {
            if (FirstName == null)
                FirstName = "";
            if (LastName == null)
                LastName = "";
            if (Email == null)
                Email = "";
            if (Gender == null)
                Gender = "";
        }
    }
}