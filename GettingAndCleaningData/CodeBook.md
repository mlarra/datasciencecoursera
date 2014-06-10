The tidy dataset entails the following variables:
* **subject**: the identifier of the subject for whom the measures were taken. a value in the range [1,3].
* **activity**: The activity the subject was carrying out.  The allowed values are:
  * *walking*
  * *walking_upstairs*
  * *walking_downstairs*
  * *sitting*
  * *standing*
  * *laying*
* **domain**: the domain of the measures. The allowed values are *time* and *frequency*
* **source**: the tool the measure was taken from. The allowed values are *accelerometer* and *gyroscope*
* **axis**: the axis the measure was taken in [X,Y,Z]
* **jerk**: is measure jerk signal? [TRUE, FALSE]
* **mean**: the mean value of the measure
* **std**: the standard deviation of the measure