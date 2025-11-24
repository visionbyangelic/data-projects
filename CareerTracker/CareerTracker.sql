--by visionbyangelic

-- STEP 1: Create New Database and Use It
CREATE DATABASE CareerTracker;
GO

USE CareerTracker;
GO

-- STEP 2: Create Tables
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE Skills (
    skill_id INT PRIMARY KEY IDENTITY(1,1),
    skill_name VARCHAR(50)
);

CREATE TABLE Jobs (
    job_id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(100),
    company VARCHAR(100),
    location VARCHAR(100),
    posted_date DATE
);

CREATE TABLE JobSkills (
    job_id INT,
    skill_id INT,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id),
    FOREIGN KEY (skill_id) REFERENCES Skills(skill_id)
);

CREATE TABLE Applications (
    application_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    job_id INT,
    status VARCHAR(20),
    applied_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id)
);

CREATE TABLE UserSkills (
    user_id INT,
    skill_id INT,
    progress_level VARCHAR(20),
    PRIMARY KEY (user_id, skill_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (skill_id) REFERENCES Skills(skill_id)
);

-- STEP 3: Add Sample User (Zee)
INSERT INTO Users (name, email)
VALUES ('Zee', 'zee@halowrx.com');

-- STEP 4: Add Skills
INSERT INTO Skills (skill_name)
VALUES 
('Python'), ('SQL'), ('TensorFlow'), ('OpenCV'), 
('Pandas'), ('Scikit-learn'), ('FastAPI'),
('Natural Language Processing'), ('Computer Vision'), ('Git');

-- STEP 5: Add Jobs
INSERT INTO Jobs (title, company, location, posted_date)
VALUES 
('AI Research Intern', 'DeepSight Labs', 'Remote (Nigeria)', '2025-06-01'),
('Computer Vision Engineer', 'SkyVision AI', 'Lagos, Nigeria', '2025-05-20'),
('ML Developer (NLP)', 'NeuroSpark', 'Remote', '2025-06-10'),
('Junior AI Engineer', 'SoftCore Robotics', 'Abuja, Nigeria', '2025-06-05');

-- STEP 6: Link Skills to Jobs (JobSkills)
INSERT INTO JobSkills (job_id, skill_id) VALUES 
(1,1), (1,2), (1,3), (1,6), (1,10),
(2,1), (2,2), (2,4), (2,5), (2,9),
(3,1), (3,2), (3,8), (3,6), (3,10),
(4,1), (4,2), (4,3), (4,5), (4,7);

-- STEP 7: Insert Applications by Zee
INSERT INTO Applications (user_id, job_id, status, applied_date)
VALUES 
(1, 1, 'Applied', '2025-06-11'),
(1, 2, 'Interview', '2025-06-12'),
(1, 3, 'Rejected', '2025-06-14'),
(1, 4, 'Offer', '2025-06-15');

-- STEP 8: Insert Zee’s Skills & Proficiency Levels
INSERT INTO UserSkills (user_id, skill_id, progress_level)
VALUES
(1, 1, 'Proficient'),       -- Python
(1, 2, 'Proficient'),       -- SQL
(1, 3, 'Learning'),         -- TensorFlow
(1, 4, 'Intermediate'),     -- OpenCV
(1, 5, 'Proficient'),       -- Pandas
(1, 6, 'Intermediate'),     -- Scikit-learn
(1, 7, 'Learning'),         -- FastAPI
(1, 9, 'Intermediate'),     -- Computer Vision
(1, 10, 'Proficient');      -- Git

-- STEP 9: Create Smart Views and Queries

-- View: Best Job Matches for Zee
DROP VIEW IF EXISTS JobMatches;
GO

CREATE VIEW JobMatches AS
SELECT 
    j.title AS JobTitle,
    j.company AS Company,
    COUNT(*) AS MatchingSkillCount
FROM Jobs j
JOIN JobSkills js ON j.job_id = js.job_id
JOIN UserSkills us ON js.skill_id = us.skill_id
WHERE us.user_id = 1
  AND us.progress_level IN ('Intermediate', 'Proficient')
GROUP BY j.title, j.company
ORDER BY MatchingSkillCount DESC;

-- Query 1: View Job Matches
SELECT * FROM JobMatches;

-- Query 2: Most In-Demand Skills
SELECT s.skill_name, COUNT(*) AS times_required
FROM JobSkills js
JOIN Skills s ON js.skill_id = s.skill_id
GROUP BY s.skill_name
ORDER BY times_required DESC;

-- Query 3: Missing Skills for Zee
SELECT DISTINCT s.skill_name
FROM JobSkills js
JOIN Skills s ON js.skill_id = s.skill_id
WHERE js.skill_id NOT IN (
    SELECT skill_id FROM UserSkills WHERE user_id = 1
);
