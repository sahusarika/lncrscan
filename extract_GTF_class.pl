#!/usr/bin/perl
## Author: Lei Sun
## Date: 28/12/2011

## Goal - To  extract transcripts of a GTF annotated by cuffcompare according to classcodes if they exist
## Input - ARGV[0] GTF annotated by cuffcompare
## 		   ARGV[1] classcode_list

use strict;
use warnings;
require "parse_gtf_line.pl";

# create a hash storing classcodes.
my %class;

open(CLASS, $ARGV[1]) || die "Could not read from argv[0], program halting.";
while(my $current_line=<CLASS>){
	chomp($current_line);
    
    if(!exists $class{$current_line})
    {
    	$class{$current_line} = 1;
    }
}

close(CLASS);

# extract according to the classcode hash
my %trans_id;

open(OUT_1, ">", "extracted.gtf") or die "cannot open > extracted.gtf: $!";
#open(OUT_2, ">", "left.gtf") or die "cannot open > left.gtf: $!";
open(OUT_ID, ">", "extracted_id") or die "cannot open > extracted_id: $!";

open(GTF, $ARGV[0]) || die "Could not read from argv[0], program halting.";
my $line_count=0;

while(my $current_line=<GTF>){
	chomp($current_line);
	$line_count++;
	
	my $p_line = parse_gtf_line(\$current_line);
	
	if(exists $class{$$p_line->getClass()})
	{
		print OUT_1 $current_line, "\n";
		
		my $id = $$p_line->getTransId();
		if(!exists $trans_id{$id})
		{
			print OUT_ID $id, "\t", $$p_line->getGeneId(), "\n";
			$trans_id{$id} = 1;
		}
	}
	#else
	#{
		#print OUT_2 $current_line, "\n";
	#}
}

close (GTF);
close (OUT_1);
#close (OUT_2);
close (OUT_ID);