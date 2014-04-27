## R Getting and Cleaning Data Peer Assessment 
install.packages("LaF") # for processing fixed width files
library(LaF)
## Set the working directory. 
setwd("~/Courses/R-GettIngAndCleaningData/Data/UCI HAR Dataset")

## Read the column data
## the column labels are stored in the file features.txt, separated by a blank
## 
cnames <- read.table("./features.txt",sep=' ', stringsAsFactors=FALSE)[,2]
columnCount <- length(cnames)
str(cnames)

##
## It shows that there are 561 columns
## Read in a text line to determine the line length
lineWidth <- nchar(readLines("./train/X_train.txt")[1])
lineWidth

## each line has 8976 characters, calculate the column width
columnWidth <- lineWidth / columnCount
columnWidth

## read in the data file using the "laf_open_fwf" tool
## it looks like each line has 561 columns, each containing 16 characters
## we build vectors for columntypes and column widths using rep & column count
file <- laf_open_fwf(filename = "./train/X_train.txt",
                      column_types=rep("double", columnCount),
                      column_names=cnames,
                      column_widths=rep(columnWidth,columnCount))
## We are only interested in the x,y,z means and the standard deviations
## contained in column 1 to 6
train <- file[,1:6]
str(train)
trainrowCount <- nrow(train) ## count the rows in the train dataset

## Read in the test data, using the column width and column count 
## calculated before
file2 <- laf_open_fwf(filename = "./test/X_test.txt",
                     column_types=rep("double", columnCount),
                     column_names=cnames,
                     column_widths=rep(columnWidth,columnCount))
## again only the means and stds
test <- file2[,1:6]
str(test)
testrowCount <- nrow(test) ## count the rows in the test dataset
## combine the two data frames into the "tidy" data frame.
tidy <- rbind(train,test)
colnames(tidy) = c("mean.X", "mean.Y", "mean.Z","std.X", "std.Y", "std.Z")
str(tidy)
nrow(tidy)==trainrowCount+testrowCount ## do the combined rows match?

## Write the tidy data frame to disk
write.csv(tidy, "tidy.csv", row.names=FALSE)
