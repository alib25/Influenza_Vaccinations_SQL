/*
Objectives
Generate a with flu vaccine dashboard for 2022 that does the following:

1. Total % of patients getting flu shots stratisfied by:
	a. Age
	b. Race
	c. County (On a map)
	d. Overall
2. Running total of flu shots over the course of 2022
3. Total number of flu shots given in 2022
4. A list of patients that show whether or not they received the flu shot

Requirements: Patients must have been active at our hospital.
*/
/*
Filter patients who are still active on the condition that they 
--are not dead and have had encounters with the healthcare system in the past
--2 years and must be 6 months and older because people who are
--6 months and older are required to get flu shots every year
*/

WITH active_patients AS
(
SELECT DISTINCT patient, EXTRACT(year FROM age('2022-12-31', pat.birthdate)) as age
FROM encounters AS e
JOIN patients AS pat
	ON e.patient = pat.id
WHERE start BETWEEN '2020-01-01 00:00' AND '2022-12-31 23:59'
	AND pat.deathdate IS NULL
	AND EXTRACT(year FROM age('2022-12-31', pat.birthdate)) >= 6
),

/*
-- Filter patients who took Flu shots only in 2022 from immunizations
-- table choosing only the earliest dateshot was taken 
--(to prevent repetition) as some patients took more than 1 shot
--This is a Common Table Expression (CTE). This is to create a one-to
--one join with the patients table so we don't get repeated values
flu_shot_2022 AS
*/

(
SELECT patient, min(date) AS earliest_flu_shot_2022 
FROM immunizations
WHERE code = '5302'
	AND date BETWEEN '2022-01-01 00:00' AND '2022-12-31 23:59'
GROUP BY patient
)

/*
Get necessary fields from patients table and join to CTE above
*/


SELECT pat.birthdate, pat.race, pat.county, pat.id, pat.first, pat.last, 
flu.earliest_flu_shot_2022, flu.patient, active.age,
	CASE WHEN flu.patient IS NOT NULL THEN 1 
		ELSE 0
		END AS flu_shot_2022 
FROM public.patients AS pat
LEFT JOIN flu_shot_2022 AS flu
	ON pat.id = flu.patient
LEFT JOIN active_patients AS active 
	ON pat.id = active.patient
--CASE statement to create binary field to help calculate count 
--and percentage of those who didn't get the flu shot
WHERE 1=1
	AND pat.id IN (SELECT patient FROM active_patients);
	
