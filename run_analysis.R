# You should create one R script called run_analysis.R that does the following.

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
-----------------------------------
        
# Download data and unzip folder into working directory, if not already done 
dataset_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"     

if (!file.exists("galaxydata.zip")) {        
        download.file(dataset_url, "galaxydata.zip")
}

if (!dir.exists(file.path("galaxydata", "UCI HAR Dataset"))) {
        unzip("galaxydata.zip", exdir = "galaxydata")
}

# Read activity labels and features data into R 
activitylabel <- read.table("galaxydata/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
names(activitylabel) <- c("activityid", "activity")  ## rename column names 

features <- read.table("galaxydata/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

# Read 3 data files from train folder into R and merge them
trainSubjects <- read.table("galaxydata/UCI HAR Dataset/train/subject_train.txt")
trainActivities <- read.table("galaxydata/UCI HAR Dataset/train/y_train.txt")
trainResults <- read.table("galaxydata/UCI HAR Dataset/train/X_train.txt")

trainData <- cbind(trainSubjects, trainActivities, trainResults)

# Read 3 data files from test folder into R and merge them
testSubjects <- read.table("galaxydata/UCI HAR Dataset/test/subject_test.txt")
testActivities <- read.table("galaxydata/UCI HAR Dataset/test/y_test.txt")
testResults <- read.table("galaxydata/UCI HAR Dataset/test/X_test.txt")

testData <- cbind(testSubjects, testActivities, testResults)

# Merge the train and test data to create one dataset
allData <- rbind(trainData, testData)

# Select only required mean and std measurements, i.e. whenever "mean" or "std" is part of a feature
selectFeatures <- grepl("[Mm]ean|std", features$V2)
selectFeaturesLabels <- features[selectFeatures, 2]

allData <- allData[selectFeatures]

# Relabel column names in merged dataset
names(allData) <- c("subject", "activityid", selectFeaturesLabels)

# Use descriptive activy names to name the activities in the dataset 
allData <- merge(x = allData, y = activitylabel, by.x = "activityid", by.y = "activityid")
library(dplyr) ## load dplyr package
allData <- select(allData, -activityid) ## remove activityid column 
allData <- select(allData, subject, activity, 2:87) ## reorder columns to starts with subject, then activity 

# Appropriately label the data set with descriptive variable names
names(allData) <- gsub("[()]", "", names(allData)) ## remove ()
names(allData) <- gsub("-", " ", names(allData)) ## replace - with a space
names(allData) <- gsub("angle", "angle ", names(allData)) ## insert space after angle
names(allData) <- gsub(",", " ", names(allData)) ## replace , with a space
names(allData) <-gsub("BodyBody", "Body", names(allData)) ## remove double "Body"

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

newData <- group_by(allData, subject, activity)
tidyData <- summarise_each(newData, funs(mean))
write.table(tidyData, file = "tidydata.txt", row.names = FALSE, col.names = TRUE, quote = TRUE)