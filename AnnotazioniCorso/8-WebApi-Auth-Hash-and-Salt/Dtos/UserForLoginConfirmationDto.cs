namespace DotnetAPI.Dtos
{
    public partial class UserForLoginConfirmationDto //'partial' class can be added from another file
    {
        public byte[] PasswordHash {get; set;}
        public byte[] PasswordSalt {get; set;}
        UserForLoginConfirmationDto()
        {
            if (PasswordHash == null)
                PasswordHash = new byte[0];
            if (PasswordSalt == null)
                PasswordSalt = new byte[0];
        }
    }
}