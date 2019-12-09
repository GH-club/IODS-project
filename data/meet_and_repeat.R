# Loading datasets

library(dplyr)
library(tidyr)


BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
str(BPRS)
dim(BPRS)
names(BPRS)
summary(BPRS)

write.csv(BPRS, file = "~/IODS-project/data/bprs.csv")

RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep  ="\t", header = T)
str(BPRS)
dim(BPRS)
names(BPRS)
summary(BPRS)

write.csv(RATS, file = "~/IODS-project/data/rats.csv")


# Converting the variables

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$Group <- factor(RATS$Group)
RATS$ID <- factor(RATS$ID)

RATSL <- RATS %>% gather(key = WD, value = Weight, -ID, -Group) %>% mutate(Time = as.integer(substr(WD,3,5)))

BPRSL <- BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject) %>% mutate(weeks = as.integer(substr(weeks,5,5)))


# Overview of the changed variables in long form

str(BPRSL)
dim(BPRSL)
names(BPRSL)
summary(BPRSL)
glimpse(BPRSL)

str(RATSL)
dim(RATSL)
names(RATSL)
summary(RATSL)
glimpse(RATSL)


# Writing the csv.files

getwd()

write.csv(BPRSL, file = "/Users/streetman/IODS-project/data/BPRSL.csv")

write.csv(RATSL, file = "/Users/streetman/IODS-project/data/RATSL.csv")



