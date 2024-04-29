library(tidyverse)
library(openxlsx)
library(dplyr)
library(tidyr)
library(lubridate)
library(purrr)
library(tibble)

set.seed(123) # For reproducibility


# Define the medication details with 50 entries
medications <- tibble(
  medicationCodeDisplay = c(
    "Ibuprofen", "Paracetamol", "Naproxen", "Prednisone", "Methotrexate", 
    "Metoprolol", "Carbidopa/Levodopa", "Diazepam", "Sertraline", 
    "Metformin", "Salbutamol", "Atorvastatin", "Lisinopril", "Amlodipine", 
    "Hydrochlorothiazide", "Simvastatin", "Levothyroxine", "Gabapentin",
    "Warfarin", "Furosemide", "Albuterol", "Lorazepam", "Fluoxetine", 
    "Omeprazole", "Losartan", "Aspirin", "Sildenafil", "Tadalafil",
    "Varenicline", "Bupropion", "Insulin Glargine", "Glipizide", 
    "Januvia", "Victoza", "Tramadol", "Cyclobenzaprine", "Celecoxib",
    "Ciprofloxacin", "Amoxicillin", "Azithromycin", "Doxycycline",
    "Clonazepam", "Citalopram", "Escitalopram", "Venlafaxine", 
    "Budesonide", "Fluticasone", "Montelukast", "Zolpidem", "Melatonin"
  ),
  dosageRouteCodingDisplay = rep("Tablet", 50),
  dose = rep(100, 50), # Example fixed dose for simplification
  doseUnit = rep("mg", 50)
)

# Update specific entries to match the proper dosage forms and units
medications$dosageRouteCodingDisplay[c(5, 11, 31, 46, 47, 48)] <- c("Injection", "Inhaler", "Injection", "Inhaler", "Inhaler", "Inhaler")
medications$doseUnit[c(11, 46, 47, 48)] <- "mcg" # Adjust dose units for inhalers

# Function to generate a single patient's data with consistent age and gender
generate_single_patient_data <- function(patient_id, age_group, gender, num_records) {
  patient_data <- tibble(
    X_source.patientID = patient_id,
    X_source.featureAnalysisMeta.occurredDateTime = seq(from = as.Date('2018-01-01'), by = "month", length.out = num_records),
    X_source.diagnosis_0_condition_display = sample(c("Prescription", "Syncope and collapse", 
                                                      "Other specified enthesopathies of left lower limb, excluding foot",
                                                      "Generalized edema", "Bilateral primary osteoarthritis of knee"), num_records, replace = TRUE),
    X_source.gender = gender,
    X_source.age = age_group,
    X_source.conditionTags = "{}",
    X_source.medicationCodeDisplay = NA_character_,
    X_source.dosageRouteCodingDisplay = NA_character_,
    X_source.dose = NA_real_,
    X_source.doseUnit = NA_character_,
    X_source.effectiveDateTimeStart = as.Date(NA),
    X_source.effectiveDateTimeEnd = as.Date(NA)
  )
  
  # Add medication details where the condition is 'Prescription'
  patient_data <- patient_data %>% 
    mutate(
      medicationDetails = if_else(X_source.diagnosis_0_condition_display == "Prescription", sample(medications$medicationCodeDisplay, 1), NA_character_),
      X_source.medicationCodeDisplay = if_else(X_source.diagnosis_0_condition_display == "Prescription", sample(medications$medicationCodeDisplay, 1), NA_character_),
      X_source.dosageRouteCodingDisplay = if_else(X_source.diagnosis_0_condition_display == "Prescription", sample(medications$dosageRouteCodingDisplay, 1), NA_character_),
      X_source.dose = if_else(X_source.diagnosis_0_condition_display == "Prescription", sample(medications$dose, 1), NA_real_),
      X_source.doseUnit = if_else(X_source.diagnosis_0_condition_display == "Prescription", sample(medications$doseUnit, 1), NA_character_),
      X_source.effectiveDateTimeStart = if_else(X_source.diagnosis_0_condition_display == "Prescription", X_source.featureAnalysisMeta.occurredDateTime, as.Date(NA)),
      X_source.effectiveDateTimeEnd = if_else(X_source.diagnosis_0_condition_display == "Prescription", X_source.featureAnalysisMeta.occurredDateTime + days(sample(7:30, 1)), as.Date(NA))
    ) %>%
    select(-medicationDetails) # Remove the temporary column
  
  return(patient_data)
}

# Function to generate all patients' data
generate_all_patients_data <- function(num_patients) {
  map_df(1:num_patients, ~{
    patient_id <- sprintf("PAT%05d", .x)
    gender <- sample(c("male", "female"), 1)
    age_group <- sample(c("60-64", "65-69", "70-74", "75-79", "80-84", "85-89", "90-94"), 1)
    num_records <- sample(3:7, 1)
    generate_single_patient_data(patient_id, age_group, gender, num_records)
  })
}

# Generate data for 500 patients
patients_data <- generate_all_patients_data(500)

# save
write.csv(patients_data,"patients_data_expanded.csv",row.names = F,quote = F)
