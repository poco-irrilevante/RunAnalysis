RunAnalysis
=========

This project is part of the Coursera course [Getting and Cleaning Data].

The goal for this project is to prepare a tidy data set from the original data that can be used for later analysis. The process contains 3 steps

  - Manual unzipping of the data
  - Reading and consolidating the train and test data using R
  - Saving the data

One of the most exciting areas in all of data science right now is wearable computing - see for example  [WearableComputerRevolution] . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at [SmartphoneActivity] the site where the data was obtained: 

> Step 1 Getting the data and unzipping.

The [Dataset] is available as a "zip" compressed file. It can be decompressed with any of the common tools for example [7-zip]. R has tools to unzip data and work with it. I had some problems with the proper parameters and due to time crunch to finish timely I deviated to the "manual" approach for now.

Unzip the [Dataset]. It creates a folder structure "UCI HAR Dataset" containing two sub folders; "train" and "test". We will use the root folder as the working directory for the script.

> Step 2 Reading and consolidating the train and test data using R

The run_analysis.R script takes care of this step. I will explain the script section by section.
First load the LaF package to work with fixed width files

```
install.packages("LaF") # for processing fixed width files
library(LaF)

```
As mentioned above I use the "UCI HAR Dataset folder as the working directory. 

```
setwd("~/Courses/R-GettIngAndCleaningData/Data/UCI HAR Dataset")

```

The next step is to read in the labels, this may sound weird, normally one would start with the data, and add the labels at a later stages. The labels are stored in the file "features.txt" in the root folder and use a blank as a speparator. As we want the labels as string we must set the stringsAsFactors parameter to false. The columnCount variable keeps track on the number of columns.


```
cnames <- read.table("./features.txt",sep=' ', stringsAsFactors=FALSE)[,2]
columnCount <- length(cnames)
columnCount

[1] 561

str(cnames)

 chr [1:561] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" "tBodyAcc-std()-Y" ...
```

Now that we have the labels and the number of columns (561) we can read the actual data. I will again store the total characters in a line into a variable "lineWidth". We will use the readLines method to read the lines. 

```
lineWidth <- nchar(readLines("./train/X_train.txt")[1])
lineWidth

[1] 8976
```

We can now calculate the "width" of each column. (All columns have in this case the same size). 

```
columnWidth <- lineWidth / columnCount
columnWidth

[1] 16
```
We have now sufficient information to read the information into a dataset using the "laf_open_fwf" command. One fragment needs an additional explanation. we use the "rep" command to create a vector with 561 times column widths or column types

```
rep("double", columnCount)
rep(columnWidth,columnCount)
```

Let's create a connection to the data and store give it the name "file"

```
file <- laf_open_fwf(filename = "./train/X_train.txt",
                      column_types=rep("double", columnCount),
                      column_names=cnames,
                      column_widths=rep(columnWidth,columnCount))
```
As the request was only to provide the means and standard deviations, contained in the first six columns we can subset the data to these columns and name the data frame "train".

```
train <- file[,1:6]
```

We are now able to look at the structure of the data frame, using the "str" command.

```
str(train)

'data.frame':	7352 obs. of  6 variables:
 $ tBodyAcc.mean...X: num  0.289 0.278 0.28 0.279 0.277 ...
 $ tBodyAcc.mean...Y: num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
 $ tBodyAcc.mean...Z: num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
 $ tBodyAcc.std...X : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
 $ tBodyAcc.std...Y : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
 $ tBodyAcc.std...Z : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
```

As a small safety I add a variable to count the number of rows within the dataset to ensure I do not miss entries when combining or consolidating data. I name it "trainRowcount".

```
trainrowCount <- nrow(train)
```

The previous procedure is also required for the "test" data. I will not explain the individual steps.
```
file2 <- laf_open_fwf(filename = "./test/X_test.txt",
                     column_types=rep("double", columnCount),
                     column_names=cnames,
                     column_widths=rep(columnWidth,columnCount))
## again only the means and stds
test <- file2[,1:6]
str(test)
testrowCount <- nrow(test)
```
The next step is to combine both data frames into a single data frame called "tidy", using the rbind command. We also will rename the column names to shorter ones. 

```
tidy <- rbind(train,test)
colnames(tidy) = c("mean.X", "mean.Y", "mean.Z","std.X", "std.Y", "std.Z")
```

And check if the total rows match the total count for the train and test set. 

```
nrow(tidy)==trainrowCount+testrowCount
```

> Saving the data

We use the write.csv command to save the data into the working directory for further analysis.

```
write.csv(tidy, "tidy.csv", row.names=FALSE)
```

Version
----

0.1 Initial commit


[SmartphoneActivity]:http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
[WearableComputerRevolution]:http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/
[Getting and Cleaning Data]:https://class.coursera.org/getdata-002
[Dataset]:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
[7-zip]:http://www.7-zip.org


    