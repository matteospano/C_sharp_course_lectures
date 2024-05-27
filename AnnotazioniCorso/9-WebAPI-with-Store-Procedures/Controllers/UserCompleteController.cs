using DotnetAPI.Data;
using DotnetAPI.Dtos;
using DotnetAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace DotnetAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class UserCompleteController : ControllerBase
{
    DataContextDapper _dapper;
    public UserCompleteController(IConfiguration config)
    {
        _dapper = new DataContextDapper(config);
    }
    
    [HttpGet("TestConnection")]
    public DateTime TestConnection()
    {
        return _dapper.LoadDataSingle<DateTime>("SELECT GETDATE()");
    }

    [HttpGet("GetUsers/{userId}/{isActive}")]
    // public IEnumerable<User> GetUsers()
    public IEnumerable<UserComplete> GetUsers(int userId=0, bool isActive)
    // int userId=0 si può mettere un valore di default che verrà visualizzato nello Swagger
    {
        string sql = @"EXEC TutorialAppSchema.spUsers_Get";
        string parameters = "";
        
        if (userId != 0)
        {
            parameters += ", @UserId=" + userId.ToString();
        }
        if (isActive)
        {
            parameters += ", @Active=" + isActive.ToString();
        }

        if (parameters.Length > 0)
        {
            sql += parameters.TrimStart(','); //o Substring(1) rimuove la virgola iniziale
        }

        IEnumerable<UserComplete> users = _dapper.LoadData<UserComplete>(sql);
        return users;
    }
    
    [HttpPut("UpsertUser")]
    public IActionResult UpdateOrInsert(UserComplete user)
    {
        string sql = @"EXEC TutorialAppSchema.spUser_Upsert
            @FirstName = '" + user.FirstName + 
            "', @LastName = '" + user.LastName +
            "', @Email = '" + user.Email + 
            "', @Gender = '" + user.Gender + 
            "', @Active = '" + user.Active + 
            "', @JobTitle = '" + user.JobTitle + 
            "', @Department = '" + user.Department + 
            "', @Salary = '" + user.Salary + 
            "', @UserId = " + user.UserId;

        if (_dapper.ExecuteSql(sql))
        {
            return Ok();
        } 

        throw new Exception("Failed to Update User");
    }

    [HttpDelete("DeleteUser/{userId}")]
    public IActionResult DeleteUser(int userId)
    {
        string sql = @"TutorialAppSchema.spUser_Delete
            @UserId = " + userId.ToString();

        if (_dapper.ExecuteSql(sql))
        {
            return Ok();
        } 

        throw new Exception("Failed to Delete User");
    }
}
