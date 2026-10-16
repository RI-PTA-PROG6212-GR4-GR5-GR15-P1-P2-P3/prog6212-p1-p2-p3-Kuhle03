RaceDay

RaceDay is , kind of a web based event management system, built for the South African road running, walking and cycling community. Event Organisers create events, plus categories and results. Then participants browse what’s on, enter events, and kinda track their own results, later.

This repository was assembled in parts for the PROG6212 Portfolio of Evidence:

| Part | Folder | What it contains

| Part 1 | `/docs` | PDF, Section A and B, SQL script  
| Part 2 | `/Part2-API` | ASP.NET Core Web API, EF Core Code-First, session login, Swagger, unit tests  

Two roles, not really complicated but still

Organiser: creates, edits, deletes their own events. They also define categories per event, like age or distance ( Under 20, Senior, 10km, 21km ), and then they can see everyone enrolled in their events. After the event, Organisers capture finish times and finishing positions.

Participant: browses events and categories, then enters an event by picking a category. They can view and cancel their own enrolments, and view their own results too.

Both roles can register, log in, and update their own profile. But a Participant cannot use Organiser features, and an Organiser cannot use Participant features. so it is locked down by role, basically.

 Part 2 – RESTful API

 Tech stack
ASP.NET Core Web API (.NET 8, C#) · Entity Framework Core 8 (Code-First) · SQL Server · BCrypt password hashing · server-side sessions · Swagger (Swashbuckle) · xUnit tests · GitHub Actions

Security, in steps that you can follow

1. A user registers and selects a role. The password is hashed with (Crypt) before saving, so the actual password is never stored in the database.  
2. During login, the server creates a session and writes the user’s ID and role into it. The browser keeps only a session cookie.  
3. Every protected endpoint checks that session. If no session → 401 Unauthorized. If wrong role → 403 Forbidden.  
4. Organisers can only edit their own events, categories and results. Participants can only view and cancel their own enrolments.

 Setup (first time)
You need: Visual Studio 2022 (or the .NET 8 SDK), and SQL Server (Developer, Express or LocalDB).

1. Clone the repository.  
2. Open `Part2-API/src/RaceDay.Api/appsettings.json` and verify the connection string. If your SQL instance uses a custom host, change `Server=localhost` to the right one, for example `Server=localhost\SQLEXPRESS` or `Server=(localdb)\MSSQLLocalDB`.  
3. Create the first migration (Code-First). In a terminal inside `Part2-API/src/RaceDay.Api`:
   ```
   dotnet tool install -global dotnet-ef
   dotnet ef migrations add InitialCreate
   
(Visual Studio: Package Manager Console, `Add-Migration InitialCreate`.) Commit the new `Migrations` folder.
4. That’s it for the database. The app applies the migration and also seeds demo data the first time it starts. It creates a database called `RaceDayApiDb`.

 Run
cd Part2-API/src/RaceDay.Api
dotnet run

Open http://localhost:5080/swagger (Visual Studio often opens it automatically when you press F5).
Demo accounts (password for all four: `Password123!`):

 Role | Email
Organiser | AnzaTshilidzi@raceday.co.za  
Organiser | Zotha@raceday.co.za  
Participant | KGMolomo@example.com  
Participant | Gumede@example.com  

 Try it in Swagger
1. Open `POST /api/auth/login`, click Try it out, enter email and password, Execute. Swagger now holds your session cookie.  
2. Call any endpoint. Log in as an Organiser to create events, and log in as a Participant to enrol.  
3. If you need to switch roles, call `POST /api/auth/logout`, then sign in again.

 Testing
All tests are under `Part2-API/tests/RaceDay.Tests` (xUnit + Moq). Run them from the solution folder:

cd Part2-API
dotnet test

Visual Studio: go to Test > Test Explorer > Run All. No SQL Server needed, because the tests use a fresh in-memory database.

Each test uses Arrange / Act / Assert and its name follows `Method_Scenario_ExpectedResult`. Every area has success and failure scenarios.
Area | Example scenarios | Where

Registration | valid user, duplicate email, email used by the other role, invalid role, password stored hashed | `Unit/AuthControllerTests.cs`  
Login | valid credentials (session started), wrong password, unknown email, email in different case | `Unit/AuthControllerTests.cs`  
Missing or invalid data | missing email, missing password, short password, bad event type, zero distance | `Unit/DtoValidationTests.cs`  
Not logged in / wrong role | no session gives 401, Participant on Organiser endpoint gives 403, and the reverse | `Unit/SessionAuthorizeAttributeTests.cs`  
Event management | Organiser creates, updates and deletes own events; cannot touch another Organiser's; unknown ID gives 404 | `Unit/EventsControllerTests.cs`  
| Categories | create, duplicate name, age category with no distance, limit lower than enrolled | `Unit/CategoriesControllerTests.cs`  
| Enrolments | enrolment recorded (participant + category + event), duplicate, full category, unknown category, past event | `Unit/EnrolmentsControllerTests.cs`  
Results | capture, duplicate, position taken, other Organiser's event, Participant sees only own results | `Unit/ResultsControllerTests.cs`  
Profile | view and update own profile, email already used |`Unit/ProfileControllerTests.cs`  
| Whole API together | register, login, protected calls and 401/403 through the real session pipeline | `Integration/`  

Unit tests talk to controllers directly. Moq swaps the password service out, and a small `FakeSession` replaces the login session. The `Integration` tests start the API in memory and send real HTTP requests, including a session cookie.

 Project layout
Part2-API/
  RaceDay.sln
  src/RaceDay.Api/
    Controllers/   one controller per area
    Data/          AppDbContext + demo data seeder
    Models/        entity classes, and Models/DTOs for request and response objects
    Services/      password hashing
    Helpers/       session login check (SessionAuthorize) and constants
    Program.cs     database, session and Swagger set-up
  tests/RaceDay.Tests/
    Unit/  Integration/  Helpers/

Endpoints

Full plan with request bodies and responses: [`docs/RaceDay_API_Endpoint_Plan.md`](docs/RaceDay_API_Endpoint_Plan.md).

| Area | Endpoints  
Auth `POST /api/auth/register, POST /api/auth/login , POST /api/auth/logout`  
Profile `GET /api/profile, PUT /api/profile`  
Events `GET /api/events, GET /api/events/{id} , POST /api/events, PUT /api/events/{id}, DELETE /api/events/{id}`

YOUTUBE VIDEO LINK:https://youtu.be/rjBcMFrfgvI 

