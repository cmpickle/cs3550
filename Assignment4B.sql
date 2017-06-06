-- Database Creation Script 
--Cameron Pickle 6/6/2017
--This creates the 

USE Master --switch to Master DB

IF EXISTS (SELECT * FROM sysdatabases WHERE name = 'Pickle_FARMS') 
DROP DATABASE Pickle_FARMS

GO --Pause (make sure stuff above finished) 

CREATE DATABASE Pickle_FARMS
ON PRIMARY 
(
	NAME = 'Pickle_FARMS',
	FILENAME = 'C:\stage\FARMS1-1\Pickle_FARMS.mdf',  --Change the path for local    
	SIZE = 4MB, -- 500kb, 500, TB, GB    
	MAXSIZE =  6MB,    
	FILEGROWTH = 500KB -- 5MB 
)
 
LOG ON 
(NAME = 'Pickle_FARMS_Log',
	FILENAME = 'C:\stage\FARMS1-1\Pickle_FARMS.ldf',  --Change the path for local
      SIZE = 1MB, -- 500kb, 500, TB, GB  -- 10% Read 25% R/Write
      MAXSIZE =  1500KB,
	  FILEGROWTH = 10% -- 5MB 
 ) 
GO 
-- With the Pickle_FARMS database now created, switch to it and begin creating the individual 
-- tables for the database

USE Pickle_FARMS

CREATE TABLE TaxRate
(
TaxLocationID		smallint		NOT NULL,
TaxDescription		varchar(30)		NOT NULL,
RoomTaxRate			decimal(6,4)	NOT NULL,
SalesTaxRate		decimal(6,4)	NOT NULL
)

CREATE TABLE Hotel
(
HotelID				smallint		NOT NULL,
HotelName			varchar(30)		NOT NULL,
HotelAddress		varchar(30)		NOT NULL,
HotelCity			varchar(20)		NOT NULL,
HotelState			varchar(2)		NULL,
HotelCountry		varchar(20)		NOT NULL,
HotelPostalCode		char(10)		NOT NULL,
HotelStarRanking	char(1)			NULL,
HotelPictureLink	varchar(100)	NULL,
TaxLocationID		smallint		NOT NULL
)

CREATE TABLE RackRate
(
RackRateID			smallint		NOT NULL,
RoomTypeID			smallint		NOT NULL,
HotelID				smallint		NOT NULL,
RackRate			smallmoney		NOT NULL,
RackRateBegin		date			NOT NULL,
RackRateEnd			date			NOT NULL,
RackRateDescription	varchar(200)	NOT NULL
)

CREATE TABLE RoomType
(
RoomTypeID			smallint		NOT NULL,
RTDescription		varchar(200)	NOT NULL
)

CREATE TABLE Room
(
RoomID					smallint		NOT NULL,
RoomNumber				varchar(5)		NOT NULL,
RoomDescription			varchar(200)	NOT NULL,
RoomSmoking				bit				NOT NULL,
RoomBedConfiguration	char(2)			NOT NULL,
HotelID					smallint		NOT NULL,
RoomTypeID				smallint		NOT NULL
)

CREATE TABLE Folio
(
FolioID				smallint		NOT NULL,
ReservationID		smallint		NOT NULL,
GuestID				smallint		NOT NULL,
RoomID				smallint		NOT NULL,
QuotedRate			smallmoney		NOT NULL,
CheckinDate			smalldatetime	NOT NULL,
Nights				tinyint			NOT NULL,
Status				char(1)			NOT NULL,
Comments			varchar(200)	NULL,
DiscountID			smallint		NOT NULL
)

CREATE TABLE Billing
(
FolioBillingID		smallint		NOT NULL,
FolioID				smallint		NOT NULL,
BillingCategoryID	smallint		NOT NULL,
BillingDescription	char(30)		NOT NULL,
BillingAmount		smallmoney		NOT NULL,
BillingItemQty		tinyint			NOT NULL,
BillingItemDate		date			NOT NULL
)

CREATE TABLE BillingCategory
(
BillingCategoryID		smallint	NOT NULL,
BillingCatDescription	varchar(30)	NOT NULL,
BillingCatTaxable		bit			NOT NULL
)

CREATE TABLE Payment
(
PaymentID			smallint		NOT NULL,
FolioID				smallint		NOT NULL,
PaymentDate			date			NOT NULL,
PaymentAmount		smallmoney		NOT NULL,
PaymentComments		varchar(200)	NULL
)

CREATE TABLE Discount
(
DiscountID				smallint		NOT NULL,
DiscountDescription		varchar(50)		NOT NULL,
DiscountExpiration		date			NOT NULL,
DiscountRules			varchar(100)	NULL,
DiscountPercent			decimal(4,2)	NULL,
DiscountAmount			smallmoney		NULL
)

CREATE TABLE Reservation
(
ReservationID		smallint		NOT NULL,
ReservationDate		date			NOT NULL,
ReservationStatus	char(1)			NOT NULL,
ReservationComments	varchar(200)	NULL,
CreditCardID		smallint		NOT NULL
)

CREATE TABLE CreditCard
(
CreditCardID		smallint		NOT NULL,
GuestID				smallint		NOT NULL,
CCType				varchar(5)		NOT NULL,
CCNumber			varchar(16)		NOT NULL,
CCCompany			varchar(40)		NULL,
CCCardHolder		varchar(40)		NOT NULL,
CCExpiration		smalldatetime	NOT NULL
)

CREATE TABLE Guest
(
GuestID				smallint		NOT NULL,
GuestFirst			varchar(20)		NOT NULL,
GuestLast			varchar(20)		NOT NULL,
GuestAddress1		varchar(30)		NOT NULL,
GuestAddress2		varchar(10)		NULL,
GuestCity			varchar(20)		NOT NULL,
GuestState			char(2)			NULL,
GuestPostalCode		char(10)		NOT NULL,
GuestCountry		varchar(20)		NOT NULL,
GuestPhone			varchar(20)		NOT NULL,
GuestEmail			varchar(30)		NULL,
GuestComments		varchar(200)	NULL
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
	