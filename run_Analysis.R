### gd014-proj
### Getting and Clearning Data Course Project

### scott hill

### Abstract:
### Processing the human activity recognition using smartphones data set
### https://d396https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Goal is to
###    1. Merges the training and the test sets to create one data set.
###    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
###    3. Uses descriptive activity names to name the activities in the data set
###    4. Appropriately labels the data set with descriptive variable names. 
###    5. From the data set in step 4, creates a second, independent tidy data set with the average
###       of each variable for each activity and each subject.

### See README.md file for detailed theory of operation and code book describing variables.

### Setup
###require(data.table)
require(tidyr)
require(dplyr)

### Useful constants and strings
dirpref <- "UCI HAR Dataset/"

### pnosep - helper function to paste with no separator
pnosep <- function(...) {
    paste(..., sep="")
}

### merge_onemode - function to put either train or test files together
### The parameter indicates which one.  Can do this since the files stored in parallel structures
merge_onemode <- function(mode) {
    print(pnosep("Merging ", mode, " files"))
    subdir <- pnosep(mode,"/")

    ## read activity labels into table, give it a good label
    ## Yes, I could have done this once outside of this function but chose for this small thing
    ## not to bother. 
    al <- read.table(pnosep(dirpref, "activity_labels.txt"))
    colnames(al) <- c("activity_code", "Activity")
    
    ## read in subject id into table, label it well
    st <- read.table(pnosep(dirpref, subdir, "subject_", mode, ".txt"))
    colnames(st) <- "Subject"
    ## add column to indicate mode - this is not necessary for this project so comment out
    ## but I would not want to lose this information if i was using this data for real
    ##st <- cbind(st, mode)
    ##colnames(st) <- c("Subject", "mode")
    
    ## read in activity data into table, label it well
    yt <- read.table(pnosep(dirpref, subdir, "y_", mode, ".txt"))
    colnames(yt) <- "activity_code"
    
    ## combine those using cbind
    styt <- cbind(st,yt)

    ## make this a data table, then bring in activity labels from the al table                      
    ## use innter_join from dplyr package
    ## then remove the redundent activity_code
    styt1 <- inner_join(styt, al, by="activity_code")
    styt2 <- select(styt1, -activity_code)

    ## read in experimental data, rename vars to train_V1, ...
    xt <- read.table(pnosep(dirpref, subdir, "X_", mode, ".txt"))
    ## read in feature.txt which have column names for xt table
    ## determine which of those feature have "mean" in the name
    features <- read.table(pnosep(dirpref, "features.txt"), stringsAsFactors=FALSE)
    features.names <- features[,2]
    features.names.mean <- grep("mean|std", features.names, ignore.case=TRUE)    

    ## retain just the selected features from the xt file
    xt1 <- xt[,features.names.mean]
        
    ## use those feature to label the columns in the experimental data
    colnames(xt1) <- features.names[features.names.mean]

    ## bind them all together
    cbind(styt2, xt1)
    
}



har <- function() {
    print("Starting human activity recognition data processing")

    train <- merge_onemode("train")
    test <- merge_onemode("test")

    ## Now combine train and test rows using rbind
    har_processed <<- rbind(train, test)

    ## Now group by Subject and Activity and compute mean for each group
    har_means <<- har_processed %>%
        group_by(Subject, Activity) %>%
        summarise_each(funs(mean))

}







