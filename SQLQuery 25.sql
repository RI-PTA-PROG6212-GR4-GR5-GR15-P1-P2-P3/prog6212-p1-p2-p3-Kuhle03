C
CREATE DATABASE RaceDayDB;
GO
 
USE RaceDayDB;
GO


CREATE TABLE Organisers
(
    OrganiserID     INT IDENTITY(1,1) PRIMARY KEY,
    FullName        NVARCHAR(100)   NOT NULL,
    Email           NVARCHAR(150)   NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255)   NOT NULL,
    ContactNumber   NVARCHAR(20)    NULL,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

PRINT 'Organisers table created';
GO





CREATE TABLE Events (
    EventID         INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID     INT             NOT NULL,
    Name            NVARCHAR(150)   NOT NULL,
    EventDate       DATE            NOT NULL,
    Location        NVARCHAR(150)   NOT NULL,
    Description     NVARCHAR(MAX)   NULL,
    RouteInfo       NVARCHAR(MAX)   NULL,
    CONSTRAINT FK_Events_Organisers FOREIGN KEY (OrganiserID)
        REFERENCES Organisers(OrganiserID)
);
GO
PRINT 'Events table created';
GO

CREATE TABLE Participants
(
ParticipantID INT IDENTITY(1,1) PRIMARY KEY,
FullName NVARCHAR(100) NOT NULL,
Email NVARCHAR(150) NOT NULL UNIQUE,
PasswordHash NVARCHAR(255) NOT NULL,
ContactNumber NVARCHAR(20) NULL,
CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO

PRINT 'Participants table created';
GO


CREATE TABLE Categories
(
CategoryID INT IDENTITY(1,1) PRIMARY KEY,
EventID INT NOT NULL,
Name NVARCHAR(50) NOT NULL,
Distance DECIMAL(5,2) NOT NULL,
MaxParticipants INT NOT NULL DEFAULT 100,

CONSTRAINT FK_Categories_Events
FOREIGN KEY (EventID)
REFERENCES Events(EventID)
);
GO

PRINT 'Categories table created';
GO


CREATE TABLE EventEnrolments
(
EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
ParticipantID INT NOT NULL,
CategoryID INT NOT NULL,
EnrolmentDate DATETIME NOT NULL DEFAULT GETDATE(),

CONSTRAINT FK_Enrolments_Participants
FOREIGN KEY (ParticipantID)
REFERENCES Participants(ParticipantID),

CONSTRAINT FK_Enrolments_Categories
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID),

CONSTRAINT UQ_Participant_Category
UNIQUE (ParticipantID, CategoryID)
);
GO

PRINT 'EventEnrolments table created';
GO

CREATE TABLE Results
(
ResultID INT IDENTITY(1,1) PRIMARY KEY,
EnrolmentID INT NOT NULL UNIQUE,
FinishTime TIME NOT NULL,
Position INT NOT NULL,

CONSTRAINT FK_Results_Enrolments
FOREIGN KEY (EnrolmentID)
REFERENCES EventEnrolments(EnrolmentID)
);
GO

PRINT 'Results table created';
GO


INSERT INTO Organisers
(FullName, Email, PasswordHash, ContactNumber)
VALUES
('Anzatshilidzi Nemafukani',
'Anza@raceday.co.za',
'hashed_pw_001',
'0621238560'),

('Khanyisile Mnguni',
'Mnguni@raceday.co.za',
'hashed_pw_002',
'0737759325');
GO

INSERT INTO Participants
(FullName, Email, PasswordHash, ContactNumber)
VALUES
('khethiwe Zotha',
'kZotha@gmail.com',
'hashed_pw_101',
'0831232020'),

('Prudence Mkhwanazi',
'Mkhwa@gmail.com',
'hashed_pw_102',
'0671247656');
GO

INSERT INTO Events
(OrganiserID, Name, EventDate, Location, Description, RouteInfo)
VALUES
(1,
'Johannesburg City Park Run',
'2026-09-12',
'Johannesburg',
'A community park run through the Johannesburg botanical gardens.',
'Flat, tarred loop, 5km and 10km options.'),

(1,
'Soweto Heritage Cycle Challenge',
'2026-10-03',
'Soweto',
'A charity cycling event supporting local youth sports programmes.',
'Rolling hills, mixed tar and gravel, water points every 15km.'),

(2,
'Pretoria Winter Road Race',
'2026-11-20',
'Pretoria',
'An annual road running event with categories for all experience levels.',
'Point-to-point road route, closed to traffic.');
GO

INSERT INTO Categories
(EventID, Name, Distance, MaxParticipants)
VALUES
(1, '5km Fun Run', 5.00, 200),
(1, '10km Race', 10.00, 150),

(2, '40km Cycle', 40.00, 100),
(2, '80km Cycle', 80.00, 60),

(3, '10km Race', 10.00, 150),
(3, '21km Half Marathon', 21.10, 100);
GO


INSERT INTO EventEnrolments
(ParticipantID, CategoryID)
VALUES
(1, 1), -- Lindiwe enters 5km Fun Run
(1, 3), -- Lindiwe enters 40km Cycle
(2, 2), -- Sipho enters Johannesburg 10km
(2, 5); -- Sipho enters Pretoria 10km
GO

INSERT INTO Results
(EnrolmentID, FinishTime, Position)
VALUES
(1, '00:24:38', 1),
(3, '00:48:12', 4);
GO

SELECT * FROM Organisers;
SELECT * FROM Participants;
SELECT * FROM Events;
SELECT * FROM Categories;
SELECT * FROM EventEnrolments;
SELECT * FROM Results;
GO

PRINT 'RaceDay database created and seeded successfully.';
GO





