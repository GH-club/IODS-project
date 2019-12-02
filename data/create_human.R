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
  # add the resulting vector to the hd_gii data frame
  #hd_gii[column_name] <- round(rowMeans(two_columns))
  #} else { # else if it's not numeric...
  # add the first column vector to the 'hd_gii' data frame
  human[column_name] <- first_column
  #}
}

# take a glimpse of the completed dataset 
glimpse(human)

# set working directory
getwd()

setwd("/Users/streetman/IODS-project/data")

# write to csv file
write.csv(human,"/Users/streetman/IODS-project/data/human.csv", row.names = FALSE)


# MODIFYING THE DATA (Chapter 5)

library(stringr)

human <- read.table("/Users/streetman/IODS-project/data/human.csv", sep  =",", header = T)

names(human)

str(human)

summary(human)

tail(human)

human <- mutate(human, GNI = as.numeric(str_replace(GNI, pattern=",", replace ="")))

tail(human, 20)

keep <- c("Country", "edu2F", "labF_labM_ratio", "Life.Expectancy.at.Birth", "Expected.Years.of.Education", "Gross.National.Income..GNI..per.Capita", "Maternal.Mortality.Ratio", "Adolescent.Birth.Rate", "Percent.Representation.in.Parliament")

human <- select(human, one_of(keep))

complete.cases(human)

data.frame(human[-1], comp = complete.cases(human))

human <- filter(human, complete.cases(human))

human <- human[1:155, ]

rownames(human) <- human$Country

human <- select(human, -Country)

str(human)

tail(human, 60)

colnames(human)

setnames(human, old=c("edu2F", "labF_labM_ratio", "Life.Expectancy.at.Birth", "Expected.Years.of.Education", "Gross.National.Income..GNI..per.Capita", "Maternal.Mortality.Ratio", "Adolescent.Birth.Rate", "Percent.Representation.in.Parliament"), new=c("Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F"))

getwd()

write.csv(human, "/Users/streetman/IODS-project/data/human.csv")

