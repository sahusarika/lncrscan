#!/usr/bin/perl
## Author: Lei Sun
## Date: 20/11/2011

## Goal - To count number of spliced read over junctions
## Input - ARGV[0] junctions_chr4.position.sorted

use strict;
use warnings;

# open input junction file
open(JUNCTIONS, $ARGV[0]) || die "Could not read from argv[0], program halting.";
my $line_count = 0;
my $chr;
my $index;
my $num = 0;
while(my $current_line=<JUNCTIONS>){
    $line_count++;
	chomp($current_line);
	# split current line
	my @fields_line = split("\t", $current_line);
	
	if($line_count == 1)
	{
		$index = $fields_line[1];
		$chr = $fields_line[0];
		$num ++;
		next;
	}
	
	if($fields_line[1] == $index)
	{
		$num ++;
	}
	else
	{
		print $chr, "\t", $index, "\t", $num, "\n";
		$index = $fields_line[1];
		$chr = $fields_line[0];
		$num = 1;
	}
}
close(JUNCTIONS);

print $chr, "\t", $index, "\t", $num, "\n";