## Read in data
x.train <- read.table("X_train.txt", header=FALSE)                              ## 7352 obs. of  561 variable   TRAINING SET
y.train <- read.csv("y_train.txt", header=FALSE, sep=" ")                       ## 7352 obs. of  1 variable     TRAINING LABELS (1-6)
subject.train <- read.csv("subject_train.txt", header=FALSE, sep=" ")           ## 7352 obs. of  1 variable     SUBJECT # (1-30)

x.test <- read.table("X_test.txt", header=FALSE)                                ## 2947 obs. of  561 variables  TEST SET
y.test <- read.csv("y_test.txt", header=FALSE, sep=" ")                         ## 2947 obs. of  1 variable     TEST LABELS (1-6)
subject.test <- read.csv("subject_test.txt", header=FALSE, sep=" ")             ## 2947 obs. of  1 variable     SUBJECT # (1-30)

measurements <- read.csv("features.txt", header=FALSE, sep=" ")                 ## 561 measurement names

## Grep the features.txt file to get the vectors and names of the standard deviations and means into data frames
measurementNames <- as.character(measurements[ , 2])

StandardDeviationsNeeded <- data.frame(ColumnNumbers=c(grep("\\bstd()\\b", measurementNames, value=FALSE)))
StandardDeviationsNeeded <- cbind(StandardDeviationsNeeded, ColumnNames=grep("\\bstd()\\b", measurementNames, value=TRUE))

MeansNeeded <- data.frame(ColumnNumbers=c(grep("\\bmean()\\b", measurementNames, value=FALSE)))
MeansNeeded <- cbind(MeansNeeded, ColumnNames=grep("\\bmean()\\b", measurementNames, value=TRUE))

## Pull out names to use for the column names on the data frames
tmpMeanNames <- as.character(MeansNeeded$ColumnNames)
tmpStandardDeviationNames <- as.character(StandardDeviationsNeeded$ColumnNames)
SetColumnNames <- c("Subject", "Activity", tmpStandardDeviationNames, tmpMeanNames)

## Merge the subjects, activity and measurements for each dataset then set the column names
testDF <- data.frame(Subject=subject.test$V1, Activity=y.test$V1, 
                   x.test[ ,StandardDeviationsNeeded$ColumnNumbers],
                   x.test[ ,MeansNeeded$ColumnNumbers])

trainDF <- data.frame(Subject=subject.train$V1, Activity=y.train$V1, 
                   x.train[ ,StandardDeviationsNeeded$ColumnNumbers],
                   x.train[ ,MeansNeeded$ColumnNumbers])

## Add in the variable names to each dataset
colnames(testDF) <- SetColumnNames
colnames(trainDF) <- SetColumnNames

## Merge the test and train datasets
totalDF <- rbind(testDF, trainDF)

## Rename the activities in the dataset to have descriptive labels
tmp <- gsub("1", "Walking",  totalDF$Activity)
tmp <- gsub("2", "WalkingUpstairs", tmp)
tmp <- gsub("3", "WalkingDownstairs", tmp)
tmp <- gsub("4", "Sitting", tmp)
tmp <- gsub("5", "Standing", tmp)
tmp <- gsub("6", "Laying", tmp)
totalDF$Activity <- tmp

## Label the variables in the dataset with descriptive names
tmpColName <- gsub("\\-std\\(\\)\\-", ".StandardDeviation.", SetColumnNames)
tmpColName <- gsub("\\-std\\(\\)", ".StandardDeviation", tmpColName)
tmpColName <- gsub("\\-mean\\(\\)\\-", ".Mean.", tmpColName)
tmpColName <- gsub("\\-mean\\(\\)", ".Mean", tmpColName)

colnames(totalDF) <- tmpColName

## Create a new dataset from the first with the average of each variable for each activity and subject
## Separate activities, then aggregate on Subject - will get warnings for the Activity column
walking<- subset(totalDF, totalDF$Activity == "Walking")
walking <- aggregate(walking, list(walking$Subject), mean)
walking$Activity <- "Walking"
walking <- walking[ , -1]

walkingupstairs<- subset(totalDF, totalDF$Activity == "WalkingUpstairs")
walkingupstairs <- aggregate(walking, list(walking$Subject), mean)
walkingupstairs$Activity <- "WalkingUpstairs"
walkingupstairs <- walkingupstairs[ , -1]
                  
walkingdownstairs<- subset(totalDF, totalDF$Activity == "WalkingDownstairs")
walkingdownstairs <- aggregate(walking, list(walking$Subject), mean)
walkingdownstairs$Activity <- "WalkingDownstairs"
walkingdownstairs <- walkingdownstairs[ , -1]

sitting<- subset(totalDF, totalDF$Activity == "Sitting")
sitting <- aggregate(walking, list(walking$Subject), mean)
sitting$Activity <- "Sitting"
sitting <- sitting[ , -1]

standing<- subset(totalDF, totalDF$Activity == "Standing")
standing <- aggregate(walking, list(walking$Subject), mean)
standing$Activity <- "Standing"
standing <- standing[ , -1]

laying<- subset(totalDF, totalDF$Activity == "Laying")
laying <- aggregate(walking, list(walking$Subject), mean)
laying$Activity <- "Laying"
laying <- laying[ , -1]

## Build data frame and write to txt file
Average <- walking[]
Average <- rbind(Average, walkingupstairs[])
Average <- rbind(Average, walkingdownstairs[])
Average <- rbind(Average, sitting[])
Average <- rbind(Average, standing[])
Average <- rbind(Average, laying[])

write.table(Average, "AverageOfVariables.txt", sep=" ", row.name=FALSE)

