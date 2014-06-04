areFilesAvailable <- function(files) {
  for (file in files) {
    if (!file.exists(file))
      return FALSE;
  }
  return TRUE;
}