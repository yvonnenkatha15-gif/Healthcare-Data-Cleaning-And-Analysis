-- 1. Populating the staging table and identifying duplicates using ROW_NUMBER()
INSERT INTO layoffs_staging2
SELECT `patient_age`,
       `gender`,
       `bmi`,
       `systolic_bp`,
       `diastolic_bp`,
       `cholesterol_mg_dl`,
       `fasting_blood_sugar`,
       `heart_rate_bpm`,
       `previous_admissions`,
       `admission_type`,
       `primary_diagnosis`,
       `medication_adherence`,
       `length_of_stay_days`,
       `treatment_cost_usd`,
       `readmission_30_days`,
       ROW_NUMBER() OVER(
           PARTITION BY  bmi, systolic_bp, diastolic_bp, 
                        cholesterol_mg_dl, fasting_blood_sugar, heart_rate_bpm, 
                        admission_type, primary_diagnosis, 
                        medication_adherence, length_of_stay_days, treatment_cost_usd, 
                        readmission_30_days
       ) AS row_num
FROM healthcare_staging; -- This is your raw, first staging table

-- 2. Safely deleting all duplicate entries where row_num is greater than 1
DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

-- 3. Dropping the row_num helper column to leave a pristine dataset
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
