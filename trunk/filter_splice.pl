#!/usr/bin/perl
## Author: Lei Sun
## Date: 29/12/2011

## Goal - To filter artefacts according to number of spliced reads
## Input - ARGV[0] transcript_junctions.counts

use strict;
use warnings;

open(SPLICE, $ARGV[0]) || die "Could not read from argv[0], program halting.";
my $line_count;
my $sum;

while(my $current_line=<SPLICE>){
	chomp($current_line);
    $line_count ++;
    $sum = 0;
    
	# split current line
	my @fields_line = split("\t", $current_line);
	
	# get number of spliced read for each junction
	my @splice = split(/;/, $fields_line[1]);
	
	my $junction_num = scalar(@splice);
	
	foreach(@splice)
	{
		$sum = $sum + $_;
	}
	
	# criteira: number of total spliced reads of a transcript should be greater than the number of spliced junctions. 
	if ($sum <= $junction_num)
	{
		print $fields_line[0], "\n";
	}
	
	# if ($line_count == 1){exit;}
}

close(SPLICE);