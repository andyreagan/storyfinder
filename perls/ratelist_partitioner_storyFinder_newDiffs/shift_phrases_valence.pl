#!/usr/bin/perl
  use strict;
  use warnings;

# collect user input

#this program shifts against a text that already exists

my $refValenceText=$ARGV[0];
my $compValenceText=$ARGV[1];
my $outroot=$ARGV[2];
my $N=10;

my $outfile=$outroot."\_valence\_shift\.csv";
my $compAveValenceout=$outroot."\_aveVal\.txt";

my @folders=split("\/",$outroot);
my $time=$folders[scalar(@folders)-1];
my $date=$folders[scalar(@folders)-2];
my @crap=split("",$time);
$time=join("",@crap[0..1]);
my $minute=join("",@crap[3..4]);

my $space=" ";
my $comma="\,";
my $quote="\"";
my $newline="\n";
my $phrase;
my $count;
my $length;
my $order;
my $valence;
my %compValence;
$N+=1;
my @aveCompVal = (0) x $N;
my @aveRefVal = (0) x $N;
my $indexComp;
my $indexRef;
my $indexAveRefG;
my $indexAveRefL;
my $pCompG;
my $pCompL;
my $pRefG;
my $pRefL;
my $line;
my $i;
my @refCount = (0) x $N;
my @compCount = (0) x $N;

open(INFILE,'<',$refValenceText);
while ($line = <INFILE>){
    if ($line =~m/$quote(.*?)$quote$comma(.*?)$comma(.*?)$comma(.*?)$comma(.*?)$newline/gi){
        $phrase=$1;
        $count=$2;
        $valence=$3;
        $length=$4;
        $order=$5;
	
	$refCount[0]+=$count;
	$refCount[$order]+=$count;
	$aveRefVal[0]+=$count*$valence;
	$aveRefVal[$order]+=$count*$valence;
	
	@{$compValence{$phrase}}=(0,$valence,0,0,0,$count);
    }
}
close(INFILE);
for($i=0;$i<=10;$i++){
    if ($refCount[$i]){
	$aveRefVal[$i]/=$refCount[$i];
    }
    else{
	$aveRefVal[$i]=0;
    }
}

open(INFILE,'<',$compValenceText);
while ($line = <INFILE>){
    if ($line =~m/$quote(.*?)$quote$comma(.*?)$comma(.*?)$comma(.*?)$comma(.*?)$newline/gi){
	$phrase=$1;
	$count=$2;
	$valence=$3;
	$length=$4;
	$order=$5;
	
	$compCount[0]+=$count;
	$compCount[$order]+=$count;
	$aveCompVal[0]+=$count*$valence;
	$aveCompVal[$order]+=$count*$valence;

	if (defined $compValence{$phrase}){
	    ${$compValence{$phrase}}[0]=$valence;
	    ${$compValence{$phrase}}[4]=$count;
	}
	else{
	    @{$compValence{$phrase}}=($valence,0,0,0,$count,0);
	}
	if ($valence > $aveRefVal[0]){
	    ${$compValence{$phrase}}[2]=1;
	}
	if ($valence > $aveRefVal[$order]){
	    ${$compValence{$phrase}}[3]=1;
	}
    }
}
close(INFILE);
for($i=0;$i<=10;$i++){
    if ($compCount[$i]){
	$aveCompVal[$i]/=$compCount[$i];
    }
    else{
	$aveCompVal[$i]=0;
    }
}


# determine the shifts and print out
open(OUTFILE,'>',$outfile);
print OUTFILE "phrase\,order\,indexComp\,indexRef\,indexAveRefG\,indexAveRefL\,pCompG\,pCompL\,pRefG\,pRefL".$newline;
foreach $phrase (keys %compValence){
    $order = scalar(split($space,$phrase));
    $indexComp = ${$compValence{$phrase}}[0];
    $indexRef = ${$compValence{$phrase}}[1];
    $indexAveRefL = $aveRefVal[$order];
    $indexAveRefG = $aveRefVal[0];
    if ($compCount[0]){
	$pCompG = ${$compValence{$phrase}}[4] / $compCount[0];
    }
    else{
	$pCompG = 0;
    }
    if ($refCount[0]){
	$pRefG = ${$compValence{$phrase}}[5] / $refCount[0];
    }
    else{
	$pRefG = 0;
    }

    if ($compCount[$order]){
	$pCompL = ${$compValence{$phrase}}[4] / $compCount[$order];
    }
    else{
        $pCompL = 0;
    }
    if ($refCount[$order]){
	$pRefL = ${$compValence{$phrase}}[5] / $refCount[$order];
    }
    else{
        $pRefL = 0;
    }  

    $phrase=$quote.$phrase.$quote;
    
    print OUTFILE $phrase.$comma.$order.$comma.$indexComp.$comma.$indexRef.$comma.$indexAveRefG.$comma.$indexAveRefL.$comma.$pCompG.$comma.$pCompL.$comma.$pRefG.$comma.$pRefL.$newline;

}
close(OUTFILE);

open(OUTFILE,'>',$compAveValenceout);
print OUTFILE join($comma,@aveCompVal).$comma.$quote.$date.$quote.$comma.$quote.$time.$quote.$comma.$quote.$minute.$quote.$newline;
close(OUTFILE);
