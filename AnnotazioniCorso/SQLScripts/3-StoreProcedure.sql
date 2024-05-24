 /* Creo in una store procedure e con una temp Table l'ultimo punto della sezione Intermediate: */
CREATE OR ALTER PROCEDURE TutorialAppSchema.sp_selectUsers --si crea con CREATE, si modifica con ALTER
    --ritrovo le store proc nella cartellaa Programmability
    @UserId INT=NULL,
    @IsActive BIT=NULL
--elenco parametri tipizzati, si può aggiungere anche un valore di default
-- EXEC TutorialAppSchema.sp_selectUsers @UserId=1 per fare la run della store procedure
-- EXEC TutorialAppSchema.sp_selectUsers @IsActive=1 secondo esempio di run per tutti gli utenti active
AS
BEGIN

    DROP TABLE IF EXISTS #AvgTable
    SELECT ISNULL (UserJobInfo2.Department, 'No Department Listed') AS Deparment
            , AVG (UserSalary2.Salary) AS AvgSalary
    INTO #AvgTable
    --# per tab temp, ## per tab temp accessibile anche fuori da questa query
    FROM TutorialAppSchema.UserSalary AS UserSalary2
        LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo2
        ON UserJobInfo2.UserId = UserSalary2.UserId
        LEFT JOIN TutorialAppSchema.Users AS Users2
        ON Users2.UserId = UserSalary2.UserId
    WHERE UserJobInfo2.Department = UserJobInfo2.Department
    AND Users2.Active = ISNULL(@IsActive, Users2.Active) --posso restituire la media su tutti o solo sugli active
    GROUP BY UserJobInfo2.Department

    SELECT Users.UserId
        , Users.FirstName + ' ' + Users.LastName AS FullName
        , UserJobInfo.JobTitle
        , UserJobInfo.Department
        , DepartmentAverage.AvgSalary
        , UserSalary.Salary
        , Users.Email
        , Users.Gender
        , Users.Active
    FROM TutorialAppSchema.Users AS Users
        JOIN TutorialAppSchema.UserSalary AS UserSalary
        ON UserSalary.UserId = Users.UserId
        LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
        ON UserJobInfo.UserId = Users.UserId
        LEFT JOIN #AvgTable AS DepartmentAverage
        ON DepartmentAverage.Deparment = UserJobInfo.Department
    WHERE Users.UserId=ISNULL(@UserId, Users.UserId)
        AND Users.Active = ISNULL(@IsActive, Users.Active)
    ORDER BY UserJobInfo.Department DESC;
END

/* Store procedude per inserimento nelle 3 tab degli utenti */
USE DotNetCourseDatabase
GO

CREATE OR ALTER PROCEDURE TutorialAppSchema.sp_insertOrUpdateUserbyEmail
    /* es. update*/
    -- EXEC TutorialAppSchema.sp_insertOrUpdateUserbyEmail
    -- @Email='prov@ciao.com', @FirstName='Marta',@LastName='Provola', @Salary='1500',
    -- @Gender='Female',@Active=1, @JobTitle='Segrataria', @Department='SAP'
    /* es. insert*/
    -- EXEC TutorialAppSchema.sp_insertOrUpdateUserbyEmail
    -- @Email='nuova@ciao.com', @FirstName='Nuova',@LastName='Persona', @Salary='1500',
    -- @Gender='Female',@Active=1, @JobTitle='Segrataria', @Department='SAP'

    @Email NVARCHAR(50),
    --parametro mandatory, se assente la sp va in errore
    @FirstName NVARCHAR(50)= NULL,
    @LastName NVARCHAR(50)= NULL,
    @Gender NVARCHAR(50)= NULL,
    @Active BIT=NULL,
    @JobTitle NVARCHAR(50)= NULL,
    @Department NVARCHAR(50)= NULL,
    @Salary DECIMAL(18, 4) NULL
AS
BEGIN
    IF NOT EXISTS (SELECT Email
    FROM Users AS u
    WHERE u.Email=@Email) --nuova email-> inserimento nuovo user
BEGIN

        DECLARE @lastCreatedUserID INT
        INSERT INTO Users
            (FirstName,LastName,Email,Gender,Active)
        VALUES
            (@FirstName, @LastName, @Email, @Gender, @Active)
        SET @lastCreatedUserID = @@IDENTITY --id of the last insert row

        INSERT INTO UserJobInfo
            (UserId,JobTitle,Department)
        VALUES
            (@lastCreatedUserID, @JobTitle, @Department)

        INSERT INTO UserSalary
            (UserId,Salary)
        VALUES
            (@lastCreatedUserID, @Salary)

    END



ELSE --email presente-> edit user
BEGIN

        DECLARE @UserID INT = 
        (SELECT UserID FROM Users WHERE Users.Email=@Email)

        UPDATE Users SET
FirstName=@FirstName,LastName=@LastName,Email=@Email,Gender=@Gender,Active=@Active
WHERE Users.Email=@Email

        UPDATE UserJobInfo SET JobTitle=@JobTitle,Department=@Department
WHERE UserJobInfo.UserId=@UserID

        UPDATE UserSalary SET Salary=@Salary
WHERE UserSalary.UserId=@UserID

    END

    /* mostra risultato: */
    --EXEC TutorialAppSchema.sp_selectUsers @UserId=1
    SELECT Users.UserId
        , Users.FirstName + ' ' + Users.LastName AS FullName
        , UserJobInfo.JobTitle
        , UserJobInfo.Department
        , UserSalary.Salary
        , Users.Email
        , Users.Gender
        , Users.Active
    FROM TutorialAppSchema.Users AS Users
        JOIN TutorialAppSchema.UserSalary AS UserSalary
        ON UserSalary.UserId = Users.UserId
        LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
        ON UserJobInfo.UserId = Users.UserId
    WHERE Users.Email= @Email

END