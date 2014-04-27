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

# fix column namings 
colnames(consolidated) <- renderColumnName(colnames(consolidated))

#Write the tidy data frame to disk
write.csv(consolidated, "tidy.csv", row.names=FALSE)
