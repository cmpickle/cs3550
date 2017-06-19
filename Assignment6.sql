-- Database Creation Script 
--Cameron Pickle 6/6/2017
--This creates the FARMS database

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
TaxLocationID		smallint		NOT NULL IDENTITY(1,1),
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
RackRateID			smallint		NOT NULL IDENTITY(1,1),
RoomTypeID			smallint		NOT NULL,
HotelID				smallint		NOT NULL,
RackRate			smallmoney		NOT NULL,
RackRateBegin		date			NOT NULL,
RackRateEnd			date			NOT NULL,
RackRateDescription	varchar(200)	NOT NULL
)

CREATE TABLE RoomType
(
RoomTypeID			smallint		NOT NULL IDENTITY(1,1),
RTDescription		varchar(200)	NOT NULL
)

CREATE TABLE Room
(
RoomID					smallint		NOT NULL IDENTITY(1,1),
RoomNumber				varchar(5)		NOT NULL,
RoomDescription			varchar(200)	NOT NULL,
RoomSmoking				bit				NOT NULL,
RoomBedConfiguration	char(2)			NOT NULL,
HotelID					smallint		NOT NULL,
RoomTypeID				smallint		NOT NULL
)

CREATE TABLE Folio
(
FolioID				smallint		NOT NULL IDENTITY(1,1),
ReservationID		smallint		NOT NULL,
GuestID				smallint		NOT NULL,
RoomID				smallint		NOT NULL,
QuotedRate			smallmoney		NOT NULL,
CheckinDate			smalldatetime	NOT NULL,
Nights				tinyint			NOT NULL,
[Status]			char(1)			NOT NULL,
Comments			varchar(200)	NULL,
DiscountID			smallint		NOT NULL
)

CREATE TABLE Billing
(
FolioBillingID		smallint		NOT NULL	IDENTITY(1,1),
FolioID				smallint		NOT NULL,
BillingCategoryID	smallint		NOT NULL,
BillingDescription	char(30)		NOT NULL,
BillingAmount		smallmoney		NOT NULL,
BillingItemQty		tinyint			NOT NULL,
BillingItemDate		date			NOT NULL
)

CREATE TABLE BillingCategory
(
BillingCategoryID		smallint	NOT NULL IDENTITY(1,1),
BillingCatDescription	varchar(30)	NOT NULL,
BillingCatTaxable		bit			NOT NULL
)

CREATE TABLE Payment
(
PaymentID			smallint		NOT NULL	IDENTITY(8000, 1),
FolioID				smallint		NOT NULL,
PaymentDate			date			NOT NULL,
PaymentAmount		smallmoney		NOT NULL,
PaymentComments		varchar(200)	NULL
)

CREATE TABLE Discount
(
DiscountID				smallint		NOT NULL IDENTITY(1,1),
DiscountDescription		varchar(50)		NOT NULL,
DiscountExpiration		date			NOT NULL,
DiscountRules			varchar(100)	NULL,
DiscountPercent			decimal(4,2)	NULL,
DiscountAmount			smallmoney		NULL
)

CREATE TABLE Reservation
(
ReservationID		smallint		NOT NULL	IDENTITY(5000, 1),
ReservationDate		date			NOT NULL,
ReservationStatus	char(1)			NOT NULL,
ReservationComments	varchar(200)	NULL,
CreditCardID		smallint		NOT NULL
)

CREATE TABLE CreditCard
(
CreditCardID		smallint		NOT NULL IDENTITY(1,1),
GuestID				smallint		NOT NULL,
CCType				varchar(5)		NOT NULL,
CCNumber			varchar(16)		NOT NULL,
CCCompany			varchar(40)		NULL,
CCCardHolder		varchar(40)		NOT NULL,
CCExpiration		smalldatetime	NOT NULL
)

CREATE TABLE Guest
(
GuestID				smallint		NOT NULL	IDENTITY(1500, 1),
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
ALTER TABLE TaxRate
	ADD CONSTRAINT PK_TaxLocationID
	PRIMARY KEY (TaxLocationID)
	
ALTER TABLE Hotel
	ADD CONSTRAINT PK_HotelID
	PRIMARY KEY (HotelID)
	
ALTER TABLE RackRate
	ADD CONSTRAINT PK_RackRateID
	PRIMARY KEY (RackRateID)
	
ALTER TABLE RoomType
	ADD CONSTRAINT PK_RoomTypeID
	PRIMARY KEY (RoomTypeID)
	
ALTER TABLE Room
	ADD CONSTRAINT PK_RoomID
	PRIMARY KEY (RoomID)
	
ALTER TABLE Folio
	ADD CONSTRAINT PK_FolioID
	PRIMARY KEY (FolioID)
	
ALTER TABLE Billing
	ADD CONSTRAINT PK_FolioBillingID
	PRIMARY KEY (FolioBillingID)
	
ALTER TABLE BillingCategory
	ADD CONSTRAINT PK_BillingCategoryID
	PRIMARY KEY (BillingCategoryID)
	
ALTER TABLE Payment
	ADD CONSTRAINT PK_PaymentID
	PRIMARY KEY (PaymentID)
	
ALTER TABLE Discount
	ADD CONSTRAINT PK_DiscountID
	PRIMARY KEY (DiscountID)
	
ALTER TABLE Reservation
	ADD CONSTRAINT PK_ReservationID
	PRIMARY KEY (ReservationID)
	
ALTER TABLE CreditCard
	ADD CONSTRAINT PK_CreditCardID
	PRIMARY KEY (CreditCardID)
	
ALTER TABLE Guest
	ADD CONSTRAINT PK_GuestID
	PRIMARY KEY (GuestID)
	
-- Ensure PKs have been created before moving on to FKs 
GO

-- Alter tables to set up foreign keys 
ALTER TABLE Hotel
	ADD CONSTRAINT FK_Hotel_TaxLocationID
	FOREIGN KEY (TaxLocationID) REFERENCES TaxRate(TaxLocationID)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE RackRate
	ADD CONSTRAINT FK_RackRate_RoomTypeID
	FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID)
	ON UPDATE Cascade
	ON DELETE Cascade,
	
	CONSTRAINT FK_RackRate_HotelID
	FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE Room
	ADD CONSTRAINT FK_Room_HotelID
	FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID)
	ON UPDATE Cascade
	ON DELETE Cascade,
	
	CONSTRAINT FK_Room_RoomTypeID
	FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE Folio
	ADD CONSTRAINT FK_Folio_ReservationID
	FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID)
	ON UPDATE Cascade
	ON DELETE Cascade,
	
	CONSTRAINT FK_Folio_RoomID
	FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
	ON UPDATE Cascade
	ON DELETE Cascade,
	
	CONSTRAINT FK_Folio_DiscountID
	FOREIGN KEY (DiscountID) REFERENCES Discount(DiscountID)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE Billing
	ADD CONSTRAINT FK_Billing_FolioID
	FOREIGN KEY (FolioID) REFERENCES Folio(FolioID)
	ON UPDATE Cascade
	ON DELETE Cascade,
	
	CONSTRAINT FK_Billing_BillingCategoryID
	FOREIGN KEY (BillingCategoryID) REFERENCES BillingCategory(BillingCategoryID)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE Payment
	ADD CONSTRAINT FK_Payment_FolioID
	FOREIGN KEY (FolioID) REFERENCES Folio(FolioID)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE Reservation
	ADD CONSTRAINT FK_Reservation_CreditCardID
	FOREIGN KEY (CreditCardID) REFERENCES CreditCard(CreditCardID)
	ON UPDATE Cascade
	ON DELETE Cascade
	
ALTER TABLE CreditCard
	ADD CONSTRAINT FK_CreditCard_GuestID
	FOREIGN KEY (GuestID) REFERENCES Guest(GuestID)
	ON UPDATE Cascade
	ON DELETE Cascade

-- ensure that foreign keys are set up, then move on to check constraints 
GO

ALTER TABLE Room
	ADD CONSTRAINT CK_BedConfig
	CHECK (RoomBedConfiguration IN ('K', 'Q', '2Q', '2K', '2F'))
	
ALTER TABLE Folio
	ADD CONSTRAINT CK_FolioStatus
	CHECK (Status IN ('R', 'A', 'C', 'X'))
	
ALTER TABLE Reservation
	ADD CONSTRAINT CK_ReservationStatus
	CHECK (ReservationStatus IN ('R', 'A', 'C', 'X'))
	
GO
	
-- finally, add defaults
ALTER TABLE Folio
	ADD CONSTRAINT DK_DefaultDiscount
	DEFAULT 1 FOR DiscountID
	
GO
	
-- Bulk insert the data
BULK INSERT Billing FROM 'C:\stage\FARMS1-1\Billing.txt' WITH (FIELDTERMINATOR='|')

BULK INSERT BillingCategory FROM 'C:\stage\FARMS1-1\BillingCategory.txt' WITH (FIELDTERMINATOR='|')

BULK INSERT CreditCard FROM 'C:\stage\FARMS1-1\CreditCard.txt' WITH (FIELDTERMINATOR='|')

BULK INSERT Discount FROM 'C:\stage\FARMS1-1\Discount.txt' WITH (FIELDTERMINATOR='|')

BULK INSERT Folio FROM 'C:\stage\FARMS1-1\Folio.txt' WITH (FIELDTERMINATOR='|')

BULK INSERT Guest FROM 'C:\stage\FARMS1-1\Guest.txt' WITH (FIELDTERMINATOR='|')

BULK INSERT Hotel FROM 'C:\stage\FARMS1-1\Hotel.txt' WITH (FIELDTERMINATOR='|')

BULK INSERT Payment FROM 'C:\stage\FARMS1-1\Payment.txt' WITH (FIELDTERMINATOR='|')

BULK INSERT RackRate FROM 'C:\stage\FARMS1-1\RackRate.txt' WITH (FIELDTERMINATOR='|')

BULK INSERT Reservation FROM 'C:\stage\FARMS1-1\Reservation.txt' WITH (FIELDTERMINATOR='|')

BULK INSERT Room FROM 'C:\stage\FARMS1-1\Room.txt' WITH (FIELDTERMINATOR='|')

BULK INSERT RoomType FROM 'C:\stage\FARMS1-1\RoomType.txt' WITH (FIELDTERMINATOR='|')

BULK INSERT TaxRate FROM 'C:\stage\FARMS1-1\TaxRate.txt' WITH (FIELDTERMINATOR='|')

GO

-- Stored Proc creation script
-- Assignment 6
-- Cameron Pickle 6/19/17

-- Use my FARMS database

USE Pickle_FARMS

GO

-- #1 - sp_InsertGuest

-- check to see if sp_InsertGuest exists
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME= 'sp_InsertGuest')
	DROP PROCEDURE sp_InsertGuest;
GO

-- create procedure
CREATE PROCEDURE sp_InsertGuest
	@GuestFirst			varchar(20),
	@GuestLast			varchar(20),
	@GuestAddress1		varchar(30),
	@GuestAddress2		varchar(10) = NULL,
	@GuestCity			varchar(20),
	@GuestState			varchar(15) = NULL,
	@GuestPostalCode	varchar(10),
	@GuestCountry		varchar(20),
	@GuestPhone			varchar(20),
	@GuestEmail			varchar(30) = NULL,
	@GuestComments		varchar(200) = NULL,
	@GuestID			smallint OUTPUT
AS
BEGIN
INSERT INTO Guest (GuestFirst, GuestLast, GuestAddress1, GuestAddress2, GuestCity, GuestState, GuestPostalCode, GuestCountry, GuestPhone, GuestEmail, GuestComments)
	VALUES(
		@GuestFirst, 
		@GuestLast, 
		@GuestAddress1, 
		@GuestAddress2, 
		@GuestCity, 
		@GuestState, 
		@GuestPostalCode, 
		@GuestCountry, 
		@GuestPhone, 
		@GuestEmail, 
		@GuestComments)
		
	SELECT @GuestID = @@IDENTITY
	
END

GO

-- #1 - test by adding myself
DECLARE @NewGuestID smallint

EXEC sp_InsertGuest
	@GuestFirst			= 'Cameron',
	@GuestLast			= 'Pickle',
	@GuestAddress1		= '4037 Yorkshire Dr',
	@GuestAddress2		= NULL,
	@GuestCity			= 'South Jordan',
	@GuestState			= 'UT',
	@GuestPostalCode	= '84009',
	@GuestCountry		= 'USA',
	@GuestPhone			= '8016948594',
	@GuestEmail			= 'cmpickle@gmail.com',
	@GuestComments		= 'Best guest ever!!!',
	@GuestID			= @NewGuestID OUTPUT
	
PRINT 'New Guest ID for assigned is ' + CONVERT(varchar(10), @NewGuestID)
	
GO
	
SELECT * FROM Guest

exec sp_help Guest