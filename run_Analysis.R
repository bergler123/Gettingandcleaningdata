#read the features
features <- read.table("features.txt")

### load the subjects
subtest <- read.table("test/subject_test.txt")

###read the test data
xtest <- read.table("test/X_test.txt")
names(xtest) <- features[,2]

### read the activity lables
ytest <- read.table("test/Y_test.txt")
# change the heading name from V1 and change the activities to what they are (walking, etc
activities <- read.table("activity_labels.txt")
#this is a great "vlookup" type subset
ytest[,1] = activities[ytest[,1], 2]
names(ytest) <- "Activity"

### Combined the 1) subject IDs and 2) Test Data and 3) Activity
xtest2 <- cbind(subtest,xtest,ytest)

# Repeat the above for the train data 
subtrain <- read.table("train/subject_train.txt")
xtrain <- read.table("train/X_train.txt")
names(xtrain) <- features[,2]
ytrain <- read.table("train/Y_train.txt")
ytrain[,1] = activities[ytrain[,1], 2]
names(ytrain) <- "Activity"
xtrain2 <- cbind(subtrain,xtrain,ytrain)

### Stack the data
stacked <- rbind(xtest2,xtrain2)

## limit the dataset to "mean" and "std"
## we can create a "cols you want" then subset the stacked[,colswewant]
datapoints <- grep("-mean\\(\\)|-std\\(\\)", names(stacked))
datapointsnames <- names(stacked[,datapoints])
datapointsnames <- c(datapointsnames,"Activity","V1")
stackedclean <- stacked[,datapointsnames]
## change column to "subjects"
names(stackedclean)[68] <- "Subjects"
## Final clean dataset
write.table(stackedclean, "tidydataset.txt", sep="\t")

### Create a second tidy data set with just the means of the subjects
tidy = aggregate(stackedclean, by=list(activity=stackedclean$"Activity", subject=stackedclean$"Subjects"), mean)
# Remove the subject and activity column, since a mean of those has no use
tidy[,70] = NULL
tidy[,69] = NULL
write.table(tidy, file = "tidydataset2.txt", sep="\t")
