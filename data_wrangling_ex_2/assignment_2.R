# load the original data set
original_data_set <- read.csv("data_wrangling_ex_2/data/titanic_original.csv")
summary(original_data_set)
# print unique values for embarked
unique(original_data_set$embarked)

# get rid of all leading/triling whitespaces
data_set <- original_data_set %>% mutate(embarked=trimws(embarked))
# set embarked to "S" if empty
data_set <- data_set %>% mutate(embarked=ifelse(embarked=="", "S", embarked))

# set the age as numeric
data_set$age <- as.numeric(data_set$age)
# get age in temp data set to evaluate mean, null values not to be used to calculate mean
tmp_age_data_set <- data_set %>% filter(!is.na(age))
mean_age <- mean(tmp_age_data_set$age)
# assign mean values to rows where age is NA, median may be another alternative here
data_set <- data_set %>% mutate(age=ifelse(is.na(age), mean_age, age))

# clean up boat column
data_set <- data_set %>% mutate(boat=trimws(boat))
# set boat value to NA if empty
data_set <- data_set %>% mutate(boat=ifelse(boat=="", NA, boat))

# clean cabin value
data_set <- data_set %>% mutate(cabin=trimws(cabin))
# add a new column has_cabin that captures if the person has cabin
data_set <- data_set %>% mutate(has_cabin_number=ifelse(cabin=="", 0, 1))
data_set
