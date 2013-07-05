#!/usr/bin/perl
  use strict;
  use warnings;


# collect user input
my $fullloc=$ARGV[0];
my $textloc=$ARGV[1];
my $tempfile=$ARGV[2];
my $outfile=$ARGV[3];

# initializations
my $space=" ";
my $newline="\n";
my $star="\*";
my $colon="\:";
my $tab="\t";
my $semicolon="\;";
my $comma="\,";
my $quote="\"";
my ($line,$clause,$order,$count,$sequence,$neighborhood,$part,@terms,@partition,%rates,%partitiondata,@partitiondataline);

# subroutine to find the next, highest-neighborhood-rate interval ($n_part) in a sequence given a starting index
sub nextinterval{
    my ($sequence,@terms,$bool,$order,$part,$currentrate,$newrate,$startdex,$enddex,$tau);
    $sequence=$_[0];
    $startdex=$_[1];
    $enddex=$startdex;
    @terms=split($space,$sequence);
    $bool=1;
    $order=scalar(@terms);
    $tau=$terms[$startdex];
    $part=$tau;
    if (defined $rates{$tau}){
	$currentrate=$rates{$tau};
    }
    else{
	$currentrate=0;
    }
    while ($bool){
	if ($enddex+1>=$order){
	    $bool=0;
	}
	else{
	    $tau=$tau.$space.$terms[$enddex+1];
	    if (defined $rates{$tau}){
		$newrate=$rates{$tau};
	    }
	    else{
		$newrate=0;
	    }
	    if ($newrate >= $currentrate){
		$part=$tau;
		$currentrate=$newrate;
		$enddex=$enddex+1;
	    }
	    else{
		$bool=0;
	    }
	}
    }
    return ($currentrate,$enddex,$part);
}

# subroutine to find the locally optimal serial partition
sub serialpartition{
    my ($sequence,@terms,$order,$bool,$i,@startindex,$longlrate,$longleft,$longleftpart,$shortlrate,$shortleft,$shortleftpart);
    my (@partition,$shortrrate,$shortright,$shortrightpart,$longrrate,$longright,$longrightpart);
    $sequence=$_[0];
    @terms=split($space,$sequence);
    $order=scalar(@terms);
    $bool=1;
    $i=0;
    $startindex[$i]=0;
    while ($bool){
	($longlrate,$longleft,$longleftpart)=&nextinterval($sequence,$startindex[$i]);
	$partition[$i]=$longleftpart;
	$i++;
	$startindex[$i]=$longleft+1;
	if ($startindex[$i] > $order-1){
	    $bool=0;
	}
    }
    return(@partition);
}

open my $fulldist,'<',$fullloc;
while ($line=<$fulldist>){
    if ($line=~m/$quote(.*?)$quote$comma(.*?)$comma(.*?)$newline/gi){
	$rates{$1}=$2;
    }
}
close $fulldist;

open(OUTFILE, '>',$tempfile);
open my $text,'<',$textloc;
while ($line=<$text>){
    if ($line =~ m/(.*?)$comma(.*?)$comma$quote(.*?)$quote$newline/){
	$order=$1;
	$count=$2;
	$clause=$3;
	@partition=&serialpartition($clause);
	foreach (@partition){
	    $part=$_;
	    @terms=split($space,$part);
	    $order=scalar(@terms);
	    print OUTFILE $part.$tab.$count.$tab.join($semicolon,@partition).$newline;
	    #print OUTFILE $order.$comma.$quote.$part.$quote.$comma.$count.$newline;
	}
    }
}
close $text;
close(OUTFILE);

undef %rates;

#merge the list into a single document
open($text, '<',$tempfile);
while ($line=<$text>){
    if ($line =~ m/(.*?)$tab(.*?)$tab(.*?)$newline/){
	$part=$1;
	$count=$2;
	$order=scalar(split($space,$part));
	if (defined $partitiondata{$part}){
	    ${$partitiondata{$part}}[2]+=$count;
	}
	else{
	    @{$partitiondata{$part}}=($order,$part,$count);
	}
    }
}
close $text;

open(OUTFILE, '>',$outfile);
foreach $part (reverse sort {${$partitiondata{$a}}[2] <=> ${$partitiondata{$b}}[2]} keys %partitiondata){
    print OUTFILE ${$partitiondata{$part}}[0].$comma.$quote.${$partitiondata{$part}}[1].$quote.$comma.${$partitiondata{$part}}[2].$newline;
}
close(OUTFILE);
