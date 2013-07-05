phraseShift_both<-function(k,date,time,root){
	
	directory=paste(root,"Data/",date,"/",time,sep="")

	E_f<-read.csv(paste(directory,"_entropy_shift.csv",sep=""),header=T,quote="\"",sep=",",dec=".",colClasses=c("character","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))
	E_g<-read.csv(paste(directory,"entropy_timeseries.csv",sep=""),sep=",",dec=".",quote="\"",colClasses=c("numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","character","character"),header=F)

	V_f<-read.csv(paste(directory,"_valence_shift.csv",sep=""),header=T,quote="\"",sep=",",dec=".",colClasses=c("character","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))
	V_g=read.csv(paste("valence_timeseries.csv",sep=""),sep=",",dec=".",quote="\"",colClasses=c("numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","character","character"),header=F)

	FILE=paste(directory,"_",as.character(k),"-storyFinder.pdf",sep="")
        pdf(file=FILE,9.7,7.5)

        possibleIndices=which(E_g$V12==date)
	currentIndex=0
        currentIndex=currentIndex+possibleIndices[which(E_g$V13[possibleIndices]==time)]

	E_timeseries=E_g[,k+1]
	V_timeseries=V_g[,k+1]
	
	E_timeseries_ALL=E_g[,1]
	V_timeseries_ALL=V_g[,1]

	if (k==0){	
	   	E_shifts=sort(abs(E_f$shiftCompG*E_f$pCompG-E_f$shiftRefG*E_f$pRefG),decreasing=T,index.return=T)
		V_shifts=sort(abs(E_f$shiftCompG*E_f$pCompG-E_f$shiftRefG*E_f$pRefG),decreasing=T,index.return=T)
		
		E_indices=E_shifts$ix
		V_indices=V_shifts$ix

		E_diff=E_f$shiftCompG[E_indices]
		V_diff=V_f$shiftCompG[E_indices]
		
		E_shifts=E_shifts$x
		V_shifts=V_shifts$x
	}
	else{
		order_indices=which(E_f$order==k)

		E_shifts=sort(abs(E_f$shiftCompL[order_indices]*E_f$pCompL[order_indices]-E_f$shiftRefL[order_indices]*E_f$pRefL[order_indices]),decreasing=T,index.return=T)
                V_shifts=sort(abs(E_f$shiftCompL[order_indices]*E_f$pCompL[order_indices]-E_f$shiftRefL[order_indices]*E_f$pRefL[order_indices]),decreasing=T,index.return=T)

                E_indices=order_indices[E_shifts$ix]
                V_indices=order_indices[V_shifts$ix]

		E_diff=E_f$shiftCompL[E_indices]
                V_diff=V_f$shiftCompL[E_indices]

                E_shifts=E_shifts$x
                V_shifts=V_shifts$x		
	}
		
	if (currentIndex>1){
		E_diff=(E_timeseries[currentIndex]-E_timeseries[currentIndex-1])
		V_diff=(V_timeseries[currentIndex]-V_timeseries[currentIndex-1])
		refEnt=E_timeseries[currentIndex-1]
        	refVal=V_timeseries[currentIndex-1]
		compEnt=E_timeseries[currentIndex]
	        compVal=V_timeseries[currentIndex]
	} else {
	        print("No can do boss!")
	}
			
	
	entList=c()
	valList=c()
	for (i in 20:1){		
		if (E_diff[i]>=0){
			entList=rbind(entList,c(E_shifts[i],"lightgoldenrod",E_f$phrase[E_indices[i]]))	#(shift,color,phrase)
		} else {
		        entList=rbind(entList,c(E_shifts[i],"steelblue",E_f$phrase[E_indices[i]])) #(shift,color,phrase)
		}		
		if (V_diff[i]>=0){
                        valList=rbind(entList,c(V_shifts[i],"lightgoldenrod",V_f$phrase[V_indices[i]])) #(shift,color,phrase)
                } else {
                        valList=rbind(entList,c(V_shifts[i],"steelblue",V_f$phrase[V_indices[i]])) #(shift,color,phrase)
                }		
	}
		
	if (E_diff>=0){
		entropy="  >"
	}
	else{
		entropy="  <"
	}
	if (V_diff>=0){
		valence="  >"
	}
	else{
		valence="  <"
	}	

	#(shift,color,phrase)
	
	E_HeightLeft=(0:19)*1.2+0.6
	E_HeightRight=(0:19)*1.2+0.6
	E_Left=as.numeric(entList[,1])
	E_Right=as.numeric(entList[,1])
	
	E_HeightLeft=E_HeightLeft[E_Left>0]
	E_entLeft=entList[E_Left>0,3]
	E_Lcol=entList[E_Left>0,2]
	E_Left=E_Left[E_Left>0]
	
	E_HeightRight=E_HeightRight[E_Right<0]
	E_entRight=entList[E_Right<0,3]
	E_Rcol=entList[E_Right<0,2]
	E_Right=E_Right[E_Right<0]
	
	V_HeightLeft=(0:19)*1.2+0.6
	V_HeightRight=(0:19)*1.2+0.6
	V_Left=as.numeric(valList[,1])
	V_Right=as.numeric(valList[,1])
	
	V_HeightLeft=V_HeightLeft[V_Left>0]
	V_valLeft=valList[V_Left>0,3]
	V_Lcol=valList[V_Left>0,2]
	V_Left=V_Left[V_Left>0]
	
	V_HeightRight=V_HeightRight[V_Right<0]
	V_valRight=valList[V_Right<0,3]
	V_Rcol=valList[V_Right<0,2]
	V_Right=V_Right[V_Right<0]
		
	#(shift,color,phrase)

	par(las=2,mfrow=c(2,2),fig=c(0.0675,0.43,0,0.55))
	barplot(as.numeric(entList[,1]),col=entList[,2],horiz=T,xlim=c(-max(abs(as.numeric(entList[,1]))),max(abs(as.numeric(entList[,1]))))*1.1,xaxt="n",main=quote(S["comp"]~~~~~~S["ref"]),ylim=c(0,25.5))
	
	if (length(E_entRight)){
		text((1:length(E_entRight))*0,E_HeightRight,E_entRight,pos=4,cex=0.6)	
	}
	if (length(E_entLeft)){		
		text((1:length(E_entLeft))*0,E_HeightLeft,E_entLeft,pos=2,cex=0.6)
	}
	
	if (k){
		plotk=as.character(k)
	}
	else{
		plotk="all"	
	}
	title(main=entropy,cex.main=1)
	text(0,25.5,paste(plotk,"-Entropy shift",sep=""))
	E_xlims=signif(max(abs(as.numeric(entList[,1]))),2)
	par(las=1)
	
	axis(1,c(-max(abs(as.numeric(entList[,1]))),max(abs(as.numeric(entList[,1]))))*0.75, 0.75*c(E_xlims,E_xlims),cex.axis=0.7,lwd.ticks=0.5)
	axis(1,0,"(bits)",cex.axis=0.8,lwd.ticks=0)
	
	par(las=2,mfrow=c(2,2),fig=c(0.0675,0.47,0.05,0.485))
	box(which="figure",lty=1,lwd=4)
	
	# do the valence shift
	par(las=2,fig=c(0.565,0.9275,0,0.55),new=T)
	barplot(as.numeric(valList[,1]),col=valList[,2],horiz=T,xlim=c(-max(abs(as.numeric(valList[,1]))),max(abs(as.numeric(valList[,1]))))*1.1,xaxt="n",ylim=c(0,25.5),main=quote(h["comp"]~~~~~~h["ref"]))
	
	if (length(V_valRight)){
		text((1:length(V_valRight))*0,V_HeightRight,V_valRight,pos=4,cex=0.6)
	}
	if (length(V_valLeft)){
		text((1:length(V_valLeft))*0,V_HeightLeft,V_valLeft,pos=2,cex=0.6)
	}
			
	title(main=valence,cex.main=1)
	text(0,25.5,paste(plotk,"-Valence shift",sep=""))
	V_xlims=signif(max(abs(as.numeric(valList[,1]))),2)
	par(las=1)
	
	axis(1,c(-max(abs(as.numeric(valList[,1]))),max(abs(as.numeric(valList[,1]))))*0.75, 0.75*c(V_xlims,V_xlims),cex.axis=0.7,lwd.ticks=0.5)
	axis(1,0,"(happs)",cex.axis=0.8,lwd.ticks=0)
	
	par(las=2,fig=c(0.565,0.9675,0.05,0.485),new=T)
	box(which="figure",lty=1,lwd=4)
		
	# start in on the time series plots
	midnightIndices=which(V_g$V13 == "00")		
			
	par(las=2,fig=c(0,1,0.6725,1),new=T)
	plot(1:length(E_timeseries),E_timeseries,pch=20,xlab="",ylab="(bits)",main="Timeseries'",type="l",cex=0.5,xaxt='n',col="black")
	points(currentIndex,E_timeseries[currentIndex],pch=20,col='red',cex=1)
	
	for (i in 1:length(midnightIndices)){
                lines(c(midnightIndices[i],midnightIndices[i]),c(-10,10),lty=3,col='grey')
        }
	
	par(las=2,fig=c(0,1,0.5,0.8275),new=T)
	plot(1:length(V_timeseries),V_timeseries,pch=20,xlab="Year",ylab="(happs)",main="",type="l",cex=0.5,xaxt='n',col="black")
	points(currentIndex,V_timeseries[currentIndex],pch=20,col='red',cex=1)
	
	for (i in 1:length(midnightIndices)){
                lines(c(midnightIndices[i],midnightIndices[i]),c(-10,10),lty=3,col='grey')
        }	
	
	axis(1,midnightIndices,V_g$V12[midnightIndices],las=0)		
	
	dev.off()
	
}