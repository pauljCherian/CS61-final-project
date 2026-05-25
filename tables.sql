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
    CreatedAt      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ;

-- ---------------------------------------------------------------------------
-- Exercises (reusable catalog)
-- ---------------------------------------------------------------------------
CREATE TABLE Exercises (
    ExerciseID   INT AUTO_INCREMENT PRIMARY KEY,
    ExerciseName VARCHAR(150) NOT NULL UNIQUE,
    MuscleGroup  VARCHAR(100)
) ;

-- ---------------------------------------------------------------------------
-- Workouts (a dated session belonging to a user)
-- ---------------------------------------------------------------------------
CREATE TABLE Workouts (
    WorkoutID   INT AUTO_INCREMENT PRIMARY KEY,
    UserID      INT NOT NULL,
    WorkoutDate DATE NOT NULL,
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
    CONSTRAINT fk_we_workout
        FOREIGN KEY (WorkoutID)  REFERENCES Workouts(WorkoutID)
        ON DELETE CASCADE,
    CONSTRAINT fk_we_exercise
        FOREIGN KEY (ExerciseID) REFERENCES Exercises(ExerciseID),
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
    INDEX idx_sets_we (WorkoutExerciseID)
) ;

-- ---------------------------------------------------------------------------
-- CardioSessions
-- ---------------------------------------------------------------------------
CREATE TABLE CardioSessions (
    CardioID        INT AUTO_INCREMENT PRIMARY KEY,
    WorkoutID       INT NOT NULL,
    ActivityType    VARCHAR(100),
    DurationMinutes INT          CHECK (DurationMinutes >= 0),
    DistanceMeters  DECIMAL(10,2) CHECK (DistanceMeters >= 0),
    Intensity       VARCHAR(50),
    AvgHeartRate    INT          CHECK (AvgHeartRate >= 0),
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
    RecordedDate DATE NOT NULL,
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
    SleepDate       DATE NOT NULL,
    DurationMinutes INT CHECK (DurationMinutes >= 0),
    CONSTRAINT fk_sleep_user
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON DELETE CASCADE,
    INDEX idx_sleep_user_date (UserID, SleepDate)
) ;

-- ---------------------------------------------------------------------------
-- Supplements (regimen history via ValidFrom/ValidTo)
-- ---------------------------------------------------------------------------
CREATE TABLE Supplements (
    SuppID         INT AUTO_INCREMENT PRIMARY KEY,
    UserID         INT NOT NULL,
    SupplementName VARCHAR(150) NOT NULL,
    Dosage         VARCHAR(100),
    ValidFrom      DATE NOT NULL,
    ValidTo        DATE,
    CONSTRAINT fk_supp_user
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
        ON DELETE CASCADE,
    CONSTRAINT chk_supp_dates CHECK (ValidTo IS NULL OR ValidTo >= ValidFrom),
    INDEX idx_supp_user (UserID)
) ;