#!/usr/bin/perl
## Author: Lei Sun
## Date: 15/12/2011

## Goal - To filter transcripts of a GTF annotated by cuffcompare according to transcript ids if they exist
## Input - ARGV[0] GTF annotated by cuffcompare
## 		   ARGV[1] low_lncRNA_list

use strict;
use warnings;
require "parse_gtf_line.pl";

# create a hash storing isoforms.
my %isoform;

open(ISOFORM, $ARGV[1]) || die "Could not read from argv[0], program halting.";
while(my $current_line=<ISOFORM>){
	chomp($current_line);
    
    if(!exists $isoform{$current_line})
    {
    	$isoform{$current_line} = 1;
    }
}

close(ISOFORM);

# extract according to the isoform hash
open(GTF, $ARGV[0]) || die "Could not read from argv[0], program halting.";
my $line_count=0;

while(my $current_line=<GTF>){
	chomp($current_line);
	$line_count++;
	
	my $p_line = parse_gtf_line(\$current_line);
	
	if(! exists $isoform{$$p_line->getTransId()})
	{
		print $current_line, "\n";
	}
}

close (GTF);