RunAnalysis
=========

This project is part of the Coursera course [Getting and Cleaning Data].

The goal for this project is to prepare a tidy data set from the original data that can be used for later analysis. The process contains 3 steps

  - Manual unzipping of the data
  - Reading and consolidating the train and test data using R
  - Change the column headers
  - Save the data

One of the most exciting areas in all of data science right now is wearable computing - see for example  [WearableComputerRevolution] . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at [SmartphoneActivity] the site where the data was obtained: 

> Step 1 Getting the data and unzipping.

The [Dataset] is available as a "zip" compressed file. It can be decompressed with any of the common tools for example [7-zip]. R has tools to unzip data and work with it. I had some problems with the proper parameters and due to time crunch to finish timely I deviated to the "manual" approach for now.

Unzip the [Dataset]. It creates a folder structure "UCI HAR Dataset" containing two sub folders; "train" and "test". We will use the root folder as the working directory for the script.

> Step 2 Reading and consolidating the train and test data using R

The read_data.R script takes care of this step. As the mechanics for reading the train and test data it makes sense to wrap it into a function.

The script reads the column names from the features file. As the excersise only requires columns that contain a mean or a standard deviation, we filter on both substrings. 

```
read_data <- function(directory, name) {
  cnames <- read.table(paste0(directory,"/features.txt"),sep=' ', stringsAsFactors=FALSE)[,2]
  # filter on only mean & std
  cnames_filtered <- grepl("ean|std",cnames)
                           
  # Read the activity labels
  labels <- read.table(paste0(directory,"/activity_labels.txt"), sep=' ', stringsAsFactors=FALSE)
  colnames(labels) <- c("ActivityCode", "ActivityName")
  
  # Read data, activity code
  data_x <- read.table(paste0(directory,"/",name,"/x_",name,".txt"))
  colnames(data_x) <- cnames
  # filter on only mean & std
  data_filtered <- data_x[,cnames_filtered]
  
  # Read activity
  activity <- read.table(paste0(directory,"/",name,"/y_",name,".txt"))
  colnames(activity) = c("ActivityCode")
  
  # Merge activity and activity labels
  activitiesMerged <- merge(activity,labels)
  
  # read subject 
  subject <- read.table(paste0(directory,"/",name,"/subject_",name,".txt"))
  colnames(subject) <- c("Subject")
  
  # combine the columns and return the data
  data <- cbind(data_filtered, activitiesMerged, subject)
  data
}
```
To beatify the columns to a more meaningful description, we use the [gsub] command. [gsub] replaces all matches of a string, if the parameter is a string vector, returns a string vector of the same length and with the same attributes (after possible coercion to character). Elements of string vectors which are not substituted will be returned unchanged.

```
renderColumnName <- function(column) {
  ## replace '-' to '.'
  v <- gsub("-", ".", column)
  
  ## replace trailing '()'
  v <- gsub("\\(\\)", "", v)
  
  ## fix mean
  v <- gsub("mean", "Mean", v)
  
  ## replace leading 't' to 'Timed'
  v <- gsub("^t", "Timed", v)
  
  ## replace leading 'f' to 'FTT'
  v <- gsub("^f", "FTT", v)
  
  ## extend abbreviations to full name
  v <- gsub("std", "StandardDeviation", v)
  v <- gsub("Acc", "Accelerometer", v)
  v <- gsub("Gyro", "Gyroscope", v)
  v <- gsub("Mag", "Magnitude", v)
  v <- gsub("Jerk", "JerkSignals", v)
  v <- gsub("Freq", "Frequency", v)
  as.character(v)
}
```
Now that we have to tools we can focus on the run_analysis.R script.

```
## R Getting and Cleaning Data Peer Assessment 
source("read_data.R") #sub routine for reading from tran and test set
source("renderColumnName.R") # for rendering column names
## Set the working directory. 
setwd("~/Courses/R-GettIngAndCleaningData/Data/RunAnalysis")
directory <- "~/Courses/R-GettIngAndCleaningData/Data/RunAnalysis/UCI HAR Dataset"


# read the train and testdata 
train <- read_data(directory,"train")
test <- read_data(directory,"test")
consolidated <- rbind(train, test)

```
> Step 3. Fix the column names

This step is no more than a single line added to the run_analysis.R script, calling the renderColumnName function with the consolidated data frame column names.

```
colnames(consolidated) <- renderColumnName(colnames(consolidated))
```

> Saving the data

We use the write.csv command to save the data into the working directory for further analysis.

```
write.csv(consolidated, "tidy.csv", row.names=FALSE)
```

Version
----

0.2 Changed the functionality of the program as the initial version only contained the first 6 columns and means and standard deviations also occur in the other columns.


[SmartphoneActivity]:http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
[WearableComputerRevolution]:http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/
[Getting and Cleaning Data]:https://class.coursera.org/getdata-002
[Dataset]:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
[7-zip]:http://www.7-zip.org
[gsub]:http://www.endmemo.com/program/R/gsub.php


    