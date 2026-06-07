# Workout log

## SUBMISSION DEMO LINK
[YouTube demo linked here](https://youtu.be/y9ezfZBDVmY)

## Changes from original plan:
- remove muscle group from Exercises (too much complexity, not that useful)
- add notes to WorkoutExercises
- remove all of supplements table
- remove enum from activity type for cardio sessions
- change intensity to 1-5 scale instead of low moderate high
- remove average heart rate from cardio sessions
- exercises are not user-specific. users can enter any exercises they want on the front end. The exercise table is not a fixed catalog, but instead a list of all exercises that user may want to add. 


## Backend:
- don't think we need any is admin stuff on the endpoints
- would be good to add triggers to create an automated audit table
    - from project desc "an audit table which logs who has accessed/modified/deleted rows in the database and when, perhaps using database triggers (see day 6)."
    - would give us good credit i think for this


## Database setup
Load the schema as root because creating the audit triggers requires admin privileges.
```mysql -u root -p < tables.sql```

## Seeding
```python3 backend/scripts/seed.py```

## AI Acknowledgement
Some code in this repo was written by Claude Code Opus 4.8, those sections are documented.
- Some JS work in the frontend
- Some HTML work in the frontend
- Seed script
