README
======

This document describes how the **run_analysis.R** script works. 
In particular, it depicts the following
tasks carried out by the script:

1. Getting the data
2. Merging the data
3. Generating the tidy full dataset
4. Generating the summarized tidy dataset

Getting the data
----------------

In this step, the scripts checks whether or not the raw data is already available in the **data/rawdata** folder. The script checks for the existence of the following files:

* *README.txt* - the file that describes the data
* *activity_labels.txt* 
* *features_info.txt*
* *features.txt*
* *train/*
  * *subject_train.txt*
  * *y_train.txt*
  * *X_train.txt*
* *test/*
  * *subject_test.txt*
  * *y_test.txt*
  * *X_test.txt*

To carry out this check, the script uses some functions defined in **Functions.R**. If any of the files is not available, it checks if the  zip file containing the data set is available in **data**, otherwise it downloads it from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. The above mentioned files are extracted to the **data/rawdata** folder.

Merging the data
----------------

In the second step, the script merges reads the files in the **rawdata** folder and merges their content, to which end it uses the **mergeData** function in **Functions.R**. This operation entails
loading and binding (*cbind*) the data of each data set (data is joined using *do.call(rbind,...)*).

Generating the tidy full dataset
--------------------------------

In this step, the columns containing mean and standard deviations are filtered. The columns averaging the measures taken are filtered out. Therefore, ontly the values for the following colums are kept:
* timeBodyAcc-mean()-X
* timeBodyAcc-mean()-Y
* timeBodyAcc-mean()-Z
* timeBodyAcc-std()-X
* timeBodyAcc-std()-Y
* timeBodyAcc-std()-Z
* timeGravAcc-mean()-X
* timeGravAcc-mean()-Y
* timeGravAcc-mean()-Z
* timeGravAcc-std()-X
* timeGravAcc-std()-Y
* timeGravAcc-std()-Z
* timeBodyAccJerk-mean()-X
* timeBodyAccJerk-mean()-Y
* timeBodyAccJerk-mean()-Z
* timeBodyAccJerk-std()-X
* timeBodyAccJerk-std()-Y
* timeBodyAccJerk-std()-Z
* timeBodyGyro-mean()-X
* timeBodyGyro-mean()-Y
* timeBodyGyro-mean()-Z
* timeBodyGyro-std()-X
* timeBodyGyro-std()-Y
* timeBodyGyro-std()-Z
* timeBodyGyroJerk-mean()-X
* timeBodyGyroJerk-mean()-Y
* timeBodyGyroJerk-mean()-Z
* timeBodyGyroJerk-std()-X
* timeBodyGyroJerk-std()-Y
* timeBodyGyroJerk-std()-Z
* freqBodyAcc-mean()-X
* freqBodyAcc-mean()-Y
* freqBodyAcc-mean()-Z
* freqBodyAcc-std()-X
* freqBodyAcc-std()-Y
* freqBodyAcc-std()-Z
* freqBodyAccJerk-mean()-X
* freqBodyAccJerk-mean()-Y
* freqBodyAccJerk-mean()-Z
* freqBodyAccJerk-std()-X
* freqBodyAccJerk-std()-Y
* freqBodyAccJerk-std()-Z
* freqBodyGyro-mean()-X
* freqBodyGyro-mean()-Y
* freqBodyGyro-mean()-Z
* freqBodyGyro-std()-X
* freqBodyGyro-std()-Y
* freqBodyGyro-std()-Z

As can be observed, each colum describes many aspects (source,axis, etc.). Tidy the dataset, firts it is melt and new columns are created following the advices in http://vita.had.co.nz/papers/tidy-data-pres.pdf. The final dataset contains to value columns (mean and std) and other columns that describe the axis, the source of the measure, etc. (see **code book**). 

Generating the summarized tidy dataset
--------------------------------------

The average of the mean and std are computed using *ddply*.

