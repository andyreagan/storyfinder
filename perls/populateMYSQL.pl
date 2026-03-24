#!/opt/bin/perl -w
use strict;
use warnings;

use DBI;
use DBD::mysql; 

my $user= "mrfrank";
my $pass="REDACTED_PASSWORD";
my $dbh = DBI->connect("DBI:mysql:MRFRANK_13:REDACTED_DBHOST:mysql_local_infile=1", $user, $pass); 
my @row;
my $query; 
my $sth; 

$query="LOAD DATA LOCAL INFILE '/users/storyfinder/data/tmp_geo.csv' INTO TABLE tblTweetCity FIELDS TERMINATED BY '\,' ENCLOSED BY '\"' LINES TERMINATED BY '\n' (fkTweetID,fkCity);";
$sth = $dbh->do($query) or die "THIS DID NOT WORK";

