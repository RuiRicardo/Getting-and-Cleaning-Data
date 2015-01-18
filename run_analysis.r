library(plyr)

# set your working directory
setwd("D:/rricardo/priv/coursera/03 Getting and Cleaning Data/work/assign")

# 1-Merge training and test data.
    
  x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
  x_test  <- read.table("./UCI HAR Dataset/test/X_test.txt")
  x <- rbind(x_train, x_test)
  rm(x_train)
  rm(x_test)

  y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
  y_test  <- read.table("./UCI HAR Dataset/test/y_test.txt")
  y <- rbind(y_train, y_test)
  rm(y_train)
  rm(y_test)

  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
  subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  subject <- rbind(subject_train, subject_test)
  rm(subject_train)
  rm(subject_test)



# 2-Extracts only the measurements on the mean and standard deviation for each measurement. 

  features <- read.table("./UCI HAR Dataset/features.txt")
  
  # get only columns with mean() or std() in their names
  meanStd <- grep("-(mean|std)\\(\\)", features[, 2])
  
  # delete all  columns except the ones in meanStd
  x <- x[, meanStd]
  
  # correct the column names
  names(x) <- features[meanStd, 2]
  rm(meanStd)

# 3-Uses descriptive activity names to name the activities in the data set
  
  activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
  
  y[, 1] <- activity[y[, 1], 2]
  
  names(y) <- "activity"

# 4-Appropriately labels the data set with descriptive variable names. 

  # give column names
  names(subject) <- "subject"
  
  # bind 3 data sets
  data <- cbind(x, y, subject)
  rm(x)
  rm(y)
  rm(subject)

# 5-From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

  # exclude columns activity and subject.
  tidyData <- ddply(data, .(subject, activity), function(x) colMeans(x[, 1:66]))
    
  write.table(tidyData, "tidyData.txt", row.name=FALSE)
