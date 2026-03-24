allForNothing<-function(k,indexFile,index,text,figure){

	if (!sum(figure)){
	   figure=c(0,1,0,1)	
	}
	f<-read.csv(indexFile,header=T,quote="\"",sep=",",dec=".",colClasses=c("character","numeric","numeric","numeric","numeric"))
	indices=which(f[,3]>0)
	f=f[indices,]
#	maxK=max(f$order)
#	for (k in 0:maxK){
	if ((length(which(f$order==k))>=30) || !k){
#	printFile=paste(printHandle,"_",as.character(k),"-",index,"_contributors.pdf",sep="")
#	pdf(file = printFile,width=5,height=7)	
	
	cumulative=c()
	total=0
	
	if (k==0){		
		ave=sum(f[,2]*f[,3])/sum(f[,2])	
		contributions=((f[,3]-ave)*f[,2])/sum(f[,2])
		sorted=sort(abs(contributions),decreasing=T,index.return=T)
		indices=sorted$ix
		contributions=contributions[indices]
		phrases=f$phrase[indices]
		entropy=f[indices,3]

		cumulative=cumsum(contributions)
		#cumulative=100*cumulative/max(cumulative)		
	}
	else{
		kIx=which(f$order==k)		
		phrases=f$phrase[kIx]
		ave=sum(f[kIx,2]*f[kIx,3])/sum(f[kIx,2])	
		contributions=((f[kIx,3]-ave)*f[kIx,2])/sum(f[kIx,2])		
		sorted=sort(abs(contributions),decreasing=T,index.return=T)
		indices=sorted$ix
		contributions=contributions[indices]
		phrases=phrases[indices]
		entropy=f[kIx[indices],3]
				
		cumulative=cumsum(contributions)
		#cumulative=100*cumulative/max(cumulative)		
	}
	
	if (length(contributions)>=30){
		top=30
	} else {
		top=length(contributions)
	}
				
	list=c()
	for (i in top:1){		
		if (contributions[i]>0){
			list=rbind(list,c(contributions[i],phrases[i],"khaki1"))
		} else {
			list=rbind(list,c(contributions[i],phrases[i],"royalblue1"))
		}		
	}
	
	N_heightLeft=((0:29)*1.2+0.6)[list[,1]<0]
	N_heightRight=((0:29)*1.2+0.6)[list[,1]>0]
	N_leftPos=as.numeric(list[,1])[list[,1]<0]
	N_rightPos=as.numeric(list[,1])[list[,1]>0]
	N_leftPhrase=list[list[,1]<0,2]
	N_rightPhrase=list[list[,1]>0,2]
	
	xlims=c(-max(abs(as.numeric(list[,1]))),max(abs(as.numeric(list[,1]))))
	displayLims=(round(100*xlims/ave,digits=3))*0.9
	
	if ((sum(figure)==2)){
		quartz("",5,7)
		par(las=2,fig=(figure+c(0.05,-0.05,0.15,0)*(figure[4]-figure[3])),mar=c(2,1,1,1))
	}
	else{
		par(las=2,fig=figure+c(0,0,0.15*(figure[4]-figure[3]),0),mar=c(2,1,1,1),new=T)
	}
	
	par(las=1)
	barplot(as.numeric(list[,1]),col=list[,3],horiz=T,beside=F,ylim=c(0,37.5),xlim=xlims,xaxt="n")	
	
	if (length(N_rightPos)){
		text((1:length(N_rightPos))*0,N_heightRight,N_rightPhrase,pos=2,cex=0.5)
	}
	if (length(N_leftPos)){
		text((1:length(N_leftPos))*0,N_heightLeft,N_leftPhrase,pos=4,cex=0.5)
	}
	
	axis(1,c(xlims[1]*0.9,0,xlims[2]*0.9),c(displayLims[1],"Percent contribution",displayLims[2]),cex.axis=0.6)
	
	
	if (k){
		plotk=as.character(k)
	}
	else{
		plotk="all"	
	}
	
	text(0,37.5,paste(plotk,"-",index," Contributors: ",text,sep=""),cex=0.8)
	par(las=2,fig=(figure+c(0,0,0.085,0)*(figure[4]-figure[3])),mar=c(2,1,1,1))
	box()
	
	par(las=1,fig=figure-c(0,0,-0.01,0.85)*(figure[4]-figure[3]),mar=c(1,3,1,1),new=T)
	ylims=c(min(100*cumulative/ave),max(100*cumulative/ave))
	plot(log10(1:length(cumulative)),100*cumulative/ave,type='l',xlab="",ylab="",xaxt="n",cex.axis=0.5,ylim=ylims,bty="n")
	polygon(c(0,log10(1:30),log10(30)),100*c(0,cumulative[1:30],0)/ave,col='grey')
	lines(c(0,log10(length(cumulative))),c(0,0),col="red",lty=3)
	par(las=1,fig=figure-c(0,0,0,0.84)*(figure[4]-figure[3]),mar=c(1,3,1,1),new=T)
	plot(0,0,xaxt="n",yaxt="n",pch="",ylab="",xlab="")
	par(las=1,fig=figure-c(0,0,0,0.84)*(figure[4]-figure[3]),mar=c(1,1,1,1),new=T)
	box()	
#	dev.off()
	}
#	}
}