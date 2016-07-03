## Motivation:
One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.

## Data & Variables explanation:
From an original **raw data** consisting in train and test observations, it was asked to generate **tidy data** for future analysis. This tidy data (data.csv) has the following structure:

- **10299 observations** of different measurements taken from 30 different subjects during 6 different activities
- The **list of variables** used in data.csv are
  - **ActivityName**: Type of activity while the measurement took place. It can be one of:
    - WALKING            
    - WALKING_UPSTAIRS   
    - WALKING_DOWNSTAIRS 
    - SITTING            
    - STANDING           
    - LAYING
  - **Subject**: numeric value [1,30] identifying the subject from whom the measurement comes from
  - **66 variables** corresponding to the measurements of different **sensor signals**. Only the meassurements corresponding to **mean and standard deviation** were considerated. These variables are:
    -  [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"          
 [3] "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
 [5] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
 [7] "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
 [9] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
[11] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
[13] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"      
[15] "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"       
[17] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
[19] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
[21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"          
[23] "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
[25] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"     
[27] "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
[29] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
[31] "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
[33] "tGravityAccMag-mean()"       "tGravityAccMag-std()"       
[35] "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
[37] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"         
[39] "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
[41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
[43] "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"           
[45] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"           
[47] "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
[49] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
[51] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
[53] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
[55] "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"          
[57] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"          
[59] "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
[61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"  
[63] "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
[65] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()"

After creating the unified tidy data, it was asked to make an **independent tidy data** of the previous one, where every of the previous 66 sensor variables were **aggregated by subject and activity type**. The aggregation function was the mean of the observations for every group of activity-subject. The result (dataAggregated.csv) is a data frame with the same structure of the previous data, but with only **180 observations** (30 Subjects * 6 activities).

## Work performed to clean up the data:

- Check for file data.zip in working directory
  - If doesn't exist, download it
```
if(!file.exists("data.zip")){
        zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(zipUrl, "data.zip")
}
```

- Check for directory "unzippedData" in working directory
  - If doesn't exist, create it
```
if(!file.exists("unzippedData")){
        dir.create("unzippedData")
}
```

- Unzip data.zip in previously created directory
```
unzip(zipfile="data.zip",exdir="./unzippedData")
```

- Create dataframe with train observations 
  - First: identify needed files
```
trainSubjects <- "./unzippedData/UCI HAR Dataset/train/subject_train.txt"
trainActivities <- "./unzippedData/UCI HAR Dataset/train/y_train.txt"
trainObservations <- "./unzippedData/UCI HAR Dataset/train/X_train.txt"
```

  - Second: combine files in a vector
```
dataTrain <- as.vector(cbind(trainSubjects,trainActivities,trainObservations))
```
  - Third: read all files' contents  
```
dataTrain <- lapply(dataTrain, FUN=read.table, header=FALSE)
```
  - Fourth: combine previously readed content 
```
dataTrain <- do.call("cbind", dataTrain)
```

- Create dataframe with test observations 
  - First: identify needed files
```
testSubjects <- "./unzippedData/UCI HAR Dataset/test/subject_test.txt"
testActivities <- "./unzippedData/UCI HAR Dataset/test/y_test.txt"
testObservations <- "./unzippedData/UCI HAR Dataset/test/X_test.txt"
```
 - Second: combine files in a vector
```
datatest <- as.vector(cbind(testSubjects,testActivities,testObservations))
```
 - Third: read all files' contents   
```
datatest <- lapply(datatest, FUN=read.table, header=FALSE)
```
- Fourth: combine previously readed content 
```
datatest <- do.call("cbind", datatest)
```
- Combine dataTrain with datatest to create final data
```
data <- rbind(dataTrain,datatest)
colnames(data)[1] <- "subject"
colnames(data)[2] <- "activityId"
```
- Use descriptive activity names to name the activities in the data set
  - Define activity (names) file
```
activities <- "./unzippedData/UCI HAR Dataset/activity_labels.txt"
```
  - and read it
```
activities <- read.table(activities)
```
  - change activities colNames
```
colnames(activities) <- c("activityId","activityName")
```
  - and merge both dataframes by activityId
```
data <- merge(activities, data, by= "activityId")
```
- Appropriately label the data set with descriptive variable names.
  - Define activity (names) file
```
features <- "./unzippedData/UCI HAR Dataset/features.txt"
```
  - and read it
```
dataColNames <- read.table(features)
```
  - create vector with descriptive colNames
```
colNames <- as.vector(dataColNames$V2, mode = "any")
```
  - change colNames (after 4th col) with descriptive colNames
```
colnames(data)[4:ncol(data)] <- colNames
```

- Extract only the measurements on the mean and standard deviation for each measurement.
  - get columns with colName mean() or std()
```
colsKeep <- grep("*mean\\(\\)*|*std\\(\\)*", colnames(data))
```

  - create subset of data, getting only the columns found previously and activityName + subject
```
data <- subset(data, select = c(2:3,colsKeep))
```
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
```
dataAggregated <- aggregate(data[,3:ncol(data)], by=list(data$activityName,data$subject), FUN=mean)
```
- Create final tidy data
```
write.csv(data, "data.csv", row.names = F)
write.csv(dataAggregated, "dataAggregated.csv", row.names = F)
```
