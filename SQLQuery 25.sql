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








