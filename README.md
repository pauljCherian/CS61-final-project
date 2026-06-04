# Workout log

Changes from og plan:
- remove muscle group from Exercises (too much complexity, not that useful)
- add notes to WorkoutExercises
- remove all of supplements table
- remove enum from activity type for cardio sessions
- change intensity to 1-5 scale instead of low moderate high
- remove average heart rate from cardio sessions


Backend:
- don't think we need any is admin stuff on the endpoints
- would be good to add triggers to create an automated audit table
    - from project desc "an audit table which logs who has accessed/modified/deleted rows in the database and when, perhaps using database triggers (see day 6)."
    - would give us good credit i think for this

- I added a seed script with all my own data for demo purposes - Jack B
    - to run python3 backend/scripts/seed.py
