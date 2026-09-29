SELECT * FROM social_media_addiction.social_media_dopamine_productivity;
ALTER TABLE social_media_addiction.social_media_dopamine_productivity
RENAME TO social_media_addiction.smd_productivity;

USE social_media_addiction;
SELECT * FROM smd_productivity;

#Total No of Participants
SELECT COUNT(DISTINCT participant_id) AS Total_count_of_participants
FROM smd_productivity;

# Age Group of Participants
SELECT 
age_group,
COUNT(DISTINCT participant_id) AS Count_of_participants
FROM smd_productivity
GROUP BY age_group;

# Count of Participants and their Primary Platform of Usage
SELECT 
COUNT(DISTINCT participant_id) AS Count_of_participants,
primary_platform
FROM smd_productivity
GROUP BY primary_platform;

# Count of participants with their employement status and their avg daily social media hours
SELECT
COUNT(DISTINCT participant_id) AS Count_of_participants,
employment_status,
ROUND(AVG(avg_daily_sm_hours), 1) AS Avg_daily_sm_hours
FROM smd_productivity
GROUP BY employment_status
ORDER BY Avg_daily_sm_hours DESC;

# count of participants and their age Group, daily_check frequency
SELECT 
COUNT(DISTINCT participant_id) AS Count_of_participants,
ROUND(AVG(age), 1) AS avg_age,
daily_check_frequency
FROM smd_productivity
GROUP BY daily_check_frequency
ORDER BY avg_age;

SELECT 
    age_group,
    daily_check_frequency,
    COUNT(DISTINCT participant_id) AS Count_of_participants,
    ROUND(AVG(age), 1) AS avg_age
FROM smd_productivity
GROUP BY age_group, daily_check_frequency
ORDER BY avg_age ASC, Count_of_participants DESC;

# Daily Check Frequency vs. Deep Work & Attention Span
SELECT 
COUNT(DISTINCT participant_id) AS Count_of_participants,
daily_check_frequency,
ROUND(AVG(deep_work_duration_minutes), 1) AS Avg_deep_work_mins,
ROUND(AVG(attention_span_minutes), 1) AS Avg_attention_span_minus
FROM smd_productivity
GROUP BY daily_check_frequency
ORDER BY Avg_deep_work_mins;

#Digital Habits During Work/Study vs. Productivity Outcomes
SELECT
sm_during_work_study,
notifications_always_on,
COUNT(DISTINCT participant_id) AS Count_of_participants,
ROUND(AVG(tasks_completed_per_day), 1) AS Avg_tasks_completed_per_day,
ROUND(AVG(work_quality_self_rating), 1) AS Avg_work_quality
FROM smd_productivity
GROUP BY sm_during_work_study, notifications_always_on
ORDER BY avg_tasks_completed_per_day;

#Screen Time vs Productivity(Bucketed Correlation)
SELECT 
    CASE
       WHEN avg_daily_screen_time_hours < 4 THEN 'Low (<4hrs)'
       WHEN avg_daily_screen_time_hours BETWEEN 4 AND 8 THEN 'Medium (4-8hrs)'
       ELSE 'High (>8hrs)'
	 END AS Screen_Time_bucket,
	 AVG(productivity_self_rating) AS Avg_productivity_rating,
     COUNT(DISTINCT participant_id) AS Count_of_participants
FROM smd_productivity
GROUP BY screen_time_bucket
ORDER BY Avg_productivity_rating DESC;


#Psychological Triggers vs Productivity Decline
# FOMO/dopamine vs mind wandering: fomo_score, comparison_to_others_score, validation_seeking_score vs productivity_decline_score
SELECT
COUNT(DISTINCT participant_id) AS Count_of_participants,
productivity_decline_score,
AVG(fomo_score) AS avg_fomo_score,
AVG(comparison_to_others_score) AS Avg_comparison_to_others_score,
AVG(validation_seeking_score) AS Avg_validation_score
FROM smd_productivity
GROUP BY productivity_decline_score
ORDER BY productivity_decline_score;

#Detox Behavior Analysis (unexplored column set)
#withdrawal_attempt_count, longest_detox_days, severity_stage
SELECT
COUNT(DISTINCT participant_id) AS Count_of_participants,
severity_stage,
AVG(withdrawal_attempt_count) AS Avg_withdrawal_attempts,
AVG(longest_detox_days) AS Avg_longest_detox_days
FROM smd_productivity
GROUP BY severity_stage
ORDER BY avg_withdrawal_attempts DESC;

# Sleep Quality vs Digital Wellbeing
SELECT
sleep_quality,
ROUND(AVG(digital_wellbeing_score), 1) AS Avg_digital_wellbeing_score,
COUNT(DISTINCT participant_id) AS Count_of_participants
FROM smd_productivity
GROUP BY sleep_quality
ORDER BY Avg_digital_wellbeing_score DESC;

#Notification Habits vs Restlessness
SELECT
COUNT(DISTINCT participant_id) AS Count_of_participants,
notifications_always_on,
ROUND(AVG(restlessness_score), 1) AS Avg_restlessness_score
FROM smd_productivity
GROUP BY notifications_always_on;

#Ranking Query — Top 5 Riskiest Nationalities
SELECT
nationality,
COUNT(DISTINCT participant_id) AS Count_of_participants,
ROUND(AVG(sm_addiction_risk_score), 1) AS avg_sm_risk
FROM smd_productivity
GROUP BY nationality
HAVING COUNT(DISTINCT participant_id) >= 5
ORDER BY avg_sm_risk DESC
LIMIT 5;

#social media addiction according to the age group
WITH avg_age_group AS (
    SELECT
        age_group,
        ROUND(AVG(productivity_self_rating), 1) AS avg_productivity_rating,
        ROUND(AVG(sm_addiction_risk_score), 1) AS avg_sm_risk_score
	FROM smd_productivity
    GROUP BY age_group
)
SELECT *
FROM avg_age_group
ORDER BY avg_sm_risk_score DESC;

SELECT 
    participant_id,
    occupation_category,
    sm_addiction_risk_score,
    RANK() OVER (PARTITION BY occupation_category ORDER BY sm_addiction_risk_score DESC) AS risk_rank
FROM smd_productivity;


