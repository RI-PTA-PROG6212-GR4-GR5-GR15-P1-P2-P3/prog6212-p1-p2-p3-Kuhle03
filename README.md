# RaceDay: ASP.NET Core MVC web application (Part 3)

ASP.NET Core 8 MVC front end for the RaceDay platform. It consumes the **Part 2 RESTful API** for every data operation:
there is no DbContext, no SQL and no Azure SDK in this project.

## Architecture

```
Browser  ->  MVC app (controllers, views, session)  ->  Part 2 API  ->  SQL Server + Azure Blob Storage
```

- **Session management:** on login the Part 2 API starts its own server-side session and returns a cookie. The MVC app keeps that
  cookie, the user's role and name in *its* server-side session and forwards the cookie on every API call. The browser only holds MVC's session cookie.
- **Role-based interfaces:** `Organiser` and `Participant` each get their own menu and pages. `[SessionAuthorize]` redirects
  unauthenticated users to the login page and wrong-role users to "Access denied"; the API enforces its own 401/403 as well.
- **Blob Storage:** banners and profile pictures are uploaded MVC -> API -> Azure Blob Storage and read back the same way.
  The MVC app never talks to Azure directly.

## Features

**Organiser:** dashboard (events created, total enrolments, upcoming dates), create / edit / delete events with banner upload,
age or distance categories, enrolments per event, results entry (finish time + position per category).

**Participant:** upcoming events with filters, event details with categories, enrol in a category (recorded immediately),
my enrolments with colour-coded status, my results (event, date, category, finish time, position e.g. "47th out of 312 finishers"),
profile page with picture upload.

**Enrolment status colours:** Confirmed (green) = event still to come, Pending (amber) = event has taken place but results are not published yet,
Completed (blue) = result published.

## Run locally (Visual Studio)

1. Run the Part 2 API (default address `http://localhost:5080`). For banners and pictures start Azurite (or set a real Azure connection string
   in the API's `ConnectionStrings:StorageConnectionString`).
2. `Part3-MVC/RaceDayMvc/appsettings.json` -> `ApiSettings:BaseUrl` must match the API address.
3. Solution -> Configure Startup Projects -> Multiple startup projects -> start both -> F5.

Test accounts: log in with an account that exists in your Part 2 database, or use **Register** to create one (for example Participant "Anza Chilidzi Nemafugani"). Names, emails and results shown in the app always come from the Part 2 API.

## Run with Docker

1. Start the API so that Docker can reach it (in `Part2-API/src/RaceDay.Api`):

   ```powershell
   dotnet run --urls http://0.0.0.0:5080
   ```

2. Build and start the MVC container (in `Part3-MVC/RaceDayMvc`), one command:

   ```powershell
   docker build -t raceday-mvc . ; docker run --rm -p 8080:8080 -e ApiSettings__BaseUrl=http://host.docker.internal:5080/ raceday-mvc
   ```

   (bash / Git Bash: replace `;` with `&&`)

3. Open **http://localhost:8080**. The containerised app behaves exactly like the local one.

If port 8080 is busy use e.g. `-p 8085:8080` and open http://localhost:8085.

## Configuration

| Setting | Where | Purpose |
|---|---|---|
| `ApiSettings:BaseUrl` | `appsettings.json` / env `ApiSettings__BaseUrl` | Address of the Part 2 API |

No passwords, API keys or Azure connection strings are stored in this project.

## CI/CD

`.github/workflows/dotnet.yml` restores, builds and tests the API, then builds the MVC project and its Docker image on every push.

## Demo video

YouTube (unlisted): _paste your link here_
