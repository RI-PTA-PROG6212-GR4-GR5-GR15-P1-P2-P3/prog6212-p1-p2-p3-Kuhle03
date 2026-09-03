INSERT INTO Organisers (FullName, Email, PasswordHash, ContactNumber)
VALUES
    ('Anzatshilidzi Nemafukani', 'Anza@raceday.co.za', 'hashed_pw_001', '0628234567'),
    ('Khanyisile Mnguni', 'khanyi@raceday.co.za', 'hashed_pw_002', '0756784321');
GO

INSERT INTO Events (OrganiserID, Name, EventDate, Location, Description, RouteInfo)
VALUES
    (1, 'Durban Park Run', '2026-10-17', 'Durban',
        'A community park run through the Durban.',
        'Flat, tarred loop, 5km and 10km options.'),
    (1, 'Soweto Heritage Cycle Challenge', '2026-10-03', 'Soweto',
        'A charity cycling event supporting local youth sports programmes.',
        'Rolling hills, mixed tar and gravel, water points every 15km.'),
    (2, 'Pretoria Winter Road Race', '2026-11-20', 'Pretoria',
        'An annual road running event with categories for all experience levels.',
        'Point-to-point road route, closed to traffic.');
GO

INSERT INTO Categories (EventID, Name, Distance, MaxParticipants)
VALUES
    (1, '5km Fun Run', 3.00, 100),
    (1, '10km Race', 5.00, 120),
    (2, '40km Cycle', 10.00, 100),
    (2, '80km Cycle', 90.00, 40),
    (3, '10km Race', 10.00, 150),
    (3, '21km Half Marathon', 21.10, 100);
GO

INSERT INTO EventEnrolments (ParticipantID, CategoryID)
VALUES
    (1, 1),  -- Anzatshilidzi enters the 5km Fun Run
    (1, 3),  -- Anzatshilidzi enters the 40km Cycle
    (2, 2),  -- Khanyi enters the 10km Race (Durban)
    (2, 5);  -- Khanyi enters the 10km Race (Pretoria)
GO

 INSERT INTO Results (EnrolmentID, FinishTime, Position)
VALUES
    (1, '00:20:34', 1),
    (3, '00:39:10', 4);
GO
insert
