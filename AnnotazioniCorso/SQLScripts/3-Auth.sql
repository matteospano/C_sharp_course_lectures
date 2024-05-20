USE DotNetCourseDatabase

DROP TABLE IF EXISTS TutorialAppSchema.Users

CREATE TABLE TutorialAppSchema.Users
(
    UserId INT IDENTITY(1, 1) PRIMARY KEY
    , FirstName NVARCHAR(50)
    , LastName NVARCHAR(50)
    , Email NVARCHAR(50)
    , Gender NVARCHAR(50)
    , Active BIT
);

CREATE TABLE TutorialAppSchema.Auth(
	Email NVARCHAR(50) PRIMARY KEY,
	PasswordHash VARBINARY(MAX),
	PasswordSalt VARBINARY(MAX)
)

SELECT * from TutorialAppSchema.Auth
SELECT * from TutorialAppSchema.Users where Users.Email='matteo@prova.com'