# this tests the diff approximation

#refEnt=read.csv("/Users/storyfinder/data/18.04.13/00.14_entropy.csv",colClasses=c("character","numeric","numeric","numeric","numeric"),header=T)
#compEnt=read.csv("/Users/storyfinder/data/18.04.13/00.29_entropy.csv",colClasses=c("character","numeric","numeric","numeric","numeric"),header=T)

diff=sum(compEnt$ent*compEnt$freq)-sum(refEnt$ent*refEnt$freq)

approxDiff=0

for (i in 1:length(compEnt$ent)){
	phrase=compEnt$phrase[i]
	index=0
	index=index+which(refEnt$phrase==phrase)
	if (length(index)){
		approxDiff=approxDiff+(compEnt$ent[i]-refEnt$ent[index])*(compEnt$freq[i]-refEnt$freq[index])
	} else {
		approxDiff=approxDiff+compEnt$ent[i]*compEnt$freq[i]
	}	
}

for (i in 1:length(refEnt$ent)){
	phrase=refEnt$phrase[i]
	index=0
	index=index+which(compEnt$phrase==phrase)
	if (!(length(index))){
		approxDiff=approxDiff+refEnt$ent[i]*refEnt$freq[i]
	}	
}
