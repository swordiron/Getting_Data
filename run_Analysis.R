# Libraries in use

library(data.table)
library(dplyr)

# We have downloaded an unzipped the dataset in our working directory

# Ex. 1 Merging the train and test datasets

# Read the files
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

# Assign names to the variables
colnames(x_train) <- features[,2]
colnames(y_train) <- "activity"
colnames(subject_train) <- "subject"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activity"
colnames(subject_test) <- "subject"

colnames(activity_labels) <- c("activity", "activity_literal")

# Merge the datasets in one dataset
train <- cbind(y_train, subject_train, x_train)
test <- cbind(y_test, subject_test, x_test)
merged_dataset <- rbind(train, test)


# Ex. 2 Extract the measurements on the mean and sd for each measurement

# Read column names
column_names <- colnames(merged_dataset)

# Create vector for every measurement with IDs, mean and sd

mean_and_std <- (grepl("activity", column_names) |
                     grepl("subject", column_names) |
                     grepl("mean..", column_names) |
                     grepl("std...", column_names)
)

# Make subset with mean an sd

dataset_mean_sd <- merged_dataset[ , mean_and_std == TRUE]

# Ex. 3 Uses descriptive activity names to name the activities in the data set

# Replace in the datasets in the activity column the number with the literal
# from activity_labels 

merged_dataset$activity <- factor(merged_dataset$activity, 
                                  levels = activity_labels[, 1], labels = activity_labels[, 2])

dataset_mean_sd$activity <- factor(dataset_mean_sd$activity, 
                                  levels = activity_labels[, 1], labels = activity_labels[, 2])

# Ex. 4 Appropriately labels the data set with descriptive variable names

# remove parenthesis from names(merged_dataset)
names(merged_dataset) <- gsub("[\\(\\)]", "", names(merged_dataset))

# expand abbreviations and clean up names
names(merged_dataset) <- gsub("Acc", "Accelerometer", names(merged_dataset))
names(merged_dataset) <- gsub("Gyro", "Gyroscope", names(merged_dataset))
names(merged_dataset) <- gsub("Mag", "Magnitude", names(merged_dataset))
names(merged_dataset) <- gsub("Freq", "Frequency", names(merged_dataset))
names(merged_dataset) <- gsub("mean", "Mean", names(merged_dataset))
names(merged_dataset) <- gsub("std", "StandardDeviation", names(merged_dataset))
names(merged_dataset) <- gsub("^f", "FrequencyDomain", names(merged_dataset))
names(merged_dataset) <- gsub("^t", "TimeDomain", names(merged_dataset))

# remove parenthesis from names(dataset_mean_sd)
names(dataset_mean_sd) <- gsub("[\\(\\)]", "", names(dataset_mean_sd))

# expand abbreviations and clean up names
names(dataset_mean_sd) <- gsub("Acc", "Accelerometer", names(dataset_mean_sd))
names(dataset_mean_sd) <- gsub("Gyro", "Gyroscope", names(dataset_mean_sd))
names(dataset_mean_sd) <- gsub("Mag", "Magnitude", names(dataset_mean_sd))
names(dataset_mean_sd) <- gsub("Freq", "Frequency", names(dataset_mean_sd))
names(dataset_mean_sd) <- gsub("mean", "Mean", names(dataset_mean_sd))
names(dataset_mean_sd) <- gsub("std", "StandardDeviation", names(dataset_mean_sd))
names(dataset_mean_sd) <- gsub("^f", "FrequencyDomain", names(dataset_mean_sd))
names(dataset_mean_sd) <- gsub("^t", "TimeDomain", names(dataset_mean_sd))

# Ex. 5 From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.

#Setting subject as a factor variable
dataset_mean_sd$subject <- as.factor(dataset_mean_sd$subject)
dataset_mean_sd <- data.table(dataset_mean_sd)

# Creation of tidy_data dataset with the average each variable for each activity and each subject
tidy_data <- aggregate(. ~subject + activity, dataset_mean_sd, mean)

# Ordering the tidy_data by subject and activity and writing it to the file TidyData.txt
tidy_data <- tidy_data[order(tidy_data$subject,tidy_data$activity),]
write.table(tidy_data, file = "TidyData.txt", row.names = FALSE)







