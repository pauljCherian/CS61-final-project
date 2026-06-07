-- Workout Tracking App — Schema
-- NOTE: Claude made this file from our Entities, Relationships, and schema design discussions.
-- All of the tables and foreign keys we created were of our original schema design, Claude only suggested adding ENUMs and Domain CHECKs on our table attributes.
CREATE DATABASE IF NOT EXISTS workout_tracker;
USE workout_tracker;

-- ---------------------------------------------------------------------------
-- Users
-- ---------------------------------------------------------------------------
CREATE TABLE Users (
    UserID         INT AUTO_INCREMENT PRIMARY KEY,
    Username       VARCHAR(50)  NOT NULL UNIQUE,
    Email          VARCHAR(255) NOT NULL UNIQUE,
    HashedPassword VARCHAR(255) NOT NULL,
    FirstName      VARCHAR(100),
    LastName       VARCHAR(100),
    City           VARCHAR(100),
    State          VARCHAR(100),
    IsAdmin        BOOLEAN      NOT NULL DEFAULT FALSE,
    CreatedAt      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ;

-- ---------------------------------------------------------------------------
-- Exercises (reusable catalog)
-- ---------------------------------------------------------------------------
CREATE TABLE Exercises (
    ExerciseID   INT AUTO_INCREMENT PRIMARY KEY,
    ExerciseName VARCHAR(150) NOT NULL UNIQUE
) ;

-- ---------------------------------------------------------------------------
-- Workouts (a dated session belonging to a user)
-- ---------------------------------------------------------------------------
CREATE TABLE Workouts (
    WorkoutID   INT AUTO_INCREMENT PRIMARY KEY,
    UserID      INT NOT NULL,
    WorkoutDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    Description VARCHAR(255),
    Notes       TEXT,
    CreatedAt   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_workouts_user
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON DELETE CASCADE,
    INDEX idx_workouts_user_date (UserID, WorkoutDate)
) ;

-- ---------------------------------------------------------------------------
-- WorkoutExercise (junction: which exercises were done in a workout, in order)
-- ---------------------------------------------------------------------------
CREATE TABLE WorkoutExercise (
    WorkoutExerciseID INT AUTO_INCREMENT PRIMARY KEY,
    WorkoutID         INT NOT NULL,
    ExerciseID        INT NOT NULL,
    OrderNum          INT,            -- sequence within the workout
    Notes             TEXT,           -- per-exercise notes (plan, cues)
    CONSTRAINT fk_we_workout
        FOREIGN KEY (WorkoutID)  REFERENCES Workouts(WorkoutID)
        ON DELETE CASCADE,
    CONSTRAINT fk_we_exercise
        FOREIGN KEY (ExerciseID) REFERENCES Exercises(ExerciseID),
    CONSTRAINT uq_we_workout_order UNIQUE (WorkoutID, OrderNum),
    INDEX idx_we_workout (WorkoutID),
    INDEX idx_we_exercise (ExerciseID)
) ;

-- ---------------------------------------------------------------------------
-- WorkoutSets (renamed from "Sets" — SET/SETS are reserved in MySQL)
-- ---------------------------------------------------------------------------
CREATE TABLE WorkoutSets (
    SetID             INT AUTO_INCREMENT PRIMARY KEY,
    WorkoutExerciseID INT NOT NULL,
    SetNum            INT NOT NULL,
    Weight            DECIMAL(6,2) CHECK (Weight >= 0),
    Unit              ENUM('kg','lb') NOT NULL DEFAULT 'lb',
    Reps              INT CHECK (Reps >= 0),
    RPE               DECIMAL(3,1) CHECK (RPE >= 0 AND RPE <= 10),
    CONSTRAINT fk_sets_we
        FOREIGN KEY (WorkoutExerciseID) REFERENCES WorkoutExercise(WorkoutExerciseID)
        ON DELETE CASCADE,
    CONSTRAINT uq_sets_we_setnum UNIQUE (WorkoutExerciseID, SetNum),
    INDEX idx_sets_we (WorkoutExerciseID)
) ;

-- ---------------------------------------------------------------------------
-- CardioSessions
-- ---------------------------------------------------------------------------
CREATE TABLE CardioSessions (
    CardioID        INT AUTO_INCREMENT PRIMARY KEY,
    WorkoutID       INT NOT NULL,
    ActivityType    VARCHAR(150),
    Duration        INT          CHECK (Duration >= 0),    -- seconds
    Distance        DECIMAL(10,2) CHECK (Distance >= 0),
    Units           ENUM('mi','km','m'),                   -- unit for Distance
    Intensity       TINYINT      CHECK (Intensity >= 1 AND Intensity <= 5),
    Notes           TEXT,
    CONSTRAINT fk_cardio_workout
        FOREIGN KEY (WorkoutID) REFERENCES Workouts(WorkoutID)
        ON DELETE CASCADE,
    INDEX idx_cardio_workout (WorkoutID)
) ;

-- ---------------------------------------------------------------------------
-- Bodyweight log
-- ---------------------------------------------------------------------------
CREATE TABLE Bodyweight (
    WeightID     INT AUTO_INCREMENT PRIMARY KEY,
    UserID       INT NOT NULL,
    RecordedDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    Weight       DECIMAL(6,2) CHECK (Weight >= 0),
    Unit         ENUM('kg','lb') NOT NULL DEFAULT 'lb',
    CONSTRAINT fk_bw_user
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON DELETE CASCADE,
    INDEX idx_bw_user_date (UserID, RecordedDate)
) ;

-- ---------------------------------------------------------------------------
-- Sleep log
-- ---------------------------------------------------------------------------
CREATE TABLE Sleep (
    SleepID         INT AUTO_INCREMENT PRIMARY KEY,
    UserID          INT NOT NULL,
    SleepDate       DATE NOT NULL DEFAULT (CURRENT_DATE),
    Duration        INT CHECK (Duration >= 0),    -- minutes
    CONSTRAINT fk_sleep_user
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON DELETE CASCADE,
    INDEX idx_sleep_user_date (UserID, SleepDate)
) ;
-- ---------------------------------------------------------------------------
-- One generic audit table for all tracked events
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS AuditLog (
    AuditID    INT AUTO_INCREMENT PRIMARY KEY,
    TableName  VARCHAR(50)  NOT NULL,                 -- 'Users' or 'Workouts'
    Action     ENUM('CREATE','DELETE') NOT NULL,
    RowID      INT          NOT NULL,                 -- the UserID / WorkoutID affected
    ChangedBy  VARCHAR(128) NOT NULL DEFAULT (CURRENT_USER()),  -- DB user that did it
    ChangedAt  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_audit_table_action (TableName, Action),
    INDEX idx_audit_changed_at (ChangedAt)
);

-- ---------------------------------------------------------------------------
-- Users: created / deleted
-- ---------------------------------------------------------------------------
CREATE TRIGGER trg_users_after_insert
AFTER INSERT ON Users
FOR EACH ROW
INSERT INTO AuditLog (TableName, Action, RowID)
VALUES ('Users', 'CREATE', NEW.UserID);

CREATE TRIGGER trg_users_after_delete
AFTER DELETE ON Users
FOR EACH ROW
INSERT INTO AuditLog (TableName, Action, RowID)
VALUES ('Users', 'DELETE', OLD.UserID);

-- ---------------------------------------------------------------------------
-- Workouts: created / deleted
-- ---------------------------------------------------------------------------
CREATE TRIGGER trg_workouts_after_insert
AFTER INSERT ON Workouts
FOR EACH ROW
INSERT INTO AuditLog (TableName, Action, RowID)
VALUES ('Workouts', 'CREATE', NEW.WorkoutID);

CREATE TRIGGER trg_workouts_after_delete
AFTER DELETE ON Workouts
FOR EACH ROW
INSERT INTO AuditLog (TableName, Action, RowID)
VALUES ('Workouts', 'DELETE', OLD.WorkoutID);
