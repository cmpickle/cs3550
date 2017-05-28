--Cruise Line Creation Script 
--Cameron Pickle 5/25/2017
--Comments

USE Master --switch to Master DB

IF EXISTS (SELECT * FROM sysdatabases WHERE name = 'Pickle_Ship') 
DROP DATABASE Pickle_Ship

GO --Pause (make sure stuff above finished) 

CREATE DATABASE Pickle_Ship 
ON PRIMARY 
(
	NAME = 'Pickle_Ship',
	FILENAME = 'C:\stage\Pickle_Ship.mdf',  --Change the path for local    
	SIZE = 12MB, -- 500kb, 500, TB, GB    
	MAXSIZE =  50 MB,    
	FILEGROWTH = 10% -- 5MB 
)
 
LOG ON 
(NAME = 'Pickle_Ship_Log',
	FILENAME = 'C:\stage\Pickle_Ship.ldf',  --Change the path for local
      SIZE = 4MB, -- 500kb, 500, TB, GB  -- 10% Read 25% R/Write
      MAXSIZE =  13MB,
	  FILEGROWTH = 10% -- 5MB 
 ) 
GO 
-- With the Pickle_Ship database now created, switch to it and begin creating the individual 
-- tables for the database

USE Pickle_Ship

CREATE TABLE Ship 
( 
ShipID			smallint		NOT NULL	IDENTITY(1,1),
ShipName		varchar(20)		NOT NULL,
ShipYearBuilt	char(4)			NOT NULL, 
ShipWeight		int				NOT NULL,
ShipCapacity	smallint		NOT NULL 
)

CREATE TABLE Employee 
( 
EmpID			smallint		NOT NULL	IDENTITY(1,1),
EmpName			varchar(20)		NOT NULL, 
EmpDOB			smalldatetime	NOT NULL,
EmpNationality	varchar(20)		NOT NULL, 
ShipID			smallint		NOT NULL,
EmpSupervisorID smallint		NULL 
)
-- Ensure that the script to create tables has finished 
-- before altering tables and adding in constraints 
GO

-- Alter each of the tables add the PK CONSTRAINTS 
ALTER TABLE Ship
	ADD CONSTRAINT PK_ShipID 
	PRIMARY KEY (ShipID)

ALTER TABLE Employee
	ADD CONSTRAINT PK_EmpID 
	PRIMARY KEY (EmpID)
	
-- Ensure PKs have been created before moving on to FKs 
GO

-- Alter tables to set up foreign keys 
ALTER TABLE Employee
	ADD CONSTRAINT FK_EmpWorksonShip 
	FOREIGN KEY (ShipID) REFERENCES Ship(ShipID) 
	ON UPDATE Cascade 
	ON DELETE Cascade, --NO Action
	
	CONSTRAINT FK_SupervisorIsEmployee 
	FOREIGN KEY (EmpSupervisorID) REFERENCES Employee (EmpID) 
	ON UPDATE No Action 
	ON DELETE No Action
	
-- ensure that foreign keys are set up, then move on to check constraints 
GO

ALTER TABLE Employee
	ADD CONSTRAINT CK_EmployeeNationality 
	CHECK (EmpNationality IN ('USA', 'Canada', 'Mexico'))
	
-- ensures that a ship is built in the 21st century
ALTER TABLE Ship
	ADD CONSTRAINT CK_ShipYearBuilt 
	CHECK (ShipYearBuilt >= 2000)
	
GO 

-- finally, add defaults
ALTER TABLE Employee
	ADD CONSTRAINT DK_DefaultSupervisor 
	DEFAULT 0 FOR EmpSupervisorID