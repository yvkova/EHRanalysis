###Script to generate binary representation of complete (as in CRIS) diagnoses for all patients###
#Load dataset
mydata=read.csv("AnonymisedPatientDiagnoses.csv", header = FALSE, sep = ",", col.names = paste0("V",seq_len(17)), fill = TRUE)
#Get the list of unique diagnoses mentioned in the dataset
allLevels <- levels(factor(unlist(mydata)))
#Remove the empty case
allLevels<-allLevels[allLevels!=""]
features<-matrix(0, nrow = nrow(mydata), ncol=length(allLevels))
for (i in 1:nrow(mydata)) {for (j in 1:length(allLevels)) {if(any(mydata[i,]==allLevels[j])) features[i,j]=1}}
#Save feature set
save(features,file="fullFeatures.RData")
write.csv(features,"fullFeatures.csv")