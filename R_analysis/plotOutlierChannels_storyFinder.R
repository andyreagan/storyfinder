E_g<-read.csv("/Users/storyfinder/data/entropy_timeseries.csv",sep=",",dec=".",quote="\"",colClasses=c("numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","character","character","character"),header=F)
V_g=read.csv("/Users/storyfinder/data/valence_timeseries.csv",sep=",",dec=".",quote="\"",colClasses=c("numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","numeric","character","character","character"),header=F)

pdf(file="/Users/storyfinder/data/outlierChannels.pdf",13,2)

E_channels=(1:length(E_g[,1]))*0
V_channels=(1:length(E_g[,1]))*0

E_data=(1:length(E_g[,1]))*0
V_data=(1:length(E_g[,1]))*0
ALL_data=(1:length(E_g[,1]))*0

for (i in 1:11){	
	print(i)
	E_timeseries=c(mean(E_g[,i]),E_g[,i])
	V_timeseries=c(mean(V_g[,i]),V_g[,i])

	E_diffSeries=E_timeseries[2:length(E_timeseries)]-E_timeseries[1:(length(E_timeseries)-1)]
	V_diffSeries=V_timeseries[2:length(V_timeseries)]-V_timeseries[1:(length(V_timeseries)-1)]	
	
	E_diffSeries=c(mean(E_diffSeries),E_diffSeries)
	V_diffSeries=c(mean(V_diffSeries),V_diffSeries)
	
	E_timeseries=E_diffSeries
	V_timeseries=V_diffSeries
	TIT="Index-diff channel outliers"
		
	for (j in 1:length(E_g[,1])){
	
		E_box=boxplot(E_timeseries[1:j],plot=FALSE)
		V_box=boxplot(V_timeseries[1:j],plot=FALSE)
									
		for (k in 1:length(E_box$out)){
			dex=which(E_timeseries == E_box$out[k])
			E_channels[dex]=E_channels[dex]+1
			if(length(dex)){
				if (j==dex){
					E_data[j]=V_data[j]+1
					ALL_data[j]=ALL_data[j]+1	
				}
			}
		}
			
		for (k in 1:length(V_box$out)){
			dex=which(V_timeseries == V_box$out[k])				
			V_channels[dex]=V_channels[dex]+1
			if(length(dex)){			
				if (j==dex){
					V_data[j]=V_data[j]+1
					ALL_data[j]=ALL_data[j]+1	
				}
			}
		}
	}
}
divides=length(E_g[,1]):1

par(mar=c(3,3.8,1.8,1),las=2)
series=E_channels/divides+V_channels/divides

V_series=V_channels/divides
E_series=E_channels/divides

smoothSeries=c(0,0)
for (i in 3:(length(series)-2)){
	smoothSeries=c(smoothSeries,mean(series[(i-2):(i+2)]))
}
smoothSeries=c(smoothSeries,0,0)

plot((1:length(E_g[,1])),ALL_data,col="slategray4",type="h",xlab="",ylab="number of channels",main=TIT,xaxt="n",ylim=c(0,22),cex.lab=0.7,cex.axis=0.7)

possibleMidnightIndices=which(V_g$V13 == "00")		
midnightIndices=possibleMidnightIndices[which(V_g$V14[possibleMidnightIndices]=="14")]
if (length(midnightIndices)){
	for (i in 1:length(midnightIndices)){
    	lines(c(midnightIndices[i]-1,midnightIndices[i]-1),c(0,30),lty=3,col='red')
    }		
	axis(1,midnightIndices-1,V_g$V12[midnightIndices],las=2,cex.axis=0.6)		
}

#points(events*7,ALL_data[events],col='limegreen',cex=1,pch=20)
#points(ads*7,ALL_data[ads],col='firebrick4',cex=1,pch=20)

dev.off()
