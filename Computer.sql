CREATE DATABASE prova
GO

USE prova
GO

CREATE SCHEMA tutorialSchema
GO

CREATE TABLE tutorialSchema.Computer(
	ComputerId INT IDENTITY(1,1) PRIMARY KEY,
	Motherboard NVARCHAR(50),
	CPUCores INT,
	HasWifi BIT,
	HasLTE BIT,
	ReleaseDate DATE,
	Price DECIMAL(18,4),
	VideoCard NVARCHAR(50)
);
