#!/usr/bin/perl
## Author: Lei Sun
## Date: 21/12/2011

## Goal - 1) To create a hash connecting old transcript ids given by cufflinks and new ids given by cuffcompare 2) Then extract length information for each transcript
## Input - ARGV[0] GTF
## 		   ARGV[1] cuffcmp.all.gtf.tmap

use strict;
use warnings;
require "parse_gtf_line.pl";

# create new-old isoform hash;
my %isoform;
open(GTF, $ARGV[0]) || die "Could not read from argv[0], program halting.";
my $line_count=0;

while(my $current_line=<GTF>){
	chomp($current_line);
	$line_count++;
	
	my $p_line = parse_gtf_line(\$current_line);
	
	if(!exists $isoform{$$p_line->getOldId()})
	{
		$isoform{$$p_line->getOldId()} = $$p_line->getTransId();
	}
}
close (GTF);

# output transcript length
open(TMAP, $ARGV[1]) || die "Could not read from argv[1], program halting.";
$line_count=0;

while(my $current_line=<TMAP>){
	chomp($current_line);
	$line_count++;
	
	if($line_count == 1){next;};
	
	# split current line
	my @fields_line = split("\t", $current_line);
	
	if(exists $isoform{$fields_line[4]})
	{
		print $isoform{$fields_line[4]}, "\t", $fields_line[10], "\n";
	}
}
close (TMAP);

