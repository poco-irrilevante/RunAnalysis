## Create more meaningful column names
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
