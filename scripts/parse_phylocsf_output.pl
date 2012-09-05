#!/usr/bin/perl
## Author: Lei Sun
## Date: 12/04/2012

## Goal - Get noncoding transcripts by parsing test results of PhyloCSF, based on the set of FASTA alignments
## Input - 1) phylocsf.output
## Output - list of ncRNAs

use strict;
use Switch;

my $line_count=0;
open(CSF, $ARGV[0]) || die "Could not read from argv[0], program halting.";
while(my $current_line=<CSF>){
	chomp($current_line);
    $line_count++;
    
    # split current line
	my @fields_line = split("\t", $current_line);
	
	switch($fields_line[1])
	{
		case "abort"
		{
			next;
		}
		case "decibans"
		{
			if($fields_line[2] <= 0)
			{
				my $id = get_id(\$fields_line[0]);
				print_out($id);
			}
		}
		case "failure"
		{
			my $id = get_id(\$fields_line[0]);
			print_out($id);
		}
	} 
}
close(CSF);

sub get_id{
	my $p_string = shift;
	
	my @str = split(/\//, $$p_string);
	
	return $str[2];
}

sub print_out{
	my $id = shift;
	
	print $id, "\n";
}