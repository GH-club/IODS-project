# Janne Kinnunen, 17.11.2019, Data project of students related to alcohol consumption

## Datasource
getwsd()

## Reading the data
math <- read.table("/Users/streetman/IODS-project/data/student-mat.csv", sep = ";" , header=TRUE)
dim(math)
str(math)

por <- read.table("/Users/streetman/IODS-project/data/student-por.csv", sep = ";", header = TRUE)
dim(por)
str(por)

## Joining the two dataset
library(dplyr)

join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))
dim(math_por)
str(math_por)

## Combining the not joined variables (by selecting two columns from the combined data of the variables which were not combined initially and selecting one of those two to the new dataset "alc")
alc <- select(math_por, one_of(join_by))
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

for(column_name in notjoined_columns) {
  
  two_columns <- select(math_por, starts_with(column_name))

  first_column <- select(two_columns, 1)[[1]]
  
 
  if(is.numeric(first_column)) {
    
    alc[column_name] <- round(rowMeans(two_columns))
    
  } else {
    
    alc[column_name] <- first_column
  }
}

## Modifying the "alc" variable related to alcohol consumption (taking average and mutating to high consumption parameter)
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)
dim(alc)

## Writing and checking .csv file
write.csv(alc, file = "alc.csv")
read.csv("alc.csv")
str(alc)
head(alc)
