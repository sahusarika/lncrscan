#!/usr/bin/perl
## Author: Lei Sun
## Date: 09/12/2011

## Goal - To count spliced reads at each splicing site of candidate_isoforms.gtf
## Input - ARGV[0] candidate_orf output from longorf.pl
## Output - candidate:orf_length table

open(ORF, $ARGV[0]) || die "Could not read from argv[0], program halting.";
while(my $current_line=<ORF>){
	chomp($current_line);
    
    # split current line
    my @fields_line = split("\t", $current_line);
	my @fields = split("_", $fields_line[0]);
    
    print $fields[4], "_", $fields[5], "\t", $fields_line[1], "\n";
}
close(ORF);