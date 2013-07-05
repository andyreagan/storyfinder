#!/usr/bin/perl
  use strict;
  use warnings;

# collect user input

my $date=$ARGV[0];
my $time=$ARGV[1];
my $minute=$ARGV[2];
my $outfile="\/users\/storyfinder\/code\/R\/run_storyFinder\.R";

open(OUTFILE,'>',$outfile);
print OUTFILE "source\(\"\/users\/storyfinder\/code\/R\/storyFinder_newDiffs\.R\"\)"."\n";
print OUTFILE "storyFinder\(0\,\"".$date."\"\,\"".$time."\"\,\"".$minute."\"\)"."\n";
close(OUTFILE);
