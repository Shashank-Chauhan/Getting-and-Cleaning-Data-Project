The first step is to download the data from the following website using the download.file command.
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Once the file is downloaded, the zip file is unzipped and various text files are read into R using read.table command. This results is following 8 tables.

X_test - Table of 561 measured features for testing (2947 X 561)
y_test - Column of activity ids for testing (Each activity is given a numeric id) (2947 X 1)
subject_test - Column of ids for subjects who performed the measurement during testing (Each subject has a numeric id) (2947 X 1)
X_train - Table of 561 measured features for training (7352 X 561)
y_train - Column of activity ids for training (Each activity is given a numeric id) (7352 X 1)
subject_train -  - Column of ids for subjects who performed the measurement during training (Each subject has a numeric id) (7352 X 1)
features - Table providing descriptive name of each feature in features dataset (X_train and X_test) (561 X 2) 
activity - Table providing the descriptive name of each activity corresponding to the activity ids used in y_test and y_train datasets (6 X 2)

The three tables, corrsponding to test and train datasets are first merged individually. This results in following intermediate dataframes. 

combined_x - 10299 X 561
combined_y - 10299 X 1
combined_subject - 10299 X 1

At this point training and test datasets are merged, though they still exist in seperate tables as mentioned above. To get to the required tidy data, three tasks are needed to be performed:

1) Select only those features in combined_x dataframe that correspond to mean and std dev.
2) Replace activity ids in combined_y with actual activity descriptions.
3) Perform a final merge to get the following structure [Subject ID, Activity, Selected Features]

Step 1 is performed using the features table. First, only those feature descriptions that correspond to mean or std dev are subsetted from the features table. This results in selected_features variable (79 X 1) having indices of the 79 features that match the criteria (mean or std dev). These indices are then used (and applied) to combined_x to subset it in such a way that it now contains only the columns corresponding to selected_features. This results in a subsetted combined_x variable (10299 X 79)

Step 2 is accomplished by means of utilizing the join function from plyr package, that provides activity labels to the activity ids in combined_y dataframe. This join operation results in a temp variable, whose second column is retained and rest (activity_ids) are discarded. (10299 X 1)

Step 3 is a simple merge operation combining combined_subject dataframe with new dataframes produced in step 1 and 2. It is a rowwise binding operation. This dataframe is called combined_data (10299 X 81).

Now the task is to provide each column of combined_data a descriptive name as follows
Column 1 - 'Subject ID'
Column 2 - 'Activity'
Column 3:81 - Names of the selected features.

Naming column 1 and 2 is trivial but for columns 3:81, the indices obtained in selected_features variable are utilized to get the corresponding names from the features table.

Finally a tidy dataset is created from combined_data dataframe, that provides the average of each variable for each activity and each subject. This is done using 'data.table' package and using the lapply command.

Resulting dataframe is called 'Avg' (180 X 81), which is then written to a text file 'Average_Tidy_Data.txt'.