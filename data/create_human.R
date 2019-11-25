library(dplyr)

# READING THE DATASETS

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

## Structures
str(hd)
str(gii)

## Dimensions
dim(hd)
dim(gii)

## Glimpse of datasets
glimpse(hd)
glimpse(gii)

## Renaming
colnames(gii)
gii <- rename(gii,
              edu2F = Population.with.Secondary.Education..Female.,
              edu2M = Population.with.Secondary.Education..Male.,
              labF = Labour.Force.Participation.Rate..Female.,
              labM = Labour.Force.Participation.Rate..Male.
)
colnames(gii)
gii <- mutate(gii, edu2F_edu2M_ratio = edu2F / edu2M)
gii <- mutate(gii, labF_labM_ratio = labF / labM)

# common columns to use as identifiers

join_by <- c("Country")

# join the datasets
hd_gii <- inner_join(hd, gii, by = join_by, suffix = c(".hd", ".gii"))


# create a new data frame with only the joined columns
human <- select(hd_gii, "Country")
glimpse(human)

# columns not used for joining
notjoined_columns <- colnames(hd_gii)[!colnames(hd_gii) %in% c("Country")]

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'hd_gii' with the same original name
  two_columns <- select(hd_gii, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  #if(is.numeric(first_column)) {
  # take a rounded average of each row of the two columns and
  # add the resulting vector to the alc data frame
  #alc[column_name] <- round(rowMeans(two_columns))
  #} else { # else if it's not numeric...
  # add the first column vector to the alc data frame
  human[column_name] <- first_column
  #}
}

# take a glimpse of the completed dataset 
glimpse(human)

# set working directory
getwd()

setwd("/Users/streetman/IODS-project/data")

# write to csv file
write.csv(gii, "data/human.csv", row.names = FALSE)



