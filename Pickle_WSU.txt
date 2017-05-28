--WSU Registration Database Creation Script 
--Cameron Pickle 5/25/2017
--This creates the WSU database that keeps track of WSU's semesters, courses, students, and staff

USE Master --switch to Master DB

IF EXISTS (SELECT * FROM sysdatabases WHERE name = 'Pickle_WSU') 
DROP DATABASE Pickle_WSU

GO --Pause (make sure stuff above finished) 

CREATE DATABASE Pickle_WSU 
ON PRIMARY 
(
	NAME = 'Pickle_WSU',
	FILENAME = 'C:\stage\Pickle_WSU.mdf',  --Change the path for local    
	SIZE = 10MB, -- 500kb, 500, TB, GB    
	MAXSIZE =  50MB,    
	FILEGROWTH = 10% -- 5MB 
)
 
LOG ON 
(NAME = 'Pickle_WSU_Log',
	FILENAME = 'C:\stage\Pickle_WSU.ldf',  --Change the path for local
      SIZE = 2500KB, -- 500kb, 500, TB, GB  -- 10% Read 25% R/Write
      MAXSIZE =  13MB,
	  FILEGROWTH = 10% -- 5MB 
 ) 
GO 
-- With the Pickle_WSU database now created, switch to it and begin creating the individual 
-- tables for the database

USE Pickle_WSU

CREATE TABLE Semester
( 
SemesterSeason		char(6)			NOT NULL,
SemesterYear		tinyInt			NOT NULL,
SemesterStartDate	date			NOT NULL, 
SemesterEndDate		date			NOT NULL
)

CREATE TABLE ScheduleOfCourses
( 
ScheduleNo		smallint		NOT NULL	IDENTITY(1,1),
SemesterSeason	char(6)			NOT NULL, 
SemesterYear	tinyInt			NOT NULL,
CourseID		varchar(10)		NOT NULL, 
LecturerID		char(9)			NOT NULL
)

CREATE TABLE Course
(
CourseID			varchar(10)		NOT NULL,
CourseTitle			varchar(30)		NOT NULL,
CourseDescription	varchar(300)	NOT NULL,
CourseCredits		tinyInt			NOT NULL
)

CREATE TABLE Prerequisite
(
PrerequisiteNo	int			NOT NULL,
CourseID		varchar(10)	NOT NULL,
PrerequisteID	char(10)	NOT NULL
)

CREATE TABLE Lecturer
(
LecturerID	char(9)		NOT NULL,
StaffID		char(9)		NOT NULL
)

CREATE TABLE Staff
(
StaffID					char(9)		NOT NULL,
StaffOfficeNumber		smallInt	NULL,
SocialSecurityNumber	char(9)		NOT NULL,
Salary					smallmoney	NOT NULL,
StaffHireDate			date		NOT NULL
)

CREATE TABLE Person
(
SocialSecurityNumber	char(9)			NOT NULL,
PersonFirstName			nvarchar(30)	NOT NULL,
PersonMiddleInitial		nvarchar(3)		NULL,
PersonLastName			nvarchar(30)	NOT NULL,
PersonPhone				char(10)		NULL,
PersonEmail				varchar(50)		NOT NULL,
PersonAddress			varchar(30)		NOT NULL,
PersonZIP				char(5)			NOT NULL,
PersonDOB				char(10)		NOT NULL,
PersonGender			char(1)			NULL
)

CREATE TABLE Student
(
WNumber					char(9)			NOT NULL,
StudentGPA				decimal(10,2)	NULL,
SocialSecurityNumber	char(9)			NOT NULL,
StudentMajor			varchar(20)		NULL,
StudentEnrollDate		date			NOT NULL
)

CREATE TABLE Registration
(
ScheduledCourseNo		int			NOT NULL,
WNumber					char(9)		NOT NULL,
RegistrationTuition		smallmoney	NULL,
RegistrationPaid		char(1)		NULL
)

CREATE TABLE ScheduledCourse
(	
ScheduledCourseNo	int				NOT NULL	IDENTITY(1,1),
ScheduleNo			int				NOT NULL,
StudentGrade		decimal(5,2)	NULL
)

CREATE TABLE UserAccount
(
UserId					char(10)		NOT NULL,
Username				varchar(30)		NOT NULL,
UserPassword			varchar(30)		NOT NULL,
SocialSecurityNumber	char(9)			NOT NULL,
AccessLevel				tinyInt			NOT NULL
)

CREATE TABLE AccessLevel
(
AccessLevel			tinyInt			NOT NULL,
AccessLevelTitle	varchar(20)		NOT NULL
)

CREATE TABLE LoginHistory
(
UserID			char(10)		NOT NULL,
LoginSessionNo	char(10)		NOT NULL,
LoginTime		datetime2(7)	NOT NULL,
LogoutTime		datetime2(7)	NULL
)

-- Ensure that the script to create tables has finished 
-- before altering tables and adding in constraints 
GO

-- Alter each of the tables add the PK CONSTRAINTS 
ALTER TABLE Semester
	ADD CONSTRAINT PK_Semester
	PRIMARY KEY (SemesterSeason, SemesterYear)

ALTER TABLE ScheduleOfCourses
	ADD CONSTRAINT PK_ScheduleNumber 
	PRIMARY KEY (ScheduleNo)

ALTER TABLE Course
	ADD CONSTRAINT PK_CourseID 
	PRIMARY KEY (CourseID)

ALTER TABLE Prerequisite
	ADD CONSTRAINT PK_PrerequisiteNumber
	PRIMARY KEY (PrerequisiteNo)

ALTER TABLE Lecturer
	ADD CONSTRAINT PK_LecturerID
	PRIMARY KEY (LecturerID)

ALTER TABLE Staff
	ADD CONSTRAINT PK_StaffID
	PRIMARY KEY (StaffID)

ALTER TABLE Person
	ADD CONSTRAINT PK_PersonSocialSecurityNumber
	PRIMARY KEY (SocialSecurityNumber)

ALTER TABLE Student
	ADD CONSTRAINT PK_StudentWNumber
	PRIMARY KEY (WNumber)

ALTER TABLE Registration
	ADD CONSTRAINT PK_RegistrationInstance
	PRIMARY KEY (ScheduledCourseNo, WNumber)

ALTER TABLE ScheduledCourse
	ADD CONSTRAINT PK_ScheduledCourseNumber 
	PRIMARY KEY (ScheduledCourseNo)

ALTER TABLE UserAccount
	ADD CONSTRAINT PK_UserID
	PRIMARY KEY (UserID)

ALTER TABLE AccessLevel
	ADD CONSTRAINT PK_AccessLevel
	PRIMARY KEY (AccessLevel)

ALTER TABLE LoginHistory
	ADD CONSTRAINT PK_LoginSessionNumber
	PRIMARY KEY (LoginSessionNo, UserID)
	
-- Ensure PKs have been created before moving on to FKs 
GO

-- Alter tables to set up foreign keys 
ALTER TABLE ScheduleOfCourses
	ADD CONSTRAINT FK_SemesterOfScheduleOfCourses
	FOREIGN KEY (SemesterSeason, SemesterYear) REFERENCES Semester(SemesterSeason, SemesterYear) 
	ON UPDATE Cascade 
	ON DELETE Cascade, --NO Action
	
	CONSTRAINT FK_CourseIDforScheduleOfCourses
	FOREIGN KEY (CourseID) REFERENCES Course(CourseID) 
	ON UPDATE Cascade
	ON DELETE Cascade,
	
	CONSTRAINT FK_LecurerOfScheduleOfCoures
	FOREIGN KEY (LecturerID) REFERENCES Lecturer(LecturerID)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE Prerequisite
	ADD CONSTRAINT FK_CourseIDforPrerequisite
	FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE Lecturer
	ADD CONSTRAINT FK_StaffIDofLecturer
	FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE Staff
	ADD CONSTRAINT FK_SocialSecurityNumberOfPerson
	FOREIGN KEY (SocialSecurityNumber) REFERENCES Person(SocialSecurityNumber)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE Student
	ADD CONSTRAINT FK_SocialSecurityNumber
	FOREIGN KEY (SocialSecurityNumber) REFERENCES Person(SocialSecurityNumber)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE Registration
	ADD CONSTRAINT FK_ScheduleCourseNumberOfScheduledCourse
	FOREIGN KEY (ScheduledCourseNo) REFERENCES ScheduledCourse(ScheduledCourseNo)
	ON UPDATE Cascade
	ON DELETE Cascade,
	
	CONSTRAINT FK_WNumberOfStudent
	FOREIGN KEY (WNumber) REFERENCES Student(WNumber)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE UserAccount
	ADD CONSTRAINT FK_SocialSecurityNumberOfUserAccount
	FOREIGN KEY (SocialSecurityNumber) REFERENCES Person(SocialSecurityNumber)
	ON UPDATE Cascade
	ON DELETE Cascade,
	
	CONSTRAINT FK_AccessLevel
	FOREIGN KEY (AccessLevel) REFERENCES AccessLevel(AccessLevel)
	ON UPDATE Cascade
	ON DELETE Cascade
	
Alter Table LoginHistory
	ADD CONSTRAINT FK_UserIDOfUserAccount
	FOREIGN KEY (UserID) REFERENCES UserAccount(UserID)
	ON UPDATE Cascade
	ON DELETE Cascade
	
-- ensure that foreign keys are set up, then move on to check constraints 
GO

ALTER TABLE AccessLevel
	ADD CONSTRAINT CK_AccessLevelTitle
	CHECK (AccessLevelTitle IN ('Student', 'Staff', 'Lecturer', 'Admin'))
	
-- ensure that the Student has a valid GPA (0.0 <= GPA <= 4.0)
ALTER TABLE Student
	ADD CONSTRAINT CK_StudentGPAIsNonNegative
	CHECK (StudentGPA >= 0),
	
	CONSTRAINT CK_StudentGPAIsLessThan4
	CHECK (StudentGPA <= 4)
	
ALTER TABLE Person
	ADD CONSTRAINT CK_PersonGenderMorF
	CHECK (PersonGender IN ('M', 'F'))
	
ALTER TABLE Registration
	ADD CONSTRAINT CK_PaidYorN
	CHECK (RegistrationPaid IN ('Y', 'N'))
	
GO 

-- finally, add defaults
ALTER TABLE AccessLevel
	ADD CONSTRAINT DK_DefaultAccessLevel
	DEFAULT 0 FOR AccessLevel
	
ALTER TABLE Student
	ADD CONSTRAINT DK_DefaultStudendGPA
	DEFAULT 0 FOR StudentGPA
	
ALTER TABLE Staff
	ADD CONSTRAINT DK_DefaultStaffSalary
	DEFAULT 0 FOR Salary
	