The script can be run as it is.

In the first step, it downloads the data from the website to the ./data folder in your present working directory (If the file exists, the code skips to next step).

The downloaded data is then loaded into R and an initial level merge is performed. This results in three merged dataframes.

combine_x - Combined test and training feature data
combine_y - Combined test and training activity ids
combine_subject - Combined test and training ids of subject who performed the mesuarement

The code then filters/selects only those columns in combined_x feature dataframe that correspond to mean and std dev. It also gets the corresponding activity labels and applies the same to combined_y dataframe that had activity ids.

The datasets are now combined to get the final dataset required and each column is given a descriptive column name. It is organized in the following manner:
[subject_ids, Activity, Features]

Finally, an independent tidy data is created having average of each variable for each activity and each subject. This is written to a text file 'Average_Tidy_Data.txt'.
