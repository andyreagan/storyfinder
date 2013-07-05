#!/usr/bin/perl
use strict;
use warnings;


# collect user input
my $geoFile=$ARGV[0];
my $labMTFile=$ARGV[1];
my $MATOUT=$ARGV[2];
my $LISTOUT=$ARGV[3];

# initializations
my $newline="\n";
my $colon="\:";
my $comma="\,";
my $space=" ";
my $tab="\t";
my $quote="\"";
my $star="\*";
my $semicolon="\;";
my $line;
my $phrase;
my $word;
my %labMTHash;
my %phraseHash;
my $labMTScore;
my $numWords;
my @labInfo;
my $index; 
my $val;
my $SD;
my @lineInfo;
my $count;
my $clause;
my @words;
my $totalCount;
my $length;
my $order;
my $freq;
my $phraseVal;
my $MTCOUNT;
my $index=0;
my %indices;
my $MTdex;
my @ambientMatrix;
my @blankArray;
my $rowDex;
my $colDex;
my @MTwords;

open my $labFile,'<', $labMTFile;
while($line =<$labFile>){
    @labInfo = split(/\t/,$line);
    $word = $quote.$labInfo[0].$quote;
    $MTdex = $labInfo[1];
    $val = $labInfo[2];    
    $SD = $labInfo[3];
    $index += 1;
    $indices{$word} = $index;
    $MTwords[$index-1] = $word;
    @{$labMTHash{$word}} = ($word,$val,$SD,$MTdex); 
}
close $labFile;

@blankArray= (0) x scalar(keys %indices);

#build matrix
for($index=0;$index<scalar(keys %indices);$index++){
    @{$ambientMatrix[$index]} = @blankArray; 
}

my $replace= " ";
open my $tweetFile,'<',$geoFile;
while ($line=<$tweetFile>){
    @lineInfo = split(/\t/,$line);
    $phrase = $quote.$lineInfo[0].$quote;
    if (defined $indices{$phrase}){
	$rowDex=$indices{$phrase};
	$count = $lineInfo[1];
	$clause = $lineInfo[2];
	$clause =~ s/$phrase/$replace/i;
	$clause =~ s/\;/$replace/gi;
	$clause =~ s/[ ]+/$replace/gi;
	$clause =~ s/^ //gi;
	$clause =~ s/ $//gi;
	@words = split(" ",$clause);	
	foreach $word (@words){
	    $word=$quote.$word.$quote;
	    if (defined $indices{$word}){
		$colDex=$indices{$word};
		${$ambientMatrix[$rowDex]}[$colDex]+=$count;
	    }
	}   
    }
}
close $tweetFile;

open(MATOUT, '>',$MATOUT);
open(LISTOUT,'>',$LISTOUT);
print LISTOUT "phrase\,valence\,SD\,MTIX".$newline;
for($rowDex=0;$rowDex<scalar(keys %indices);$rowDex++){
    print MATOUT join($comma,@{$ambientMatrix[$rowDex]}).$newline;
    print LISTOUT join($comma,@{$labMTHash{$MTwords[$rowDex]}}).$newline
}
close(MATOUT);
close(LISTOUT);
