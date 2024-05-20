/* creazione database, schema, tabella, tipo di variabili,SELECT, INSERT, UPDATE, ALTER, DELETE e TRUNCATE */
CREATE DATABASE DotNetCourseDatabase;
GO

USE DotNetCourseDatabase;
GO

CREATE SCHEMA TutorialAppSchema;
GO

CREATE TABLE TutorialAppSchema.Computer
(
    -- TableId INT  IDENTITY(Starting value, Increment By) 
    ComputerId INT IDENTITY(1, 1) PRIMARY KEY
    -- CHAR(10) se voglio assegnarli il valore 'aaa' sarà un vettore di 10 char così: 'aaa       '
    -- VARCHAR(10) assegna effettivamente il valore 'aaa' se ha lunghezza <=10
    -- NVARCHAR(255) uguale a VARCHAR ma accetta anche caratteri non UNICODE, e costa il doppio dei Byte
    , Motherboard NVARCHAR(50)
    , CPUCores INT --NOT NULL
    , HasWifi BIT --0/1 replaces the Boolean
    , HasLTE BIT
    , ReleaseDate DATETIME --DATE senza time ma non compatibile con c#, DATETIME completo, DATETIME2 precisione al ms
    , Price DECIMAL(18, 4) --18 parte intera, 4 decimali
    , VideoCard NVARCHAR(50)
);
GO

SELECT  [ComputerId]
        , [Motherboard]
        , ISNULL ([CPUCores], 4) AS CPUCores --cambia solo la tab visualizzata, non i dati veri, CPUCores rimane NULL sul DB
        , [HasWifi]
        , [HasLTE]
        , [ReleaseDate]
        , [Price]
        , [VideoCard]
  FROM  TutorialAppSchema.Computer
   ORDER BY
    HasLTE --campo principale di ordinamento
    , ReleaseDate DESC; --ordinamento secondario (DESC: dal più recente al più vecchio)

--per forzare l'inserimento anche della primary key (es copiando una tab non completa)
--SET IDENTITY_INSERT TutorialAppSchema.Computer ON 
--INSERT INTO TutorialAppSchema.Computer ([ComputerId], [Motherboard], ...)
--poi bisogna spegnerlo per far funzionare di nuovo la IDENTITY primary key
--SET IDENTITY_INSERT TutorialAppSchema.Computer OFF

INSERT INTO TutorialAppSchema.Computer ([Motherboard]
                                        , [CPUCores]
                                        , [HasWifi]
                                        , [HasLTE]
                                        , [ReleaseDate]
                                        , [Price]
                                        , [VideoCard])
VALUES ('Sample-Motherboard'
        , 4
        , 1  -- true
        , 0  -- false
        , GETDATE ()
        , 1000.28
        , 'Sample-VideoCard');

UPDATE  TutorialAppSchema.Computer
   SET  Motherboard = 'Obsolete'
 WHERE  HasWifi = 0;

--altera la tabella aggiungendo la colonna <nome tipo> con valori tutti NULL
 ALTER TABLE TutorialAppSchema.Computer ADD HasDvdReader BIT

 -- DELETE FROM TutorialAppSchema.Computer WHERE ReleaseDate > '2018-10-31'
 -- WHERE ReleaseDate IN ('2018-10-25', '2018-10-31') non restituisce un range ma i valori specifici
 -- nell'array, come se avessi fatto una query per ogni valore.
--When we use BETWEEN we also include the Lower and Upper Bound of the value we're checking
DELETE  FROM TutorialAppSchema.Computer WHERE  ComputerId BETWEEN 500 AND 1000; --501 Rows affected

--svuota tabella
TRUNCATE TABLE TutorialAppSchema.Computer;

/* date functions */
SELECT  GETDATE (); --return current time of the server
SELECT  DATEADD (YEAR, -5, GETDATE ()); --add/subtract (type, number, from date)
SELECT DATEDIFF(YEAR, DATEADD (YEAR, -5, GETDATE ()), GETDATE()) AS yearsOfDifference