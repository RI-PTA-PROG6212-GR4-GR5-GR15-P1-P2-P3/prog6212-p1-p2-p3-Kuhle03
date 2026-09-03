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

