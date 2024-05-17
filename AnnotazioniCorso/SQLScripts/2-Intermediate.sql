/* JOIN: */
SELECT  Users.UserId
        , Users.FirstName + ' ' + Users.LastName AS FullName
        , UserJobInfo.JobTitle
        , UserJobInfo.Department
        , UserSalary.Salary
        , Users.Email
        , Users.Gender
        , Users.Active
  FROM  TutorialAppSchema.Users AS Users
      --JOIN o INNER JOIN lavora solo su righe presenti in entrambe le tabelle
      --LEFT JOIN mostra tutte le righe della left, se right non ha i campi richiesti la select mostra NULL
      JOIN TutorialAppSchema.UserSalary AS UserSalary
          ON UserSalary.UserId = Users.UserId
      LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
          ON UserJobInfo.UserId = Users.UserId
 WHERE  Users.Active = 1
 ORDER BY Users.UserId DESC;

SELECT  UserSalary.UserId
        , UserSalary.Salary
  FROM  TutorialAppSchema.UserSalary AS UserSalary
  --similar to inner join but check if there are rows before returning the table, so it's faster
 WHERE  EXISTS (
                   SELECT   *
                     FROM   TutorialAppSchema.UserJobInfo AS UserJobInfo
                    WHERE   UserJobInfo.UserId = UserSalary.UserId
               )
        AND UserId <> 7; --not equal

/* UNION: */
SELECT  UserId, Salary  FROM  TutorialAppSchema.UserSalary
-- UNION -- between the two queries di default fa la Distinct (se il doppione era già presente nella prima tab rimane)
UNION ALL --mostra anche i doppioni
SELECT  UserId, Salary  FROM  TutorialAppSchema.UserSalary;

/* CLUSTERED INDEX: */
--phisically stores data in order of its key, it allows fast search on the successive queries
CREATE CLUSTERED INDEX cix_UserSalary_UserId
    ON TutorialAppSchema.UserSalary (UserId);

--CREATE NONCLUSTERED INDEX or CREATE INDEX, create a 'dictionary' of {key, CLUSTERED INDEX},
--ordered by key, telling us where to search for that row, it allows fast search on the successive queries
CREATE NONCLUSTERED INDEX ix_Users_Active
    ON TutorialAppSchema.Users (active)
    INCLUDE (Email, FirstName, LastName) --we want to add those fields as well
    --so there will be [active, Email, FirstName, LastName and UserId]
    --it includes UserId by default because it is our clustered Index 
    WHERE active = 1; --we can filter with a where

/*  GROUP BY: */
SELECT  ISNULL (UserJobInfo.Department, 'Empty Department') AS Deparment
        , SUM (UserSalary.Salary) AS Salary
        , MIN (UserSalary.Salary) AS MinSalary
        , MAX (UserSalary.Salary) AS MaxSalary
        , AVG (UserSalary.Salary) AS AvgSalary
        , COUNT (*) AS PeopleInDepartment --conta quante righe finiranno nella stessa riga nell'aggregato
        , STRING_AGG (Users.UserId, ', ') AS UserIds --crea una stringa aggregata simile ad un vettore ( '1', '2', '7')
  FROM  TutorialAppSchema.Users AS Users
      JOIN TutorialAppSchema.UserSalary AS UserSalary
          ON UserSalary.UserId = Users.UserId
      LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
          ON UserJobInfo.UserId = Users.UserId
 WHERE  Users.Active = 1
 GROUP BY UserJobInfo.Department --crea una tabella aggregata per ogni distinct Department
 ORDER BY ISNULL (UserJobInfo.Department, 'No Department Listed') DESC;




SELECT  Users.UserId
        , Users.FirstName + ' ' + Users.LastName AS FullName
        , UserJobInfo.JobTitle
        , UserJobInfo.Department
        , DepartmentAverage.AvgSalary
        , UserSalary.Salary
        , Users.Email
        , Users.Gender
        , Users.Active
  FROM  TutorialAppSchema.Users AS Users
      --INNER JOIN
      JOIN TutorialAppSchema.UserSalary AS UserSalary
          ON UserSalary.UserId = Users.UserId
      LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
          ON UserJobInfo.UserId = Users.UserId
      -- OUTER APPLY ( -- Similar to LEFT JOIN
      CROSS APPLY ( -- Similar to JOIN
                      -- SELECT TOP 1 
                      SELECT    ISNULL (UserJobInfo2.Department, 'No Department Listed') AS Deparment
                                , AVG (UserSalary2.Salary) AS AvgSalary
                        FROM    TutorialAppSchema.UserSalary AS UserSalary2
                            LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo2
                                ON UserJobInfo2.UserId = UserSalary2.UserId
                       WHERE UserJobInfo2.Department = UserJobInfo.Department
                       GROUP BY UserJobInfo2.Department
                  ) AS DepartmentAverage
 WHERE  Users.Active = 1
 ORDER BY Users.UserId DESC;

SELECT  GETDATE ();

SELECT  DATEADD (YEAR, -5, GETDATE ());

SELECT  DATEDIFF (MINUTE, DATEADD (YEAR, -5, GETDATE ()), GETDATE ());  -- Returns Positive

SELECT  DATEDIFF (MINUTE, GETDATE (), DATEADD (YEAR, -5, GETDATE ()));  -- Returns Negative

ALTER TABLE TutorialAppSchema.UserSalary ADD AvgSalary DECIMAL(18, 4);

SELECT  *
  FROM  TutorialAppSchema.UserSalary;

UPDATE  UserSalary
   SET  UserSalary.AvgSalary = DepartmentAverage.AvgSalary
  FROM  TutorialAppSchema.UserSalary AS UserSalary
      LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
          ON UserJobInfo.UserId = UserSalary.UserId
      CROSS APPLY ( -- Similar to JOIN
                      -- SELECT TOP 1 
                      SELECT    ISNULL (UserJobInfo2.Department, 'No Department Listed') AS Deparment
                                , AVG (UserSalary2.Salary) AS AvgSalary
                        FROM    TutorialAppSchema.UserSalary AS UserSalary2
                            LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo2
                                ON UserJobInfo2.UserId = UserSalary2.UserId
                       WHERE ISNULL (UserJobInfo2.Department, 'No Department Listed') = ISNULL (UserJobInfo.Department, 'No Department Listed')
                       GROUP BY UserJobInfo2.Department
                  ) AS DepartmentAverage;

SELECT  Users.UserId
        , Users.FirstName + ' ' + Users.LastName AS FullName
        , UserJobInfo.JobTitle
        , UserJobInfo.Department
        , UserSalary.AvgSalary
        , UserSalary.Salary
        , Users.Email
        , Users.Gender
        , Users.Active
  FROM  TutorialAppSchema.Users AS Users
      --INNER JOIN
      JOIN TutorialAppSchema.UserSalary AS UserSalary
          ON UserSalary.UserId = Users.UserId
      LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
          ON UserJobInfo.UserId = Users.UserId
 WHERE  Users.Active = 1
 ORDER BY Users.UserId DESC;
