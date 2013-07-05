#!/usr/bin/perl
  use strict;
  use warnings;


# collect user input
my $text1=$ARGV[0];
my $text2=$ARGV[1];
my $outfile=$ARGV[2];

# initializations
my $newline="\n";
my $colon="\:";
my $comma="\,";
my $star="\*";
my $quote="\"";
my $line;
my $rank=1;
my $INPUT;
my %data;
my $phrase;

open $INPUT,'<',$text1;
while ($line=<$INPUT>){
    if ($line=~m/(.*?)$comma$quote(.*?)$quote$comma(.*?)$newline/gi){	
	$phrase=$2;
	@{$data{$phrase}}=($1,$quote.$phrase.$quote,$3);
    }
}
close $INPUT;

open $INPUT,'<',$text2;
while ($line=<$INPUT>){
    if ($line=~m/(.*?)$comma$quote(.*?)$quote$comma(.*?)$newline/gi){	
	$phrase=$2;
	if (defined $data{$phrase}){
	    ${$data{$phrase}}[2]+=$3;
	}
	else{
	    @{$data{$phrase}}=($1,$quote.$2.$quote,$3);
	}
	
    }
}
close $INPUT;

open(OUTFILE,'>',$outfile);
foreach $phrase (reverse sort {${$data{$a}}[2] <=> ${$data{$b}}[2]} keys %data){
    print OUTFILE join($comma,@{$data{$phrase}}).$newline;
}
close(OUTFILE)
