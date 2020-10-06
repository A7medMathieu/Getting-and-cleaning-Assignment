## preparing libraries 
library(dplyr)
##download zip file
filename<-"data.zip"
if(!file.exists(filename)){
  fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(
    fileURL,
    filename,
    method = "curl"
  )
  
  ##unzip file 
  unzip(filename)
} 

## assigning all data frames 
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## merges the training and the test to create one data set
x_data<-rbind(x_train,x_test)
y_data<-rbind(y_train,y_test)
subject<-rbind(subject_train,subject_test)
mergedData<-cbind(subject,x_data,y_data)
##mergedData just to if you wanna to test

cleanData<-mergedData%>% select(subject,code,contains("mean"),contains("std"))
## use activities names to name the activite in data set
cleanData$code<-activities[cleanData$code,2]
##add descriptive variable names
names(cleanData)[2]='activity'
names(cleanData)<-gsub("Acc","Accelerometer",names(cleanData))
names(cleanData)<-gsub("Gyro","Gyroscope",names(cleanData))
names(cleanData)<-gsub("BodyBody","Body",names(cleanData))
names(cleanData)<-gsub("Mag", "Magnitude", names(cleanData))
names(cleanData)<-gsub("^t", "time", names(cleanData))
names(cleanData)<-gsub("^f", "Frequency", names(cleanData))
names(cleanData)<-gsub("tBody", "timeBody", names(cleanData))
names(cleanData)<-gsub("-mean()", "Mean", names(cleanData))
names(cleanData)<-gsub("-std()", "STD", names(cleanData))
names(cleanData)<-gsub("-freq()", "Frequency", names(cleanData))
names(cleanData)<-gsub("angle", "Angle", names(cleanData))
names(cleanData)<-gsub("gravity", "Gravity", names(cleanData))

## creates a second, independent tidy data set with the average of each variable for each activity and each subject
FinalData <- cleanData %>%group_by(subject, activity) %>%summarise_all(funs(mean))
##check names
names(FinalData)
##Write data into final file as tidy data set 
write.table(FinalData, "FinalData.txt", row.name=FALSE)
FinalData