#You should create one R script called run_analysis.R
#     that does the following. 
#Merges the training and the test sets to create
#      one data set.
#Extracts only the measurements on the mean
#and standard deviation for each measurement. 
#Uses descriptive activity names to name the
#activities in the data set
#Appropriately labels the data set with
#descriptive variable names. 
#From the data set in step 4, creates a second,
#independent tidy data set with the average
#of each variable for each activity and each subject.
library(dplyr)
setwd("UCI HAR Dataset")
ta <-read.table("activity_labels.txt")
tav<-as.vector(ta[,2])
f <-read.table("features.txt")
#----- for test
setwd("test")
s <- read.table("subject_test.txt", nrows=-1)
colnames(s)<-"subject"
a <- as.tbl(read.table("y_test.txt",nrows=-1))
#a1<-mutate(a, activity_name=tav[V1])
a1<-transmute(a, activity_name=tav[V1])
obs <- as.tbl(read.table("X_test.txt",
             col.names=as.vector(f$V2),
             colClasses="numeric",
             stringsAsFactors=FALSE, nrows=-1))
obs1<-select(obs, matches(".mean.|.std."))
test<-bind_cols(s,a1,obs1)
rm(obs, obs1, a, a1, s)
#---------  for train ----------
setwd("../train")
s <- read.table("subject_train.txt")
colnames(s)<-"subject"
a <- as.tbl(read.table("y_train.txt"))
a1<-transmute(a, activity_name=tav[V1])
obs <- as.tbl(read.table("X_train.txt",
                         col.names=as.vector(f$V2),
                         stringsAsFactors=FALSE, nrows=-1))
obs1<-select(obs, matches(".mean.|.std."))
train<-bind_cols(s,a1,obs1)
rm(obs, obs1, a, a1, s)
# Merge data and write output
setwd("../")
w1<- rbind(test, train)
# write.csv(w1, "w1.csv", dec=",") for test
w2 <- group_by(w1, subject, activity_name)
w3<-summarise_each(w2, funs(mean))
write.table(w3, file="outcome.txt",row.names=FALSE)
#writeClipboard(colnames(test), format=1)
