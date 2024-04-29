
# Medication Data Management and Synthetic Patient Data Generation

This repository contains R scripts for managing a list of medications and generating synthetic patient data. These tools are ideal for researchers and developers working in health informatics who need to simulate patient data for analysis or software testing.

## Features

- **Medication Database**: Includes 50 common medications along with their dosage forms and doses (not BNF verified).
- **Synthetic Patient Data Generation**: Functions to generate synthetic data for a set of patients, including prescriptions based on the medication database.

## Dependencies

To run the scripts, you will need R and some packages from the Tidyverse, among others. Here's how to install the required packages:

```R
install.packages("tidyverse")
install.packages("openxlsx")
install.packages("lubridate")
install.packages("purrr")
install.packages("tibble")
```

## Usage

### Medication Database

The script sets up a tibble with 50 different medications, adjusting some specific medications to have the correct dosage form (e.g., inhalers and injections) and dose units (mcg for inhalers).

### Generating Synthetic Patient Data

`generate_single_patient_data()` and `generate_all_patients_data()` are functions designed to simulate patient encounters data:

- `generate_single_patient_data()`: Generates data for a single patient.
- `generate_all_patients_data()`: Uses the single patient function to generate data for multiple patients (default is 500).

### Saving Data

Generated patient data is saved to a CSV file `patients_data_expanded.csv` without redundant quotes and without row names.

## Example

Here is how to generate data for 500 patients and save it:

```R
# Generate data for 500 patients
patients_data <- generate_all_patients_data(500)

# Save to CSV
write.csv(patients_data,"patients_data_expanded.csv",row.names = F,quote = F)
```

## Contributing

Contributions to this project are welcome, specially for the BNF route, dosage specs of the drugs. Please feel free to fork the repository and submit pull requests.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
