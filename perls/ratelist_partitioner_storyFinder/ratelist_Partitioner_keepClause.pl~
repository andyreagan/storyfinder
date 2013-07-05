#!/usr/bin/perl
  use strict;
  use warnings;

# collect user input

my $text=$ARGV[0]; # filepath of the text to partition
my $outroot=$ARGV[1]; # the handle for output files
my $N=$ARGV[2]; # the maximum length phrase to partition



# run scripts below

system("perl text2clauses\.pl \"".$text."\" \"".$outroot."\_clauses\.csv\"");
system("perl clauses2ratelist\.pl \"".$outroot."\_clauses\.csv\" \"".$outroot."\_full\.csv\" ".$N);
system("perl partitionclauses\_ratelist\.pl \"".$outroot."\_full\.csv\" \"".$outroot."\_clauses\.csv\" \"".$outroot."\_temp\.csv\" \"".$outroot."\_counted\.csv\"");
system("perl counts2plotDataCSV\.pl \"".$outroot."\_counted\.csv\" \"".$outroot."\_plot\.csv\" ".$N);
