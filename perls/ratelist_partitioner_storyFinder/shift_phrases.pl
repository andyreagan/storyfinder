#!/usr/bin/perl
  use strict;
  use warnings;

# collect user input

#this program shifts against a text that already exists

my $refEntropyText=$ARGV[0];
my $compEntropyText=$ARGV[1];
my $outroot=$ARGV[2];
my $N=10;

my $outfile=$outroot."\_entropy\_shift\.csv";
my $compAveEntropyout=$outroot."\_aveEnt\.txt";

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
my $freq;
my $length;
my $order;
my $entropy;
$N+=1;
my @aveRefEnt = (0) x $N;
my @aveCompEnt = (0) x $N;
my %compEntropy;
my $shiftCompG;
my $shiftCompL;
my $shiftRefG;
my $shiftRefL;
my $pCompG;
my $pCompL;
my $pRefG;
my $pRefL;
my $line;
my $i;
my @refFreq = (0) x $N;
my @compFreq = (0) x $N;

open(INFILE,'<',$refEntropyText);
while ($line = <INFILE>){
    if ($line =~m/$quote(.*?)$quote$comma(.*?)$comma(.*?)$comma(.*?)$comma(.*?)$newline/gi){
        $phrase=$1;
        $freq=$2;
        $entropy=$3;
        $length=$4;
        $order=$5;
	
	$refFreq[0]+=$freq;
	$refFreq[$order]+=$freq;
	$aveRefEnt[0]+=$freq*$entropy;
	$aveRefEnt[$order]+=$freq*$entropy;
	
	@{$compEntropy{$phrase}}=(0,$entropy,0,0,0,$freq);
    }
}
close(INFILE);
for($i=0;$i<=10;$i++){
    if ($refFreq[$i]){
	$aveRefEnt[$i]/=$refFreq[$i];
    }
    else{
	$aveRefEnt[$i]=0;
    }
}

open(INFILE,'<',$compEntropyText);
while ($line = <INFILE>){
    if ($line =~m/$quote(.*?)$quote$comma(.*?)$comma(.*?)$comma(.*?)$comma(.*?)$newline/gi){
	
	$phrase=$1;
	$freq=$2;
	$entropy=$3;
	$length=$4;
	$order=$5;
	
	$compFreq[0]+=$freq;
	$compFreq[$order]+=$freq;
	$aveCompEnt[0]+=$freq*$entropy;	
	$aveCompEnt[$order]+=$freq*$entropy;	
	
	if (defined $compEntropy{$phrase}){
	    ${$compEntropy{$phrase}}[0]=$entropy;
	    ${$compEntropy{$phrase}}[4]=$freq;
	}
	else{
	    @{$compEntropy{$phrase}}=($entropy,0,0,0,$freq,0);
	}
	if ($entropy > $aveRefEnt[0]){
	    ${$compEntropy{$phrase}}[2]=1;
	}
	if ($entropy > $aveRefEnt[$order]){
	    ${$compEntropy{$phrase}}[3]=1;
	}
    }
}
close(INFILE);
for($i=0;$i<=10;$i++){
    if ($compFreq[$i]){
	$aveCompEnt[$i]/=$compFreq[$i];
    }
    else{
	$aveCompEnt[$i]=0;
    }
}

open(OUTFILE,'>',$outfile);
print OUTFILE "phrase\,order\,shiftCompG\,shiftCompL\,shiftRefG\,shiftRefL\,pCompG\,pCompL\,pRefG\,pRefL".$newline;
foreach $phrase (keys %compEntropy){
    
    $shiftCompG = ${$compEntropy{$phrase}}[0] - $aveRefEnt[0];
    $pCompG = ${$compEntropy{$phrase}}[4];
    $shiftRefG = ${$compEntropy{$phrase}}[1] - $aveRefEnt[0];
    $pRefG = ${$compEntropy{$phrase}}[5];
    $order = scalar(split($space,$phrase));

    if ($compFreq[$order]){
	$shiftCompL = ${$compEntropy{$phrase}}[0] - $aveRefEnt[$order];
	$pCompL = ${$compEntropy{$phrase}}[4] / $compFreq[$order];
    }
    else{
	$shiftCompL = ${$compEntropy{$phrase}}[0] - $aveRefEnt[$order];
        $pCompL = 0;
    }
    if ($refFreq[$order]){
	$shiftRefL = ${$compEntropy{$phrase}}[1] - $aveRefEnt[$order];
	$pRefL = ${$compEntropy{$phrase}}[5] / $refFreq[$order];
    }
    else{
	$shiftRefL = ${$compEntropy{$phrase}}[1] - $aveRefEnt[$order];
        $pRefL = 0;
    }    
    
    $phrase = $quote.$phrase.$quote;

    print OUTFILE $phrase.$comma.$order.$comma.$shiftCompG.$comma.$shiftCompL.$comma.$shiftRefG.$comma.$shiftRefL.$comma.$pCompG.$comma.$pCompL.$comma.$pRefG.$comma.$pRefL.$newline;

}
close(OUTFILE);

open(OUTFILE,'>',$compAveEntropyout);
print OUTFILE join($comma,@aveCompEnt).$comma.$quote.$date.$quote.$comma.$quote.$time.$quote.$comma.$quote.$minute.$quote.$newline;
close(OUTFILE);
