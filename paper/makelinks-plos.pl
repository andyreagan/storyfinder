#!/usr/bin/perl
# make links into package-plos directory
$usage = "
usage: makelinks.pl foo-combined.tex
(works for any latex file)

use after make-single-latex-file.pl

copies foo-combined.tex to ./package-plos
and replaces figure names by fig01, fig02, etc.

see end of file for localized pieces
";

# number of figures in the main file
$nummainfigs = 5;


if ($#ARGV < 0)
{
    print $usage;
    exit;
}

$file = $ARGV[0];

unless (-e $file)
{
    print $usage;
    exit;
}

# clean out the package-plos directory
# `\\rm package-plos/*`;

# find figures

$outfile = "package-plos/$file";
open (FILE,$file) or die "can't open $file: $!\n";
open (OUTFILE,">$outfile") or die "can't open $outfile: $!\n";

$i = 1;
$Sprefix = "";
foreach $line (<FILE>)
{
#    unless ($line =~ m/\s*%/) {
	if ($line =~ m/\\includegraphics\[.*?\]\{(.*?)\}/) {
	    print "$i: $line";
	    push @figures, $1;

	    if ($i<10) {$fignum = "0$i";} else {$fignum = $i;}
#    $prefix = "fig".$Sprefix.$fignum."_";
#    print $line;
#    $line =~ s/(\\includegraphics.*?)\{(.*?)\}/$1\{$prefix$2\}/;
	    $prefix = "fig".$Sprefix.$fignum;
	    $line =~ s/(\\includegraphics.*?)\{(.*?)\}/$1\{$prefix.tiff\}/;
	    $i = $i + 1;
	    if (($i = ($nummainfigs+1) ) and ($Sprefix eq "")) {
		$i = 1;
		$Sprefix = "S";
	    }
	}
#    }
    print OUTFILE $line;
}

close FILE;
close OUTFILE;

foreach $i (0..$#figures)
{
    $figure = $figures[$i];
    $tmp = `find . -follow -name $figure -print 2>/dev/null`;
    @tmp = split("\n",$tmp);
    $fullfigures[$i] = $tmp[0];
    chomp($fullfigures[$i]);
}

$i=1;
foreach $fullfigure (@fullfigures)
{
    ($figname = $fullfigure) =~ s/.*\///;
    if ($i<10) {
	$fignum = "0$i";
    } 
    else 
{$fignum = $i;}
if ($i>$nummainfigs) {
    $j = $i-$nummainfigs;
    if ($j < 10) {$j = "0$j";}
    $fignum = "S$j";
}
# $prefix = "fig".$fignum."_";
$prefix = "fig".$fignum.".eps";
`cp $fullfigure package-plos/$prefix`;
`ln -s ../$fullfigure package-plos/.`;
    $i = $i+1;
}
