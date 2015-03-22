library(plyr);
library(data.table)

local_path <- as.character(getwd())
path_rf <- file.path(local_path, "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)


#Read the Activity files
  dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
  dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

#Read the Subject files
  dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
  dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

#Read Fearures files
  dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
  dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

#combine training and test data frames
  dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
  dataActivity<- rbind(dataActivityTrain, dataActivityTest)
  dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

#set variable names 
  names(dataSubject)<-c("subject")
  names(dataActivity)<- c("activity")
  dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
  names(dataFeatures)<- dataFeaturesNames$V2

#Combine data frames into Data
  dataCombine <- cbind(dataSubject, dataActivity)
  Data <- cbind(dataFeatures, dataCombine)
#Measurements on the mean and standard deviation 
  subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
  selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
  Data<-subset(Data,select=selectedNames)

#extract meaningful activity names from activity_labels.txt
  activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

#assign meaningful names to the dataset
  names(Data)<-gsub("^t", "time", names(Data))
  names(Data)<-gsub("^f", "frequency", names(Data))
  names(Data)<-gsub("Acc", "Accelerometer", names(Data))
  names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
  names(Data)<-gsub("Mag", "Magnitude", names(Data))
  names(Data)<-gsub("BodyBody", "Body", names(Data))

#Aggregate meaningful tidy data
  DataTidy<-aggregate(. ~subject + activity, Data, mean)
  DataTidy<-DataTidy[order(DataTidy$subject,DataTidy$activity),]
#write out the file
  write.table(DataTidy, file = "tidydata.txt",row.name=FALSE)


