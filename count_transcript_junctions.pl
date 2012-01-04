#!/usr/bin/perl
## Author: Lei Sun
## Date: 09/12/2011

## Goal - To count spliced reads at each splicing site of candidate_isoforms.gtf
## Input - ARGV[0] junctions_spliced.count
## 		 - ARGV[1] candidate_isoforms.gtf
## Output - transcripts_junctions.counts

use strict;
require "parse_gtf_line.pl";

open(JUNCTION, $ARGV[0]) || die "Could not read from argv[0], program halting.";
my %junctions;
my $line_count=0;
while(my $current_line=<JUNCTION>){
	chomp($current_line);
    $line_count++;
    
    # split current line
	my @fields_line = split("\t", $current_line);
	
	my $junction_str = $fields_line[0]."-".$fields_line[1]."-".$fields_line[2];
	
	if(!exists $junctions{$junction_str})
	{
		$junctions{$junction_str} = $fields_line[3];
	}
}
close(JUNCTION);

# summary splice reads for each transcript
open(GTF, $ARGV[1]) || die "Could not read from argv[1], program halting.";
$line_count=0;
my %transcripts;
my @transcript_junctions;
my $old_transcript;
my $num = 0;
my $p_line;
while(my $current_line=<GTF>){
	chomp($current_line);
    $line_count++;
    
    $p_line = parse_gtf_line(\$current_line);
    
    if($line_count == 1)
    {
    	$transcript_junctions[0] = $$p_line->getChr."-".$$p_line->getEnd;
    	$transcripts{$$p_line->getTransId} = 1;
    	$old_transcript = $$p_line->getTransId;
    	$num = 0;
    	next;
    }
    
    if(exists $transcripts{$$p_line->getTransId})
    {
    	$transcript_junctions[$num] = $transcript_junctions[$num]."-".$$p_line->getStart;
    	$transcript_junctions[$num + 1] = $$p_line->getChr."-".$$p_line->getEnd;
    	$num ++;
    }
    else
    {
    	print_junctions();
    	$transcript_junctions[0] = $$p_line->getChr."-".$$p_line->getEnd;
    	$transcripts{$$p_line->getTransId} = 1;
    	$old_transcript = $$p_line->getTransId;
    	$num = 0;
    }
}
close(GTF);

print_junctions();

sub print_junctions
{
	print $old_transcript, "\t";
	for(my $i=0; $i< $num; $i++)
	{
		print $junctions{$transcript_junctions[$i]}, ";";
	}
	print "\n";
}