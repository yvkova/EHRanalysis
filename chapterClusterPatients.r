###Script to cluster patients based on their Chapter diagnoses###

#Load chapter-diagnoses list as featureNames
load("chapterDiagnosesList.RData")

#Load binary feature vectors indicating whether each chapter-diagnosis present/absent for each patient
features=read.csv("chapterFeatures.csv")
#Get subset of features if memory is a problem
features<-features[1:10000,]
#Calculate distance/similarity matrix 
d<-dist(features,method="binary")
#Generate clustering model
fit<-hclust(d,method="ward.D")

##Get cluster info based on the model
#Set number of clusters
clustNum<-5 
#Cut the dendrogram for the desired number of clusters 
democut=cutree(fit,k=clustNum) 
#Assign memory for the matrix showing frequency of codes in each cluster
clusterCodes<-featureNames
#Assign memory for the vector showing the number of members(patients) in each cluster
clusterMemberNum<-vector(length=clustNum)
#Repeat for each cluster
for (n in 1:clustNum){
	#Get member(patient) ids in the current cluster 
	kMembers<-as.numeric(subset(names(democut),democut==n))	
	#Assign memory for the matrix of features for each member(patient) in the cluster
	kFeatures=matrix(0,nrow=length(kMembers), ncol=ncol(features))
	#Get features (i.e. 0/1 for each diagnosis code) for each cluster member (patient)
	for(i in 1:length(kMembers)){
		for(j in 1:ncol(features)) kFeatures[i,j]=features[kMembers[i],j]
	}
	#Assign memory for the vector of frequency count of each diagnosis code in the cluster 
	kCodes<-vector(length=ncol(kFeatures)-1)
	#Get frequency count for each diagnosis in the cluster (based on the number of patients having it)
	for (i in 1:length(kCodes)) kCodes[i]=length(subset(kFeatures[,i+1], kFeatures[,i+1]==1))
	#Add diagnosis code frequency counts in the current cluster to the summary matrix of all clusters 
	clusterCodes<-cbind(clusterCodes,kCodes)
	#Update the vector of cluster member numbers with the number of members(patients) in the current cluster 
	clusterMemberNum[n]<-length(kMembers)
}
#Save results: feature counts in each cluster and number of members in each cluster
save(clusterCodes,file="chapterClusterCodes_10k1_5.RData")
write.csv(clusterCodes,"chapterClusterCodes_10k1_5.csv")
save(clusterMemberNum,file="chapterClusterMemberNum_10k1_5.RData")
write.csv(clusterMemberNum,"chapterClusterMemberNum_10k1_5.csv")