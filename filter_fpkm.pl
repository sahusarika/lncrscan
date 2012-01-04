#!/usr/bin/perl
## Author: Lei Sun
## Date: 29/12/2011

## Goal - To filter artefacts according to local FPKM 
## Input - ARGV[0] transcript.local_fpkm
## 		 - ARGV[1] transcript-classcode table 

use strict;
use warnings;

open(CLASS, $ARGV[1]) || die "Could not read from argv[1], program halting.";
my $line_count;
my %trans_class;
while(my $current_line=<CLASS>){
	chomp($current_line);
    $line_count ++;
    
	# split current line
	my @fields_line = split("\t", $current_line);
	
	if(! exists $trans_class{$fields_line[0]})
	{
		$trans_class{$fields_line[0]} = $fields_line[1];
	}
}

close(CLASS);

# start to check local FPKMs for 
open(FPKM, $ARGV[0]) || die "Could not read from argv[0], program halting.";
# the local FPKM should be at least 0.3
my $fpkm_t = 0.3;
$line_count = 0;

while(my $current_line=<FPKM>){
	chomp($current_line);
    $line_count ++;

	# split current line
	my @fields_line = split("\t", $current_line);
	
	# check if the classcode of the assembly is "="
	if($trans_class{$fields_line[0]} eq "=")
	{
		next;
	}
	
	# parse local FPKM
	my @fpkm = split(/[,;]/, $fields_line[1]);
	
	# parse the overlap field
	my @overlap = split(/[,;]/, $fields_line[2]);
	
	for(my $i=0; $i < scalar(@overlap); $i++)
	{
		# check if the region is  non-overlap
		if($overlap[$i] == 1)
		{
			# check if the local FPKM is lower than the threshold
			if($fpkm[$i] < $fpkm_t)
			{
				print $fields_line[0], "\n";
				last;
			}
		}
	}
}

close(FPKM);

