#!/usr/bin/perl
## Author: Lei Sun
## Date: 30/11/2011

## Goal - To list coordinates of spliced junctions
## Input - ARGV[0] SAM

use strict;
use warnings;

require "share.pl";

# open input SAM file
open(SAM, $ARGV[0]) || die "Could not read from argv[0], program halting.";
my $line_count=0;
my $count_spliced=0;
my @fields_line;
while(my $current_line=<SAM>){
    $line_count++;
	# point to coordinates array
	my $p;
	
	# split current line
	@fields_line = split("\t", $current_line);
	
	# if it is a spliced read
	if(index($fields_line[5], 'N') >= 0)
	{
		$p = get_borders_CIGAR($fields_line[3], $fields_line[5]);
		print_junctions($p);
	}
	
	#if($count_spliced == 3){last;}
}
close(SAM);

sub print_junctions
{
	my $p = shift;
	for(my $i=1; $i<scalar(@$p)-1; $i=$i+4)
	{
		print $fields_line[2], "\t", $$p[$i], "\t", $$p[$i+3], "\n";
	}
}