## getRawData()
library(data.table)
library(LaF)

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

getSetFileNames <- function(set) {
  filesuffix <- paste(set,"txt",sep=".")
 
  names <- paste(c("subject","X","y"),filesuffix,sep="_")
  names <- paste(set,names,sep="/")
  return(names)
}

mergeSet <- function(folder,set) {
  files <- as.character(sapply(c("subject_","X_","y_"), function(pref) paste(folder,set,paste0(pref,set,".txt"),sep="/")))
  df <- read.csv(files[1],header=F)
  df <- cbind(df,read.csv(files[3],header=F))
  x_data <- laf_open_fwf(files[2],column_widths=rep(16,561),column_types=rep("double",561))
  df <- cbind(df,x_data[,])
  return(df)
}

mergeData <- function(folder,sets=c("train","test")) {
  data.sets.list <- lapply(sets,function(set) mergeSet(folder,set))
  dataset <- do.call("rbind",data.sets.list)
  return(dataset)
}