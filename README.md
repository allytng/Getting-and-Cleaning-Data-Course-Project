## Getting and Cleaning Data Course Project

This is the Getting and Cleaning Data Course Project. The goal is to prepare tidy data that can be used for later analysis. The data represents that collected from the accelerometers from the Samsung Galaxy 5 smartphone, and can be obtained here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

The R script `run_analysis.R` does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Step 1: Create the merged data set

After downloading the data into the working directory, the first step is to read the various files from the UCI HAR Dataset into R:
* activity_labels.txt 
* features.txt
* subject_train.txt
* X_train.txt
* y_train.txt
* subject_test.txt
* X_test.txt
* y_test.txt

This is followed by merging the test and train data files into one dataset, by subject, activity and results for the various features.

### Step 2: Extract only the measurements on the mean and standard deviation for each measurement.

`run_analysis.R` will extract the feature measurement as long as "mean" or "std" is part of the feature name. This reduces the dataset to 86 features.  

### Step 3: Use descriptive activity names to name the activities in the data set.

`run_analysis.R` merges the descriptive activity name from the 'activity_labels.txt' with the merged dataset, to replace the activity ids with the descriptive activity names. 

### Step 4: Appropriately labels the data set with descriptive variable names.

This step involves tidying the variable names, by removing the brackets, dashes, punctuations and duplicate words, and ensuring that the words are well-spaced to aid reading. 

### Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

This step takes the average of each variable for each activity and each subject, and forms a second, independent tidy data set (using `write.table` to write out a txt file into the working directory). There is a total of 180 rows (30 subjects x 6 activities), and 88 columns (subject id, activity description, and 86 feature measurements on the mean and std deviation). More details on the variables can be found in the 'CodeBook.md'. 

## Reading the independent tidy data set in R

The second independent tidy data set (txt file) can be read into R using the `read.table` command:

<!-- -->

tidydata <- read.table("tidydata.txt", header = TRUE)