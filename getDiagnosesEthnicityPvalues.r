###Script calculating pValues for diagnoses stratified by ethnicity (separately on letter and chapter levels)###

#Load file with counts of patients per diagnosis-ethnicity
mydata=read.csv("DiagnosesLetterCountsEthnicityOver100.csv", header = FALSE, col.names = c("CodeLetter","WhiteCount","BlackCount","AsianCount","OtherCount"))
#mydata=read.csv("DiagnosesChapterCountsEthnicityOver100.csv", header = FALSE, col.names = c("CodeChapter","WhiteCount","BlackCount","AsianCount","OtherCount"))

#Set total patient counts stratified by ethnicity 
whiteTotal=114501	
blackTotal=33388	
asianTotal=8568	
otherTotal=17411

#Get number of diagnoses for which p-values are required
codeNum=nrow(mydata)
#Assign memory for the vector of p-values
pValues<-vector(length=codeNum)
#Assign memory for the vector of Chi-square values
chiSquare<-vector(length=codeNum)

#For each diagnoses code...
for (n in 1:codeNum){
	#...construct contingency matrix to use in Chi-square test
	contingencyMatrix<-matrix(c(mydata[n,2],whiteTotal-mydata[n,2], mydata[n,3], blackTotal-mydata[n,3],mydata[n,4],asianTotal-mydata[n,4], mydata[n,5], otherTotal-mydata[n,5]),ncol=2,byrow=T)
	#...get chiSquare value
	chiSquare[n]<-chisq.test(contingencyMatrix)[1]
	#...get p-value
	pValues[n]<-chisq.test(contingencyMatrix)[3]
}

#Correct p-values using FDR Benjamini Hochberg method
pFDR<-p.adjust(pValues,method="fdr",n=length(pValues))
#Correct p-values using Bonferroni method
pBonferroni<-p.adjust(pValues,method="bonferroni",n=length(pValues))
#Add columns with p-values to the original dataset
mydata$chiSquare<-chiSquare
mydata$pValue<-pValues	
mydata$pFDR<-pFDR
mydata$pBonferroni <-pBonferroni
#Save results
write.csv(as.matrix(mydata),"letterEthnicityPvalues.csv")
#write.csv(as.matrix(mydata),"chapterEthnicityPvalues.csv")