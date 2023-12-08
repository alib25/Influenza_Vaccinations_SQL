# Influenza_Vaccinations_SQL

**Project Overview**

Use Syntheas' vaccine data to gain valuable insights for healthcare professionals seeking to assess their patients immunization status effectively. Clean the dataset using PostgreSQL and deasign a comprehensive dashboard for the year 2022. The dashboard will provide insights into the distribution of flu shots among patients based on various criteria such as age, race, county, and overall statistics. Additionally, it will display a running total of vaccines administered throughout the year and a list of patients who received the vaccine.

**Data Source**

The data is syntheically generated from [Synthea](https://synthea.mitre.org). Synthea is an open-source, synthetic patient generator that models the medical history of synthetic patients. 

1. Identify Active Patients To ensure that we only include patients who were active at our hospitals, we create a common table expression (CTE) named active_patients. This CTE filters patients who had encounters between January 1, 2020, and December 31, 2022, were not deceased, and were at least 6 months old by December 31, 2022.
2. Flu Shot Data for 2022 Next, we create another CTE called flu_shot_2022 to gather information about flu shots administered in 2022. We select patients who received a flu shot with the code '5302' within the specified date range (January 1, 2022, to December 31, 2022) and aggregate their data to find the earliest flu shot date.

Step 3: Building the Dashboard Now, we construct the main query to generate the flu shots dashboard. We retrieve various patient attributes such as birthdate, race, county, first name, last name, and unique identifiers. We also join the flu_shot_2022 CTE to indicate whether each patient received a flu shot in 2022 ('Yes' or 'No') and provide the earliest flu shot date if applicable.
