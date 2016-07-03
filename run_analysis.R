############## 1: Merge the training and the test sets to create one data set

# Check for file data.zip in working directory
# If doesn't exist, download it
if(!file.exists("data.zip")){
        zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(zipUrl, "data.zip")
}

# Check for directory "unzippedData" in working directory
# If doesn't exist, create it
if(!file.exists("unzippedData")){
        dir.create("unzippedData")
}

# Unzip data.zip in previously created directory
unzip(zipfile="data.zip",exdir="./unzippedData")

########## Create dataframe with train observations 
# First: identify needed files
trainSubjects <- "./unzippedData/UCI HAR Dataset/train/subject_train.txt"
trainActivities <- "./unzippedData/UCI HAR Dataset/train/y_train.txt"
trainObservations <- "./unzippedData/UCI HAR Dataset/train/X_train.txt"

# Second: combine files in a vector
dataTrain <- as.vector(cbind(trainSubjects,trainActivities,trainObservations))

# Third: read all files' contents   
dataTrain <- lapply(dataTrain, FUN=read.table, header=FALSE)

# Fourth: combine previously readed content 
dataTrain <- do.call("cbind", dataTrain)

######## Create dataframe with test observations 
# First: identify needed files
testSubjects <- "./unzippedData/UCI HAR Dataset/test/subject_test.txt"
testActivities <- "./unzippedData/UCI HAR Dataset/test/y_test.txt"
testObservations <- "./unzippedData/UCI HAR Dataset/test/X_test.txt"

# Second: combine files in a vector
datatest <- as.vector(cbind(testSubjects,testActivities,testObservations))

# Third: read all files' contents   
datatest <- lapply(datatest, FUN=read.table, header=FALSE)

# Fourth: combine previously readed content 
datatest <- do.call("cbind", datatest)

######## Combine dataTrain with datatest to create final data
data <- rbind(dataTrain,datatest)

colnames(data)[1] <- "subject"
colnames(data)[2] <- "activityId"

############## 2: Use descriptive activity names to name the activities in the data set
# Define activity (names) file
activities <- "./unzippedData/UCI HAR Dataset/activity_labels.txt"

# and read it
activities <- read.table(activities)

# change activities colNames
colnames(activities) <- c("activityId","activityName")

# and merge both dataframes by activityId
data <- merge(activities, data, by= "activityId")

############## 3: Appropriately label the data set with descriptive variable names.
# Define activity (names) file
features <- "./unzippedData/UCI HAR Dataset/features.txt"

# and read it
dataColNames <- read.table(features)

# create vector with descriptive colNames
colNames <- as.vector(dataColNames$V2, mode = "any")

# change colNames (after 4th col) with descriptive colNames
colnames(data)[4:ncol(data)] <- colNames


############## 4: Extract only the measurements on the mean and standard deviation for each measurement.
# get columns with colName mean() or std()
colsKeep <- grep("*mean\\(\\)*|*std\\(\\)*", colnames(data))

# create subset of data, getting only the columns found previously and activityName + subject
data <- subset(data, select = c(2:3,colsKeep))

############## 5: From the data set in step 4, creates a second, independent tidy data set with the average of 
############## each variable for each activity and each subject
dataAggregated <- aggregate(data[,3:ncol(data)], by=list(data$activityName,data$subject), FUN=mean)
colnames(dataAggregated)[1:2] <- c("activity", "subject")

## Create final tidy data
write.csv(data, "data.csv", row.names = F)
write.csv(dataAggregated, "dataAggregated.csv", row.names = F)
