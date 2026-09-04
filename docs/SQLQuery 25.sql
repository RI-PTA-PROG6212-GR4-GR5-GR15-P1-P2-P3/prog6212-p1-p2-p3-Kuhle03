CREATE TABLE Organisers (
    OrganiserID     INT IDENTITY(1,1) PRIMARY KEY,
    FullName        NVARCHAR(100)   NOT NULL,
    Email           NVARCHAR(150)   NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255)   NOT NULL,
    ContactNumber   NVARCHAR(20)    NULL,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE()
);
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

CREATE TABLE Categories (
    CategoryID      INT IDENTITY(1,1) PRIMARY KEY,
    EventID         INT             NOT NULL,
    Name            NVARCHAR(50)    NOT NULL,
    Distance        DECIMAL(5,2)    NOT NULL,
    MaxParticipants INT             NOT NULL DEFAULT 100,
    CONSTRAINT FK_Categories_Events FOREIGN KEY (EventID)
        REFERENCES Events(EventID)
);
GO
    
CREATE TABLE EventEnrolments (
    EnrolmentID     INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID   INT             NOT NULL,
    CategoryID      INT             NOT NULL,
    EnrolmentDate   DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Enrolments_Participants FOREIGN KEY (ParticipantID)
        REFERENCES Participants(ParticipantID),
    CONSTRAINT FK_Enrolments_Categories FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID),
    CONSTRAINT UQ_Participant_Category UNIQUE (ParticipantID, CategoryID)
);
GO












