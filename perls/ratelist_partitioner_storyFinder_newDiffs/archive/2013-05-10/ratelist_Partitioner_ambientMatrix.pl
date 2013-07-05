#!/usr/bin/perl
  use strict;
  use warnings;

# collect user input

my $text=$ARGV[0]; # filepath of the text to partition
my $outroot=$ARGV[1]; # the handle for output files
my $N=1; # only looking at words here...
my $MTFILE=$ARGV[2];


# run scripts below

system("perl text2clauses\.pl \"".$text."\" \"".$outroot."\_clauses\.csv\"");
system("perl clauses2ratelist\.pl \"".$outroot."\_clauses\.csv\" \"".$outroot."\_full\.csv\" ".$N);
system("perl partitionclauses\_ratelist\_keepClause\.pl \"".$outroot."\_full\.csv\" \"".$outroot."\_clauses\.csv\" \"".$outroot."\_rawPartition\.txt\" \"".$outroot."\_counted\.csv\"");
system("perl ambientMatrix\.pl \"".$outroot."\_rawPartition\.txt\" \"".$MTFILE."\" \"".$outroot."\_ambientMatrix\.csv\" \"".$outroot."\_ambientList\.csv\"");
