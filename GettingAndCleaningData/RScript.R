
project.data.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

### Check if the data is already available
data.folder <- "./data"
project.data.zip.file  <- paste(data.folder,"dataset.zip",sep="/")
raw.data.folder <- paste(data.folder,"rawdata",sep="/")
unzip.data.folder <- paste(data.folder,"UCI HAR Dataset",sep="/")


## Download the file if not available in local folder
if (!file.exists(project.data.zip.file)) {
  if (!file.exists(data.folder)) {
    dir.create(data.folder)
  }
  download.file(project.data.url, project.data.zip.file,method="curl")
}

filenames <- unzip(project.data.zip.file,list=T)
filenames <- filenames[grepl("test|train",filenames$Name), "Name"]

unzip(project.data.zip.file,files=filenames,exdir=data.folder)
file.rename(from=unzip.data.folder,raw.data.folder)