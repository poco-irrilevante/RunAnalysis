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