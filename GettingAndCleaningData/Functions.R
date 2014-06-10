## Required libraries
library(data.table)
library(LaF)
library(reshape2)
library(plyr)
library(stringr)

### returns TRUE if the files exist, FALSE otherwise
areFilesAvailable <- function(files) {
  for (file in files) {
    if (!file.exists(file)) {
      print(paste(file,"Not found"))
      return(FALSE)
    }
  }
  return(TRUE)
}

### returns the vector with the names of the raw data files
getFileNames <- function(folder)  {
  fileNames <- c(getSetFileNames("train"), getSetFileNames("test"))
  
  otherFiles <- c("README.txt", "features_info.txt","features.txt","activity_labels.txt")
  fileNames <- paste(folder,c(otherFiles,fileNames),sep="/")
  
  return(fileNames)
}

## Return the file names for a particular set (folder)
getSetFileNames <- function(set) {
  filesuffix <- paste(set,"txt",sep=".")
 
  names <- paste(c("subject","X","y"),filesuffix,sep="_")
  names <- paste(set,names,sep="/")
  return(names)
}

## Returns the merged data for a particular set
mergeSet <- function(folder,set) {
  files <- as.character(sapply(c("subject_","X_","y_"), function(pref) paste(folder,set,paste0(pref,set,".txt"),sep="/")))
  df <- read.csv(files[1],header=F)
  df <- cbind(df,read.csv(files[3],header=F))
  x_data <- laf_open_fwf(files[2],column_widths=rep(16,561),column_types=rep("double",561))
  df <- cbind(df,x_data[,])
  return(df)
}

## Returns the merged dataset with clean column names and normalized activity
mergeData <- function(folder,sets=c("train","test")) {
  data.sets.list <- lapply(sets,function(set) mergeSet(folder,set))
  dataset <- do.call("rbind",data.sets.list)
  
  ## Clean dataset names
  names(dataset) <- getColumnNames(folder)
  
  ## Normalize activity
  dataset$activity <- factor(dataset$activity,labels=getActivityLevels(folder))
  return(dataset)
}

## Returns the activity levels
getActivityLevels <- function(folder) {
  activityLabelsFile <- paste(folder,"activity_labels.txt",sep="/")
  activities <- read.csv(activityLabelsFile,header=F,sep=" ", stringsAsFactors=F)

  activityLabels <- tolower(activities[,2])
  return(activityLabels)
}

## Returns the clean columnnames 
getColumnNames <- function(folder) {
  featuresFile <- paste(folder,"features.txt",sep="/")
  features <- read.csv(featuresFile, header=F,sep=" ", stringsAsFactors=F)

  featureNames <-   features[,2]## tolower(features[,2])
  
  ## Clean featureNames
  featureNames <- gsub("^f","freq",featureNames)
  featureNames <- gsub("^t","time",featureNames)
  featureNames <- gsub("Gravity","Grav",featureNames)
  
  columnNames <- c("subject", "activity", featureNames)
  return(columnNames)
}

## Returns the tidy data
getTidyData  <- function(rawDataSet)   {
  raw.data <- rawDataSet[,getMeanStdColumns(names(rawDataSet))]
  ## Add ID to later distinguish rows
  raw.data$id <- 1:nrow(raw.data)
  tidy <- reshape2::melt(raw.data, id.vars=c("id","subject","activity"),na.rm=F)
  
  ## Extraxt source
  tidy$domain <- gsub("freq","frequency",str_sub(tidy$variable,1,4))
  tidy$domain <- factor(tidy$domain,levels=c("time","frequency"))
  tidy$variable <- str_sub(tidy$variable,5)
  ## Extract source
  tidy$source <- tolower(str_sub(tidy$variable,1,4))
  tidy$source <- sub("grav*","gravity",tidy$source)
  tidy$source <- factor(tidy$source)
  tidy$variable <- str_sub(tidy$variable,5)
  ## Extract tool (accelerometer or gyro)
  tidy$tool  <- str_sub(tidy$variable,1,4)
  tidy$tool <- gsub("Acc.*","accelerometer",tidy$tool)
  tidy$tool <- gsub("Gyro.*","gyroscope",tidy$tool)
  tidy$tool <- factor(tidy$tool)
  tidy$variable <- sub("(Acc|Gyro)-?","",tidy$variable)
  ## Jerk
  tidy$jerk <- grepl("^Jerk",tidy$variable)
  tidy$variable <- sub("^Jerk-","",tidy$variable)
  ### measure
  tidy$measure <- str_sub(tidy$variable,1,4)
  tidy$measure <- factor(sub("\\(","",tidy$measure))
  ## Extract axis
  tidy$axis <- factor(sub("^.*?-","",tidy$variable))
  tidy$variable <- NULL
  ## Rearrange columns
  tidy <- tidy[,c("id","subject","activity",	"domain",	"source",	"tool","axis","jerk",	"measure","value")]
  

  ## Make measure a variable
  tidy <- reshape2::dcast(tidy, ... ~ measure,value.var="value")
  tidy$id <- NULL
 
  return(tidy)
}

## Returns the columns to be included in the  tidy data
getMeanStdColumns <- function(cols)  {
  selectedColumns <- c("subject","activity")
  mean.std.cols <- cols[which(grepl("mean\\(\\)-|std\\(\\)-",cols))]
  selectedColumns <- c(selectedColumns,mean.std.cols)
  return(selectedColumns)
}

getSummarizedTidyData <- function(ds) {
  tidy <-  ddply(ds, .(subject,activity,domain,source,tool,axis,jerk),numcolwise(mean))
  return(tidy)
}
