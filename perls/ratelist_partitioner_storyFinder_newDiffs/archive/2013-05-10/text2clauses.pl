#!/usr/bin/perl
  use strict;
  use warnings;

# collect user input
my $file=$ARGV[0]; # filepath of the text
my $outfile=$ARGV[1]; # output file path

# initializations
my $space=" ";
my $newline="\n";
my $colon=":";
my $comma="\,";
my $quote="\"";
my $sequence;
my %data;
my $order;
my $line;
my $count=0;
my @terms;
my $term;
my @dataline;
my $old;
my $new;
my $i;

open my $corpus,'<',$file;

# clean up the text and print out the clauses  (((\@|\#)?[a-z]+((\'|\-)[a-z]+)*\'?\s?){1,50})
while ($line=<$corpus>){

    $line =~ s/\&gt//gi;
    $line =~ s/\&lt//gi;
    $line =~ s/\&amp//gi;
    
    if (!(($line =~ m/more for aries/gi) || ($line =~ m/more for taurus/gi) || ($line =~ m/more for gemini/gi) || ($line =~ m/more for cancer/gi) || ($line =~ m/more for leo/gi) || ($line =~ m/more for virgo/gi) || ($line =~ m/more for libra/gi) || ($line =~ m/more for scorpio/gi) || ($line =~ m/more for sagittarius/gi) || ($line =~ m/more for capricorn/gi) || ($line =~ m/more for aquarius/gi) || ($line =~ m/more for pisces/gi) || ($line =~ m/4sq\.com/gi) || ($line =~ m/extra watering cans after harvesting/gi) || ($line =~ m/\@questionnnierr/gi) || ($line =~ m/ rt \@/gi) || ($line =~ m/^rt \@/gi)  )){
	
	@terms=split($space,$line);
	for ($i=0;$i<scalar(@terms);$i++){
            $term=$terms[$i];
            if (($term =~ m/http\:/gi) || ($term =~ m/\.com/gi) || ($term =~ m/\.en/gi) || ($term =~ m/\.jp/gi) || ($term =~ m/\.fr/gi) || ($term =~ m/\.ly/gi) || ($term =~ m/\.net/gi) || ($term =~ m/\.org/gi) || ($term =~ m/www\./gi) || ($term =~ m/tinyurl/gi) || ($term =~ m/\.co/gi) || ($term =~ m/\.uk/gi) || ($term =~ m/\.us/gi) || ($term =~ m/\.fm/gi) || ($term =~ m/\.de/gi) || ($term =~ m/\.eu/gi) || ($term =~ m/\.ca/gi) || ($term =~ m/\.br/gi) || ($term =~ m/\.au/gi) || ($term =~ m/\.in/gi) || ($term =~ m/\.it/gi) || ($term =~ m/\.es/gi) || ($term =~ m/\.hk/gi) || ($term =~ m/\.ru/gi) || ($term =~ m/\.nl/gi)){
                $terms[$i]="http";
            }
	}
	$line=join($space,@terms);
	while ($line =~ m/(((\@|\#)?[a-z]+((\'|\-)[a-z]+)*\'?\s?){1,50})/gi){
	    $sequence = lc($1);	    
	    $sequence =~ s/^[\s]+//g;
	    $sequence =~ s/[\s]+$//g;
	    $sequence =~ s/[\s]+/$space/g;
	    
	    $sequence =~ s/\n//g;
	    $sequence = $quote.$sequence.$quote;
	    @terms=split($space,$sequence);
	    $order=scalar(@terms);
	    
	    if (defined $data{$sequence}){
		@dataline=@{$data{$sequence}};
		$dataline[1]++;
		@{$data{$sequence}}=@dataline;
	    }
	    else{
		$dataline[0]=$order;
		$dataline[1]=1;
		@{$data{$sequence}}=@dataline;
	    }	
	}
    }
}
close $corpus;

# print the clauses out
open(OUTFILE,'>',$outfile);
for(keys %data){
    $sequence=$_;
    @dataline=@{$data{$sequence}};
    print OUTFILE join($comma,@dataline).$comma.$sequence.$newline;
}
close(OUTFILE);
