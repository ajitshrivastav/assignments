library(dplyr)
library(tidyr)
library(data.table)

####### Merges the training and the test sets to create one data set.

# read x_data_settest data set
x_data_set <- read.table("data_wrangling_ex_3/data_set/UCI/test/X_test.txt")
# bind x_data_settraining data set 
features_data_set <- read.table("data_wrangling_ex_3/data_set/UCI/features.txt")

x_data_set <- rbind(x_data_set, read.table("data_wrangling_ex_3/data_set/UCI/train/X_train.txt"))
# read y_data_set rest data set
y_data_set <- read.table("data_wrangling_ex_3/data_set/UCI/test/y_test.txt")
# bind y_data_set training data set 
y_data_set <- rbind(y_data_set, read.table("data_wrangling_ex_3/data_set/UCI/train/y_train.txt"))

# read subject test data set
subject_data_set <- read.table("data_wrangling_ex_3/data_set/UCI/test/subject_test.txt")
# bind subject training data set 
subject_data_set <- rbind(subject_data_set, read.table("data_wrangling_ex_3/data_set/UCI/train/subject_train.txt"))

####### Extract columns containing mean and standard deviation

colnames(x_data_set) <- c(make.names(features_data_set$V2, unique = TRUE, allow_ = TRUE))
#Select columns that contains "mean" and "standard"

mean_std <- x_data_set %>% select(contains("mean"), contains("std"))
xy_data_set <- bind_cols(x_data_set,y_data_set)
setnames(xy_data_set,"V1","ActivityLabel")

######## Creates variables called ActivityLabel and ActivityName 
ActivityLabel = c(1,2,3,4,5,6)
ActivityName = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
Activity_data_set = data.frame(ActivityLabel,ActivityName)


####### Create tidy data summarising activity

# Join the data set with activity labels
xy_data_set_activity <- left_join(xy_data_set, Activity)

# Bind the subject with the data sets
xy_subject_data_set_activity <- bind_cols(subject_data_set,xy_data_set_activity)

# Perform tidy operation for all the 561 set of activities
xy_subject_data_set_activity_tidy <- gather(xy_subject_data_set_activity, "feature", "value", 2:562)

# summarise
xy_tidy_data <- 
  xy_subject_data_set_activity_tidy %>% 
  group_by(ActivityName, V1, feature) %>% 
  summarise( mean = mean(value))
