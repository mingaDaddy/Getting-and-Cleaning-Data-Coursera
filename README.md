# Getting and Cleaning Data Course Project
The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

This repository contains **5** files:
- **CodeBook.md**, which includes the summary, data and variables explanation, and work performed to get the tidy data from the original raw data
- **readme.md**, this file
- **run_script.R**, which includes the R Script for getting the tidy data
- **data.csv**, which contains train and test observations (only mean and standard deviation variables)
- **dataAggregated.csv**, which contains aggregated data (by activity and subject, using mean as aggregation function)

## Replicating tidy data:
To replicate tidy data (to obtain data.csv and dataAggregated.csv) just download run_script.R and execute it in your own R instance. The scripts will create all necessary folders, download the raw data files (if needed), unzip them and create the comma separated files.

It will take your default working directory as basis path.


