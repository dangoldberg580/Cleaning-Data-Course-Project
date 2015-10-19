# Getting and Cleaning Data

## Introduction

This codebook describes the step by step process for returning a *tidy dataset* from the combined data.frame for the test and train data. To run the run_analysis.R file that processes the data files, place it and the unzipped data files in the same directory and point R to that working directory.

## Data

Data files used in this process include:  
1.  features.txt - contains the names of the 561 measurements that were taken from the Samsung iPhone for the test and train datasets  
2.  features_info.txt - contains a description of how the measurements were derived  
3.  activity_labels.txt - map the six types of activity measured to numbers (1:6)  
4.  subject_test.txt - contain the subject ids for the 2,947 observations in the test dataset  
5.  subject_train.txt - contain the subject ids for the 7,352 observations in the train dataset  
6.  X_test.txt - contains 2,947 observations of 561 measurements  
7.  X_train.txt - contains 7.352 observations of 561 measurements   
8.  y_test.txt - contains 2,947 observations of 1 variable (the activity id #)  
9.  y_train.txt - contains 7.352 observations of 1 variable (the activity id #)  

## R Script process and variables

The script begins by reading in the relevant files into data.frames:  

**Data.Frames**  

1.  x.train  
2.  y.train  
3.  subject.train  
4.  x.test  
5.  y.test  
6.  subject.test  
7.  measurements    

**Variables**  

1.  measurementNames
  *  pulls out the names of the 561 measurements to grep for just the relevant measurement related to means and standard deviations  
2.  StandardDeviationsNeeded
  *  pulls out just the standard deviations that have "std()" in the string and pulls both the vector and value into a dataframe  
3.  MeansNeeded
  *  does the same thing for the relevant means columns  
4.  tmpStandardDeviationNames
  *  creates a character string for the standard deviation columns to use  
5.  tmpMeanNames
  *  does the same thing for the relevant means columns  
6.  SetColumnNames
  *  pastes all of the correct column names to one string  

Now the code merges the subjects, activity and measurements for each dataset (**testDF**, **trainDF**) then sets the column names and stacks the two data.frames on top of each other with Rbind to create one data.frame (**totalDF**).    

The script renames the activities in the dataset to have descriptive labels by using gsub and replacing the activity numbers with names  

*tmp <- gsub("1", "Walking",  totalDF$Activity), etc.*  

Then it renames the mean() and std() labels in the meaurement labels to be more meaningful - again using gsub.  

*tmpColName <- gsub("\\-std\\(\\)\\-", ".StandardDeviation.", SetColumnNames), etc.*  


In order to get the average of each of the measurements by subject, within each activity, the codes subsets the data from totalDF, into six data.frames, one corresponding to each activity.  

*walking<- subset(totalDF, totalDF$Activity == "Walking")*  

It then uses the aggregate function to get the mean of each variable (ignoring the warnings to the character column)

*walking <- aggregate(walking, list(walking$Subject), mean)*  

then deletes the grouping column and resets the Activity column name.  

A new data.frame is built using Rbind to take each Activity data.frame and stack them together. The resulting Average data.frame is written to a table "AverageOfVariables.txt" and uploaded to GitHub.