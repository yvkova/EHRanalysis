###Script calculating pValues for diagnoses stratified by gender (separately on letter and chapter levels)###

#Load file with counts of patients per diagnosis-gender
mydata=read.csv("DiagnosesLetterCountsGenderOver100.csv", header = FALSE, col.names = c("CodeLetter","FemaleCount","MaleCount"))
#mydata=read.csv("DiagnosesChapterCountsGenderOver100.csv", header = FALSE, col.names = c("CodeLetter","FemaleCount","MaleCount"))

#Set total patient counts stratified by gender
femaleTotal=101813
maleTotal=101549

#Get number of diagnoses for which p-values are required
codeNum=nrow(mydata)
#Assign memory for the vector of p-values
pValues<-vector(length=codeNum)
#Assign memory for the vector of Chi-square values
chiSquare<-vector(length=codeNum)

#For each diagnoses code...
for (n in 1:codeNum){
	#...construct contingency matrix to use in Chi-square test
	contingencyMatrix<-matrix(c(mydata[n,2],femaleTotal-mydata[n,2], mydata[n,3], maleTotal-mydata[n,3]),ncol=2,byrow=T)
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
write.csv(as.matrix(mydata),"letterGenderPvalues.csv")
#write.csv(as.matrix(mydata),"chapterGenderPvalues.csv")