#!/usr/bin/perl
## Author: Lei Sun
## Date: 18/12/2011

## Goal - To extract bam according to locus
## Input - ARGV[0] cuffcmp.loci
##		 - ARGV[1] candidate_list, according to which extract bam
## 		 - ARGV[2] all.BAM
## Output - novel_gene.sam

use strict;

open(LOCI, $ARGV[0]) || die "Could not read from argv[0], program halting.";
my %gene;
my $line_count=0;
while(my $current_line=<LOCI>){
	chomp($current_line);
    $line_count++;
    
    # split current line
	my @fields_line = split("\t", $current_line);
	
	if(!exists $gene{$fields_line[0]})
	{
		my @loci = split(/\[[+-]\]/, $fields_line[1]);
		$gene{$fields_line[0]} = $loci[0].":".$loci[1];
		#print $fields_line[0], "\t", $gene{$fields_line[0]}, "\n";
	}
	#if($line_count == 6){exit;}
}
close(LOCI);

open(CAN, $ARGV[1]) || die "Could not read from argv[1], program halting.";
my %candidate_gene;
$line_count=0;
while(my $current_line=<CAN>)
{
	chomp($current_line);
    $line_count++;
    
    my @fields_line = split("\t", $current_line);
    if(!exists $candidate_gene{$fields_line[1]})
	{
		system("samtools view $ARGV[2] $gene{$fields_line[1]}");
		$candidate_gene{$fields_line[1]} = 1;
	}
}

close(CAN);
