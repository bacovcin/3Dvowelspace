library(rgl)
library(dplyr)

# Set window size for smoothing (i.e., number of years before and after the center to include in the window)
window.size <- 10

# Load the output of normalize-data.R
realdata <- read.csv('realdata.csv')

# Generate a smoothed version of the data for graphing (using moving window average for smoothing)
graphdata<-expand.grid(birthyear=(min(realdata$birthyear)+window.size):(max(realdata$birthyear)-window.size),
                      VClass=levels(factor(realdata$VClass)),
                      F1=NA,
                      F2=NA)

# For each vowel go through all the years and calculate the windowed average F1 and F2 for that year
for (i in 1:dim(graphdata)[1]) {
 print(i/dim(graphdata)[1])
 graphdata$F1[i]<-mean(realdata$untrans.F1[realdata$birthyear>=(graphdata$birthyear[i]-window.size) &
                                           realdata$birthyear<=(graphdata$birthyear[i]+window.size) &
                                           realdata$VClass == graphdata$VClass[i]])
 graphdata$F2[i]<-mean(realdata$untrans.F2[realdata$birthyear>=(graphdata$birthyear[i]-window.size) &
                                             realdata$birthyear<=(graphdata$birthyear[i]+window.size) &
                                             realdata$VClass == graphdata$VClass[i]])
}

# Save the data frame for quick use later
save(graphdata,file='graphdata.RData')

# Load the saved data frame so the smoothing does not need to be repeated
load('graphdata.RData')

# Generate the 3d graph
text3d(-graphdata$F2,-graphdata$F1,graphdata$birthyear,text=graphdata$VClass)
axes3d()
