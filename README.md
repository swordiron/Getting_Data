This repositry is the course project for the Getting and Cleaning Data Coursera course. 
The script run_analysis.R, does the following steps asuming the dataset is unzipped in the working directory:

Load the activity and feature information
Loads both the training and test datasets
Loads the activity and subject data for each dataset, and merges those columns with the dataset
Assign names to the variables
Merges the two datasets
Creates a vector for every measurement with IDs, mean and sd to make a subset with mean an sd
Converts the activity and subject columns into factors
Creates a tidy dataset that consists of the average value of each variable for activity and subject.
The end result is written to the file TidyData.txt