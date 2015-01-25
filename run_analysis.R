## run_analysis.R - course assignment for Coursera Data Science - Getting and Cleaning Data

## set working dir
setwd("/home/jape/coursera/3_Getting_And_Cleaning_Data/getting_and_cleaning_data/UCI HAR Dataset")


## 1. Merges the training and the test sets to create one data set.
###################################################################

## read x, y and subject TRAINING data 
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")

subject_train <- read.table("./train/subject_train.txt")

## read x, y and subject TEST data
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")

subject_test <- read.table("./test/subject_test.txt")

## create combined x data for test and train data
x_data <- rbind(x_test, x_train)

## create combined y data for test and train data
y_data <- rbind(y_test, y_train)

## create combined subject data
subject_data <- rbind(subject_test, subject_train)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#############################################################################################

## load all measures from file
all_measurements <- read.table("features.txt")

##extract only mean and std measurements by greping original file
measurements <- grep("-(mean|std)\\(\\)", all_measurements[, 2])

## create a subset of x_data by measurements only for mean and std
x_data_sub <- x_data[, measurements]

## 3. Uses descriptive activity names to name the activities in the data set and set label names for data
## & 
## 4. Appropriately labels the data set with descriptive variable names. 
########################################################################

## set labels for x data subset
names(x_data_sub) <- all_measurements[measurements, 2]

## read activities from file
activity <- read.table("activity_labels.txt")

## update y_data with activity labels
y_data[,1] <- activity[y_data[,1],2]

## set variable name for y_data
names(y_data) <- "activity"

## set variable name for subject_data
names(subject_data) <- "subject"

## combine all data into one data set
data <- cbind(subject_data, y_data, x_data_sub)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
####################################################################################################################################################

## compose a new tidy data set from data and calculate means except for activity and subject (col 1:2)
tidy = aggregate(data[, 3:68], by=list(activity = data$activity, subject=data$subject), mean)

## write output of tidy file
write.table(tidy, "tidy_mean.txt", row.name=FALSE)

