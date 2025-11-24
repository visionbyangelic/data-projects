
# 🎯 Career Tracker — SQL Project

A personal SQL-based project to track job applications, required skills, and skill gaps as you navigate your tech career.

## 💡 What It Does

This project creates a database called `CareerTracker` that:

- Tracks your job applications, statuses, and interview progress.
- Maps jobs to required skills.
- Records your current skills and progress levels.
- Recommends best-matching jobs based on your skill proficiency.
- Shows skill gaps based on jobs you've applied to.
- Reveals most in-demand skills across all jobs.

## 🧱 Database Schema

### Tables

- **Users**: Stores user profiles.
- **Skills**: Catalog of all technical skills.
- **Jobs**: Job listings.
- **JobSkills**: Links jobs to required skills.
- **Applications**: Tracks applications and statuses.
- **UserSkills**: User’s skill proficiency levels.

### Views

- **JobMatches**: Ranks job listings based on how many of your skills match the job requirements.

## 📊 Sample Features

- ✅ See top jobs that match your current skills.
- ❌ Find out what skills you're missing.
- 📈 Discover the most frequently requested skills in job listings.

## 🧠 Sample Queries

```sql
-- See best matches
SELECT * FROM JobMatches;

-- See most in-demand skills
SELECT skill_name, COUNT(*) FROM JobSkills
JOIN Skills ON JobSkills.skill_id = Skills.skill_id
GROUP BY skill_name
ORDER BY COUNT(*) DESC;

-- See missing skills
SELECT skill_name FROM Skills
WHERE skill_id NOT IN (
    SELECT skill_id FROM UserSkills WHERE user_id = 1
);
