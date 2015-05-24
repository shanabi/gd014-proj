# gd014-proj
Getting and Cleaning Data Course Project

Processing the human activity recognition using UCI HAR smartphones data set

## Abstract
Using smart phone activity data found here:
https://d396https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
This is referred to as the UCI HAR DATA in this document and the
codebook document which is CODEBOOK.txt.  Vars used in the UCI HAR
DATA are those listed their features.txt file which have the word
"mean" or "std" in the name, ignoring the case of the word.

Assignment

1. Merge the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation

3. for each measurement.

4. Uses descriptive activity names to name the activities in the data
  set

5. Appropriately labels the data set with descriptive variable names.

6. From the data set in step 4, creates a second, independent tidy data
  set with the average of each variable for each activity and each
  subject.  This is called har_means

## Operation and HOWTO

In R, setup so the unzipped "UCI HAR Dataset" is in the working
directory.  Under folder "UCI HAR Dataset" must be the "features.txt"
file, also the "test" and "train" subfolders.  In the "test" subfolder
must be the "subject_train.txt", "X_train.txt", and "y_train.txt"
files.  In the "test" subfolder must be the "subject_test.txt",
"X_test.txt", and "y_test.txt" files.

Source the main function "run_Analysis.R".  Then run the main "har"
function with "somevar <- har".  That function will use the merge_onemode
function to first merge all the "train" files, then will use the
merge_onemode function to merge all the "test" files.  It will then
row bind the results of those two processed and place the result in
har_processed.  For convenience that is placed in the global
environment so can be inspected (ex: har_processes[1:5,1:5]).  Then
the har_processed table is grouped by subject and activity and means
are computed for all other variables, the result of this is placed in
har_means, also at the global environment for convenience.  This is
the last operation of the har function so is return value, so if you
invoked as ttt <- har(), then the result will be in variable ttt
("ttt" is an example name, any other is also ok!).  See the
CODEBOOK.md for specifics of the har_means data.  

## Details of function merge_onemode

The function merge_onemode was used to process separately the train
and test datasets in the UCI HAR Data because they used parallel
structures for all variables and file names.  Thus it was natural 
to abstract
the similarity into a function, using a parameter to specify the
difference.

In merge_onemode, the steps taken are as follows:

1. Read activity name table into a table, giving column good label.

2. Read subject id into table, giving column a good label.  

3. Read activity data into table, lable it as well.

4. Now combine the subject and activity tables using cbind.

5. Now join the activity name table to that table we just made so have
names for activites instead of just codes.  We use inner_join here
since all activites are represented.  We can now drop the
activity code column.  This new table is styt2.

6. Now read in the experimental results into xt table.

7. We read in all the feature names.  Then we use grep to get index
values of just those with "mean" or "std" in name (irrespective of
case),  this is placed in features.names.mean.  

8.  Now we just the features.names.mean to select just the xt columns
of interest, call this new table xt1.  We assign the xt1 columnts from
those features.names which are true for index values
features.name.mean. 

9.  Now we merely have to do a cbind of styt2 (which has "Subject" and
"Activity") with xt1 (which has the feature values). 























