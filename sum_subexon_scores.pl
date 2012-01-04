#!/usr/bin/perl
## Author: Lei Sun
## Date: 27/10/2011

## Description: to sum scores for each of the assembled transcripts
## Input: $ARGV[0]-subexon.score
## Output: 

use strict;
use warnings;

## create a hash variable to connect transcript_id and its value structure
my %h_trans;
my $count_line=0;

open(SCORE, $ARGV[0]) || die "Could not read from argv[0], program halting.";

## read details from each line of  subexon.score
while(my $current_line=<SCORE>)
{
	chomp($current_line);
	$count_line ++;
    
    # split current line
	my @fields_line = split("\t", $current_line);
	
	my $chr = $fields_line[0];
	my $start = $fields_line[1];
	my $end = $fields_line[2];
	my @trans_line = split(";", $fields_line[3]);
	my $sub_score = $fields_line[4];
	
	## check if one of parsed transcripts exists in current hash table
	foreach(@trans_line)
	{
		if(exists $h_trans{$_})
		{
			if($start == $h_trans{$_}->{last_end} + 1)
			{
				$h_trans{$_}->{scores} = $h_trans{$_}->{scores}.",".$sub_score;
				$h_trans{$_}->{overlap} = $h_trans{$_}->{overlap}.",".scalar(@trans_line);
				$h_trans{$_}->{last_end} = $end;
			}
			else
			{
				$h_trans{$_}->{scores} = $h_trans{$_}->{scores}.";".$sub_score;
				$h_trans{$_}->{overlap} = $h_trans{$_}->{overlap}.";".scalar(@trans_line);
				$h_trans{$_}->{last_end} = $end;
			}
		}
		else
		{
			$h_trans{$_}={scores=>$sub_score, overlap=>scalar(@trans_line), last_end=>$end};
		}
	}
	
	# if($count_line == 6){last;}
}
close (SCORE);

## print %h_trans
while(my ($trans, $struct) = each %h_trans)
{
	print $trans, "\t", $struct->{scores}, "\t", $struct->{overlap}, "\n";
}