Janne Kinnunen 6.11.2019 - data wrangling in Exercise 2

# read the data into memory
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# exploring the structure, variables and observations
str(lrn14)

# checking the dimensions, number of rows and columns
dim(lrn14)

#excluding the observations
lrn14 <- filter(lrn14, Points > 0)

# combining the questions
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

#selecting colums
deep_columns <- select(lrn14, one_of(deep_questions))
surf_columns <- select(lrn14, one_of(surface_questions))
stra_columns <- select(lrn14, one_of(strategic_questions))

#scaling the combined columns
lrn14$deep <- rowMeans(deep_columns)
lrn14$surf <- rowMeans(surf_columns)
lrn14$stra <- rowMeans(stra_columns)

#creating data set
library(dplyr)
keep_columns <- c("gender", "Age", "Attitude", "deep", "stra", "surf", "Points")
lrn14 <- select(lrn14, one_of(keep_columns))
dim(lrn14)

#setting the working directory
getwd()
setwd("/Users/streetman/IODS-project/data")

#writing and checking csv. file
write.csv(lrn14, file = "lrn14.csv")
read.csv("lrn14.csv")
str(lrn14)
head(lrn14)
