source("Functions.R")

### Files, URLs, etc
project.data.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data.folder <- "./data"
project.data.zip.file  <- paste(data.folder,"dataset.zip",sep="/")
raw.data.folder <- paste(data.folder,"rawdata",sep="/")
unzip.data.folder <- paste(data.folder,"UCI HAR Dataset",sep="/")

raw.data.filenames <- getFileNames(raw.data.folder)

### Check if the data is already available. Get the data otherwise
if (!areFilesAvailable(raw.data.filenames)) { 
  print("GETTING THE RAW DATA")
  ## Download the file if not available in local folder
  if (!file.exists(project.data.zip.file)) {
    if (!file.exists(data.folder)) {
      dir.create(data.folder)
    }
    download.file(project.data.url, project.data.zip.file,method="curl")
  }

  ## Do not extract Inertial signals
  filenames <- unzip(project.data.zip.file,list=T)$Name
  filenames <- filenames[!grepl("Inertial Signals", filenames)]
  
  
  unzip(project.data.zip.file,files=filenames,exdir=data.folder)
  if(file.exists(raw.data.folder)) {
    unlink(raw.data.folder,recursive=T)
  }
  file.rename(from=unzip.data.folder,raw.data.folder)
}

print("RAW DATA READY - Starting cleaning up process")
print("Merging raw data")
merged.raw.data <- mergeData(raw.data.folder)
