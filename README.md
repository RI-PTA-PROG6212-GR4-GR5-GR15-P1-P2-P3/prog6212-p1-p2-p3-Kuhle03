# RaceDay: ASP.NET Core MVC web application (Part 3)

RaceDay front end (MVC) built on ASP.NET Core 8, kind of the stuff you click and see. It talks to the **Part 2 RESTful API** for pretty much all data work: no DbContext, no SQL, and honestly no Azure SDK in this little project.

 Architecture


Browser  ->  MVC app (controllers views session)  ->  Part 2 API  ->  SQL Server + Azure Blob Storage


**Session management:** when you log in the Part 2 API spins up its own server side session, and it hands back a cookie. The MVC app saves that cookie, stores the user's role and name in its server side session, and then keeps forwarding the cookie on each API call, so the browser only holds the MVC session cookie.  
**Role-based interfaces:** `Organiser` and `Participant` each get their own menu + pages. `[SessionAuthorize]` sends unauthenticated users to login, and wrong-role users to "Access denied" . The API itself still enforces 401/403 too, so you’re not relying on only one layer.
**Blob Storage:** banners and profile pictures go MVC -> API -> Azure Blob Storage, and they’re read back the same way. The MVC app never reaches Azure directly, it just asks the API.

## Features

**Organiser:** dashboard (events created, total enrolments, upcoming dates), create / edit / delete events with banner upload, age or distance categories, enrolments per event, results entry (finish time + position per category).

**Participant:** upcoming events with filters, event details with categories, enrol into a category (saved immediately), my enrolments with status colors, my results (event date category finish time position like "47th out of 312 finishers"), profile page with picture upload.

**Enrolment status colours:** Confirmed (green) = the event is still ahead, Pending (amber) = the event already happened but results are not published yet, Completed (blue) = results are published.

## Run locally (Visual Studio)

1. Start the Part 2 API first (default address `http://localhost:5080`). For banners and pictures you’ll want Azurite, or set a real Azure connection string in the API setting `ConnectionStrings:StorageConnectionString`.
2. `Part3-MVC/RaceDayMvc/appsettings.json`  -> `ApiSettings:BaseUrl` has to match the Part 2 API address.
3. In Visual Studio: Solution -> Configure Startup Projects -> Multiple startup projects -> start both -> F5.

Test accounts: log in with an account that already exists in your Part 2 database, or hit **Register** to make one (for example Participant "Anzatshilidzi Nemafukani"). Names, emails and results you see in the app always come from the Part 2 API, not from MVC.

## Run with Docker

1. Start the API so Docker can access it (in `Part2-API/src/RaceDay.Api`):

   ```powershell
   dotnet run --urls http://0.0.0.0:5080
   ```

2. Build and start the MVC container (in `Part3-MVC/RaceDayMvc`), one command:

   ```powershell
   docker build -t raceday-mvc . ; docker run --rm -p 8080:8080 -e ApiSettings__BaseUrl=http://host.docker.internal:5080/ raceday-mvc
   ```

   (bash / Git Bash: change `;` into `&&`)

3. Open **http://localhost:8080**. The container version acts basically the same like the local version.

If port 8080 is taken, try e.g. `-p 8085:8080` and then go to http://localhost:8085.

## Configuration

| Setting | Where | Purpose |
|---|---|---|
| `ApiSettings:BaseUrl` | `appsettings.json` / env `ApiSettings__BaseUrl` | Where the Part 2 API lives |

No passwords, no API keys and no Azure connection strings are stored inside this MVC project.

## CI/CD

The file `.github/workflows/dotnet.yml` restores builds and tests the API, then builds the MVC project and its Docker image on every push.
screenshot of CI/CD: <img width="1312" height="412" alt="Screenshot 2026-11-09 171313" src="https://github.com/user-attachments/assets/d22eb2d8-add9-4084-9b7f-d299665fe50f" />


## YouTube video

YouTube (unlisted): _paste your link here_

