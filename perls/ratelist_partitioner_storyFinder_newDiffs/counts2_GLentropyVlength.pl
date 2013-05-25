#!/usr/bin/perl
  use strict;
  use warnings;


# collect user input
my $file=$ARGV[0];
my $outfile=$ARGV[1];

# initializations
my $space=" ";
my $newline="\n";
my $star="\*";
my $colon="\:";
my $semicolon="\;";
my $comma="\,";
my $quote="\"";
my $line;
my $order;
my $count;
my $sequence;
my $neighborhood;
my @neighborhoods;
my %fulldata;
my %hoodcounts;
my $i;
my @terms;
my $entropy;
my $hoodscount;
my $totalcount=0;
my $freq;
my $length;

sub log2 {
    my $n = shift;
    return log($n)/log(2);
}

open my $page,'<',$file;
while ($line=<$page>){
    if ($line=~m/(.*?)$comma$quote(.*?)$quote$comma(.*?)$newline/gi){
	$sequence=$2;
	$order=$1;
	$count=$3;
	@terms=split($space,$sequence);
	for ($i=0; $i<$order; $i++){
	    if ($order-1 == 0){
		$neighborhoods[$i]=$star;
	    }
	    if ($i == 0 && $order-1){
		$neighborhoods[$i]=join($space,@terms[$i..$order-2]);
	    }
	    if ($i == $order-1 && $order-1){
		$neighborhoods[$i]=join($space,@terms[1..$i]);
	    }
	    if ($i > 0 && $i < $order-1){
		$neighborhoods[$i]=join($space,@terms[0..$order-($i+2),$order-$i..$order-1]);
	    }
	}
	
	@{$fulldata{$sequence}}=($order,$count,$sequence,join($semicolon,@neighborhoods),0);

	foreach (@neighborhoods){
	    $neighborhood=$_;
	    if (defined $hoodcounts{$neighborhood}){
		$hoodcounts{$neighborhood}=$hoodcounts{$neighborhood}+$count;
	    }
	    else{
		$hoodcounts{$neighborhood}=$count;
	    }
	}	
	undef @neighborhoods;
	my @neighborhoods;
    }
}
close $page;

foreach $sequence (keys %fulldata){
    @neighborhoods=split($semicolon,${$fulldata{$sequence}}[3]);
    $order=${$fulldata{$sequence}}[0];
    $count=${$fulldata{$sequence}}[1];
    $hoodscount=0;
    $totalcount+=$count;
    foreach $neighborhood (@neighborhoods){
	$hoodscount+=$hoodcounts{$neighborhood};
	${$fulldata{$sequence}}[4]-=$hoodcounts{$neighborhood}*&log2($count/$hoodcounts{$neighborhood});
    }
    ${$fulldata{$sequence}}[4]/=$hoodscount;
}

open(OUTFILE,'>',$outfile);
print OUTFILE "phrase\,freq\,ent\,length\,order".$newline;
foreach $sequence (reverse sort { ${$fulldata{$a}}[1]*${$fulldata{$a}}[4]/$totalcount <=> ${$fulldata{$b}}[1]*${$fulldata{$b}}[4]/$totalcount } keys %fulldata){
    $entropy=${$fulldata{$sequence}}[4];
    $freq=${$fulldata{$sequence}}[1]/$totalcount;
    $order=${$fulldata{$sequence}}[0];
    $length=length($sequence)-$order+1;
    $sequence=$quote.$sequence.$quote;
    print OUTFILE join($comma,($sequence,$freq,$entropy,$length,$order)).$newline;
}
close(OUTFILE);
