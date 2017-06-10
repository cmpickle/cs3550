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

-- This script is for practicing SQL queries for Assignment 5
-- Taks 1
PRINT 'Beginning #1 - I''m inserting myself as a new guest....'

GO

INSERT INTO Guest 
VALUES('Cameron', 'Pickle', '4683 Cee Jay Ct', NULL, 'South Jordan', 'UT', '84009', 'United States', '801-694-8594', 'cmpickle@gmail.com', null)

GO

PRINT 'Here is the result of the Guest Table after I inserted myself...'

PRINT '' --Does a blank line

SELECT * From Guest

GO

-- Task 2
PRINT 'Beginning #2 - I''m inserting myself a new Credit Card....'

GO

INSERT INTO CreditCard 
VALUES(@@IDENTITY, 'VISA', '123456789012346', NULL, 'Cameron Pickle', '2020-12-31 00:00:00')

GO

PRINT 'Here is the result of the Credit Card Table after I a credit card for myself...'

PRINT '' --Does a blank line

SELECT * From CreditCard

GO

-- Task 3
PRINT 'Beginning #3 - I''m increasing the price of room type 1 in the current Rack Rate by 10% using ceiling rounding....'

PRINT '#3 - I''m decreasing the price of room types 3&4 in the current Rack Rate by 10% using floor rounding....'

PRINT '#3 - I''m inserting a coupon of $35.50 for CS3550 students that are currently enrolled and spend at least $200....'

GO

UPDATE RackRate 
SET RackRate=CEILING(RackRate*1.1) 
WHERE CAST(GETDATE() AS DATE) > RackRateBegin AND CAST(GETDATE() AS DATE) < RackRateEnd AND RoomTypeID = 1

UPDATE RackRate 
SET RackRate=FLOOR(RackRate*.9) 
WHERE CAST(GETDATE() AS DATE) > RackRateBegin AND CAST(GETDATE() AS DATE) < RackRateEnd AND (RoomTypeID=3 OR RoomTypeID=4)

INSERT INTO Discount VALUES('CS3550 Discount', '2017-7-31', 'min stay price of $200 - student must be currently enrolled in CS3550', 0, 35.50)

GO

PRINT 'Here is the result of the Rack Rate and Discount Tables after the changes...'

PRINT '' --Does a blank line

SELECT * FROM RackRate

SELECT * FROM Discount

GO

-- Task 4
PRINT 'Beginning #4 - I''m determining the Rack Rate and nightly tax for room number 302 at Sunridge form any date between June 26 and July 6....'

GO

PRINT 'Here is the Rack Rate and nightly tax for room number 302 at Sunridge from any date between June 26 and July 6...'

GO

SELECT RackRate.RackRate 'Rack Rate', TaxRate.RoomTaxRate 'Nightly Tax', RackRateBegin, RackRateEnd, RoomID
FROM TaxRate 
JOIN Hotel ON TaxRate.TaxLocationID=Hotel.TaxLocationID 
JOIN RackRate ON Hotel.HotelID=RackRate.HotelID 
JOIN RoomType ON RackRate.RoomTypeID=RoomType.RoomTypeID
JOIN Room ON RoomType.RoomTypeID=Room.RoomTypeID
WHERE RackRateBegin <= '06-26-2017' 
AND RackRateEnd >= '07-06-2017'
AND Hotel.HotelName = 'Sunridge Bed & Breakfast'
AND Room.RoomNumber = '302'

GO

PRINT '' --Does a blank line

GO

-- Task 5
PRINT 'Beginning #5 - I''m making a master reservation at Sunridge B&B with 2 folio details....'

GO

INSERT INTO Reservation 
VALUES(GETDATE(), 'R', null, (SELECT TOP 1 CreditCardID FROM CreditCard c JOIN Guest g ON c.GuestID=g.GuestID WHERE GuestFirst='Cameron' AND GuestLast='Pickle'))

INSERT INTO Folio 
VALUES('5020', '7', '4', '235', '06-26-2017', '3', 'R', null, '10')

INSERT INTO Folio 
VALUES('5020', '7', '4', '235', '07-06-2017', '3', 'R', null, '10')

GO

PRINT 'Here is the result of the Reservation Table after I make a reservation for myself...'

PRINT '' --Does a blank line

SELECT * From Reservation

PRINT 'Here is the result of the Folio Table after I make a reservation for myself...'

PRINT '' --Does a blank line

SELECT * FROM Folio

GO

-- Task 6
PRINT 'Beginning #6 - I''m displaying the hotel name, room number, room description and rack rate for all rooms with a rack rate at or above $138.00 per night....'

GO

SELECT HotelName 'Hotel Name', RoomNumber 'Room Number', RoomDescription 'Room Description', '$' + CONVERT(varchar(12), RackRate) 'Rack Rate'
FROM Hotel h 
JOIN Room r ON r.HotelID=h.HotelID
JOIN RoomType rt ON rt.RoomTypeID=r.RoomTypeID
JOIN RackRate rr ON rr.RoomTypeID=rt.RoomTypeID
WHERE RackRate >= '138'
AND DATEPART(m, RackRateBegin) <= 6
AND DATEPART(m, RackRateEnd) >= 6 
ORDER BY RackRate ASC

GO

-- Task 7
PRINT 'Beginning #7 - For each hotel, list the hotel name and the count of rooms by floor, for all rooms at each hotel.....'

GO

SELECT SUBSTRING(HotelName, 1, PATINDEX('% %',HotelName)) 'Hotel Name',SUBSTRING(RoomNumber,1,1) [Floor], COUNT(RoomNumber) 'Number of Rooms'
FROM Hotel h 
JOIN Room r ON r.HotelID=h.HotelID
GROUP BY HotelName, SUBSTRING(RoomNumber,1,1)
ORDER BY HotelName, FLOOR

GO

-- Task 8
PRINT 'Beginning #8 - For check-ins during June and July, what is the total number of arrivals and the average length of stay by hotel name and month.....'

GO

SELECT HotelName 'Hotel', CONVERT(varchar(3), CheckInDate, 100) 'Month', COUNT(CheckInDate) 'Arrivals', CAST(AVG(CAST(Nights AS DECIMAL(2,1))) AS DECIMAL(2,1)) 'Average Stay'
FROM Hotel h
JOIN Room r ON h.HotelID=r.HotelID
JOIN Folio f ON f.RoomID=r.RoomID
GROUP BY HotelName, CONVERT(varchar(3), CheckInDate, 100)
ORDER BY HotelName, [Month]

GO

-- Task 9
PRINT 'Beginning #9 - List the guest name, hotel name, room number, arrival date, and departure date for all folio check-in dates that occur on a Monday-Thursday......'

GO

SELECT GuestLast + ' ' + GuestFirst 'Guest Name', HotelName 'Hotel', RoomNumber 'Room Number', CONVERT(varchar(20),CheckInDate, 107) 'Arrival Date', CONVERT(varchar(20), DATEADD(d, Nights, CheckinDate), 107) 'Departure Date'
FROM Guest g
JOIN CreditCard cc ON g.GuestID=cc.GuestID
JOIN Reservation r ON r.CreditCardID=cc.CreditCardID
JOIN Folio f ON f.ReservationID=r.ReservationID
JOIN Room rm ON f.RoomID=rm.RoomID
JOIN Hotel h ON rm.HotelID=h.HotelID
WHERE DATEPART(dw, CheckinDate) IN (2,3,4,5)

GO

-- Task 10
PRINT 'Beginning #9 - List the guest name, hotel name, room number, arrival date, and departure date for all folio check-in dates that occur on a Monday-Thursday......'

GO

SELECT GuestLast + ' ' + GuestFirst 'Guest Name', HotelName 'Hotel', RoomNumber 'Room Number', CONVERT(varchar(20),CheckInDate, 107) 'Arrival Date', CONVERT(varchar(20), DATEADD(d, Nights, CheckinDate), 107) 'Departure Date'
FROM Guest g
JOIN CreditCard cc ON g.GuestID=cc.GuestID
JOIN Reservation r ON r.CreditCardID=cc.CreditCardID
JOIN Folio f ON f.ReservationID=r.ReservationID
JOIN Room rm ON f.RoomID=rm.RoomID
JOIN Hotel h ON rm.HotelID=h.HotelID
WHERE DATEPART(dw, CheckinDate) IN (2,3,4,5)

GO