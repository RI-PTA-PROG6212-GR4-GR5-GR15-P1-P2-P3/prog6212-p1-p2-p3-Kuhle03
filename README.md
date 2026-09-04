
 RaceDay

RaceDay is this kinda full-stack web based event management system, made for the South African road running, walking and cycling community. It enables Event Organisers to set up and steer events, categories, and participant results too, while Participants can scroll through what’s coming up, join races, and also see their own performance timeline from previous entries.

This repository holds **Part 1** of the Portfolio of Evidence: system planning and database design for the RaceDay platform.

 Roles

Organiser
An Organiser logs in and creates, updates, and manages events. They can add new events, sort out the categories inside each event (like 5km, 10km) , see which people enrolled, and then capture participants' results once the race day is done. Kinda straightforward but also very hands on.

**Participant**
A Participant views events that Organisers made, enrols into a category for an event they actually want to join, and can browse their personal history of past enrolments and results, across all the events they’ve put their name down for.

Repo structure  
/docs  
  RaceDay_ERD.png                 -- Entity Relationship Diagram  
  RaceDay_API_Endpoint_Plan.md   -- API endpoint plan  
  RaceDay_Database_Script.sql    -- Database creation and seed script  

README.md  
.github/workflows/validate-repo.yml  

Setup Intructions  
Clone the repository.  
Open SQL Server Management Studio (SSMS).  
Open docs/RaceDay_Database_Script.sql and run it against your SQL Server instance — it builds the RaceDayDB database, all tables, and loads a few starter rows.  
Take a look at docs/RaceDay_ERD.png for the data model, and also docs/RaceDay_API_Endpoint_Plan.md for what the API surface is supposed to be, right before Part 2.  

CI/CD  

A GitHub Actions workflow (.github/workflows/validate-repo.yml) runs on every push and verifies the repo layout stays ok, meaning the /docs folder exists, and it includes the ERD, the endpoint plan, and the SQL script … plus that this README file is there too.  

Screenshot of a successful green build:  
<img width="1321" height="485" alt="Screenshot 2026-09-04 093335" src="https://github.com/user-attachments/assets/cee7a517-5d1b-41bd-b516-5765db9a1a59" />


Video Walkthrough  

YouTube (unlisted) link: [Insert your video link here]  

The video walks through the planning documents, ERD calls, endpoint plan decisions, and it runs the SQL script live, in SSMS.
