#!/usr/bin/perl -w
## Author: Lei Sun
## Date: 20/08/2012

## Goal - To extract rows according to a list of ids
## Input - 1) transcript_ids.list
##		   2) bed
## Output - 1) rows containing the id

use strict;

open(LIST, $ARGV[0]) || die "Could not read from argv[0], program halting.";
my %IDS;
my $line_count=0;
while(my $current_line=<LIST>){
    chomp($current_line);
    $line_count++;
    
    my @fields_line = split(/\t/, $current_line);
    
    if(!exists $IDS{$fields_line[0]})
    {
        $IDS{$fields_line[0]} = 1;
    }
}
close(LIST);

open(BED, $ARGV[1]) || die "Could not read from argv[1], program halting.";
$line_count=0;
while(my $current_line=<BED>){
    chomp($current_line);
    $line_count++;
    
    my @fields_line = split(/\t/, $current_line);

    if(exists $IDS{$fields_line[3]})
    {
        print $current_line, "\n";
    }
}
close(BED);