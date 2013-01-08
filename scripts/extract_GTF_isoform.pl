#!/usr/bin/perl
## Author: Lei Sun
## Date: 08/12/2011
## Email: leisuncumt@yahoo.com

## Goal - To extract transcripts of a GTF according to a transcript ids
## Input - ARGV[0] GTF
## 		   ARGV[1] candidate_isoforms_list

use strict;
use warnings;
require "parse_gtf_line.pl";

# create a hash storing classcodes.
my %class;

open(CLASS, $ARGV[1]) || die "Could not read from argv[0], program halting.";
while(my $current_line=<CLASS>){
	chomp($current_line);
    
    # split current line
	my @fields_line = split("\t", $current_line);
    
    if(!exists $class{$fields_line[0]})
    {
    	$class{$fields_line[0]} = 1;
    }
}
close(CLASS);

# extract according to the classcode hash
my %trans_id;

open(GTF, $ARGV[0]) || die "Could not read from argv[0], program halting.";
my $line_count=0;

while(my $current_line=<GTF>){
	chomp($current_line);
	$line_count++;
	
	my $p_line = parse_gtf_line(\$current_line);
	
	if(exists $class{$$p_line->getTransId()})
	{
		print $current_line, "\n";
	}
}
close (GTF);