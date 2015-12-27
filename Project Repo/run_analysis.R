# Downloading the data and putting it in data folder inside the present working directory
if(!file.exists("./data")){dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/HAR Dataset.zip", method ="libcurl")


#Loading various files into R

X_test<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")
X_train<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")
features<-read.table("./data/UCI HAR Dataset/features.txt")
activity<-read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Initial merging, x is actual feature data, y is activity id, subject is subject id
combined_x<-rbind(X_test,X_train)
combined_y<-rbind(y_test,y_train)
combined_subject<-rbind(subject_test,subject_train)

# Selecting out of 561 features only those that are mean and std dev
Selected_features<-grep("-mean()|-std()",features[,2])

# Subsetting relevant features corresponding to selected features in the feature data i.e. combined_x
combined_x<-combined_x[,Selected_features]

# providing activity label to activity id (that is now stored in combined y), and saving this as temp
library(plyr)
temp<-join(combined_y,activity)

# Getting Activity Label
ActivityLabel<-temp[,2]
ActivityLabel<-data.frame(ActivityLabel)

# Merging all the datasets (Subject who performed measurement, activity label, feature data) together, to obtain the desired dataset
combined_data<-cbind(combined_subject,ActivityLabel,combined_x)

# Naming the columns of the combined dataset
names(combined_data)[1]<-"Subject ID"
names(combined_data)[2]<-"Activity"
names(combined_data)[3:ncol(combined_data)]<-gsub("(|)","",features$V2[Selected_features])

# Creating final Tidy Dataset
# Average of each variable for each activity and each subject
library(data.table)
TidyData<-data.table(combined_data)
Avg<-TidyData[,lapply(.SD,mean), by=c("Subject ID","Activity")]
write.table(Avg,"Average_Tidy_Data.txt", row.name=FALSE)