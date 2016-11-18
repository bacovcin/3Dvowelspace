library(rgl)
library(dplyr)

# CHANGE FILE NAMES TO REFLECT YOUR DATASET
# CURRENT FILE NAMES ARE OF THE PENN NEIGHBORHOOD CORPUS

# Load raw vowel data (csv with following columns necessary: Subject, VClass, F1 and F2)
rawdata <- read.csv('PNC_primary_lexical_freq.csv')

# Load subject data (csv with following columns necessary: Subject, birthyear)
sbjdata <- read.csv('PNC_speakers.csv')

# Add the birthyear data to the vowel measurements
tmpdata <- merge(rawdata,sbjdata,by='Subject')

# Calculate the means and standard deviations for normalization
meansandsds <- group_by(tmpdata,Subject) %>% summarise(
			F1mean=mean(F1,na.rm=T),
			F1sd=sd(F1,na.rm=T),
			F2mean=mean(F2,na.rm=T),
			F2sd=sd(F2,na.rm=T))

# Calculate population means and standard deviations for rescaling the normalized values
# back to the original scale
untransformF1.mean <- mean(meansandsds$F1mean)
untransformF1.sd <- mean(meansandsds$F1sd)
untransformF2.mean <- mean(meansandsds$F2mean)
untransformF2.sd <- mean(meansandsds$F2sd)

# Combine the speaker means and standard deviations for normalization
# Use only speakers older than 17, whose vowels are fixed (a la 100 years of sound change paper)
normdata <- merge(tmpdata,meansandsds) %>% filter(age >= 17)

# Generate a new dataset for normalization
realdata <- data.frame(speaker=normdata$Subject,
           VClass=normdata$VClass,
		       birthyear=normdata$birthyear,
		       F1=(normdata$F1-normdata$F1mean)/normdata$F1sd,
		       F2=(normdata$F2-normdata$F2mean)/normdata$F2sd)

# Generate Untransformed versions of the dataset
realdata$untrans.F1 <- realdata$F1 * untransformF1.sd + untransformF1.mean
realdata$untrans.F2 <- realdata$F2 * untransformF2.sd + untransformF2.mean

# Save the new dataset for use with other functions
write.csv(realdata,file='realdata.csv')