#!/usr/bin/perl
## Author: Lei Sun
## Date: 24/10/2011
 
## Description: give a score to each of overlapped exons
## Input: $ARGV[0]-exon.overlap
##		  $ARGV[1]-s_6.bam
## Output: overlapped exons as well as scores

use strict;
use warnings;
use Subexon;

require "share.pl";

## variables for $overlap that is the overlap we are researching on
## $former_overlap and $latter_overlap the $overlap is compared to
my $p_former_overlap;
my $p_latter_overlap;
my $p_overlap;
my @fields_line;
my $num_reads = 0;

my $depth;

# read coverage.depth
open(DEPTH, $ARGV[2]) || die "Could not read from argv[1], program halting.";
while(my $current_line=<DEPTH>){
		$depth = $current_line;
		last;
}
close (DEPTH);


## scan exon.overlap line by line 
open(OVERLAP, $ARGV[0]) || die "Could not read from argv[0], program halting.";
my $line_count=0;
my $flag = -1;
my $p_flag;
my $current_line;
while($current_line=<OVERLAP>){
    chomp($current_line);
    $line_count++;
    
	# split current line
	@fields_line = split("	", $current_line);

	if($line_count == 1)
	{
=cut
		if($fields_line[3] > 1)
		{
			$flag = -1;
		}
		elsif($fields_line[3] == 1)
		{
			$flag = 1;
		}
=cut
		## wait for being processed in the next round
		$p_former_overlap = 0;
		$p_overlap = construct_overlap();
		$p_latter_overlap = 0;
		next;
	}
	
	## check if the former line is a single exon region by checing $flag
	$p_latter_overlap = construct_overlap();
=cut
	if($flag == 1)
	{
		$p_flag = classify();
		$num_reads = count_overlap($p_flag, $$p_overlap->getChr(), $$p_overlap->getStart(), $$p_overlap->getEnd());
		my $score = calculate_score($num_reads, $$p_overlap->getStart()-$$p_overlap->getEnd()+1);
		print_line($p_overlap, $score);
	}
	elsif($flag == -1)
	{
=cut
		$p_flag = classify();
		$num_reads = count_overlap($p_flag, $$p_overlap->getChr(), $$p_overlap->getStart(), $$p_overlap->getEnd());
		my $score = calculate_score_FPKM($num_reads, $$p_overlap->getEnd()-$$p_overlap->getStart()+1, $depth);
		print_line($p_overlap, $score);
	#}
	
	## reset this line for next round
	## wait for being processed in the next round
	$p_former_overlap = $p_overlap;
	$p_overlap = $p_latter_overlap;
	$p_latter_overlap = 0;
=cut
	if($fields_line[3] > 1)
	{
		$flag = -1;
	}
	elsif($fields_line[3] == 1)
	{
		$flag = 1;
	}
=cut	
	#if($line_count == 20){exit;}
}

$p_flag = classify();
$num_reads = count_overlap($p_flag, $$p_overlap->getChr(), $$p_overlap->getStart(), $$p_overlap->getEnd());
my $score = calculate_score_FPKM($num_reads, $$p_overlap->getEnd()-$$p_overlap->getStart()+1, $depth);
print_line($p_overlap, $score);

close (OVERLAP);

sub count_overlap
{
	my ($p_flag, $chr, $start, $end) = @_;
	
	my $filename;
	
	#print $$p_flag[1], "\t", $$p_flag[3], "\n";
	
	## the subexon has not connection on both sides
	if($$p_flag[1]==0 && $$p_flag[3]==0)
	{
		$filename = count_for_class($chr, $start, $end, 0, 0);
	}
	## has connection on right side
	elsif($$p_flag[1]==0 && $$p_flag[3]==1)
	{
		$filename = count_for_class($chr, $start, $end, 0, 20);
	}
	## has connection on left side
	elsif($$p_flag[1]==1 && $$p_flag[3]==0)
	{
		$filename = count_for_class($chr, $start, $end, 20, 0);
	}
	# has connection on both sides
	elsif($$p_flag[1]==1 && $$p_flag[3]==1)
	{
		$filename = count_for_class($chr, $start, $end, 20, 20);
	}
	
	close (OUT);
	
	my $n_reads = count_line($filename);
}

sub classify
{
	my $left = 0;
	my $right = 0;
	my $left_connect = 0;
	my $right_connect = 0;
	
	if($p_former_overlap == 0)
	{
		$left = 0;
	}
	## compare former and current
	elsif($$p_former_overlap->getChr() ne $$p_overlap->getChr())
	{
		## it means there is no overlap regions on the left
		$left = 0;
	}
	else
	{
		## check the distance between start of current and the end of former
		if($$p_former_overlap->getEnd() == $$p_overlap->getStart()-1)
		{
			## it means current region connect the former
			$left = 1;
			$left_connect = 1;
		}
		else
		{
			$left = 0;
			## check if overlap is connected with former_overlap
			#print $$p_former_overlap->getTrans(),"\t", $$p_overlap->getTrans(),"\n";
			$left_connect = check_connect(\$$p_former_overlap->getTrans(), \$$p_overlap->getTrans());
		}
	}
	
	## compare current and latter
	if($p_latter_overlap == 0)
	{
		$right = 0;
	}
	elsif($$p_latter_overlap->getChr() ne $$p_overlap->getChr())
	{
		## it means there is no overlap regions on the left
		$right = 0;
	}
	else
	{
		## check the distance between start of current and the end of former
		if($$p_latter_overlap->getStart() == $$p_overlap->getEnd() + 1)
		{
			## it means current region connects the former
			$right = 1;
			$right_connect = 1;
		}
		else
		{
			$right = 0;
			## check if overlap is connected with latter_overlap
			$right_connect = check_connect(\$$p_latter_overlap->getTrans(), \$$p_overlap->getTrans());
		}
	}
	
	## if right=0 and left=0, they are single exon islands, classified into A
	my @flag;
	$flag[0] = $left;
	$flag[1] = $left_connect;
	$flag[2] = $right;
	$flag[3] = $right_connect;
	
	return \@flag;
}

sub count_for_class
{
	my ($chr, $start, $end, $left_shift, $right_shift) = @_;
	
	## for storing reads covering the region
	my $region = sprintf("%s:%s-%s", $chr, $start, $end);
	# get a SAM file containing reads in the gene region
	my $tmp = "tmp.sam";
	system("samtools view $ARGV[1] $region > $tmp");

	# The following codes are used to see if a read belongs to the region
	my $filename = "out.sam";
	open(OUT, ">$filename");
	
	open(TMP, "tmp.sam") || die "Could not read from tmp.sam, program halting.";
	
	my $line = 0;
	while(my $current_line=<TMP>)
	{
		chomp($current_line);
		# split current line
		my @fields = split("\t", $current_line);
		
		my $ret = all_reads_exon($fields[3], $fields[5], $start, $end, $left_shift, $right_shift);
		
		if($ret == 1)
		{
			print OUT $current_line, "\n";
		}
	}
	close (TMP);
	
	return $filename;
}

sub check_connect
{
	my ($p1, $p2) = @_;
	
	my @m = split(";", $$p1);
	my @n = split(";", $$p2);
	
	#print @m, "\t", @n, "\n";
	
	for(my $j=0; $j<scalar(@m); $j++)
	{
		for(my $i=0; $i<scalar(@n); $i++)
		{
			if($m[$j] eq $n[$i])
			{
				return 1;
			}
		}
	}
	
	return 0;
}

sub construct_overlap
{
	my $overlap = Subexon->new();
	
	$overlap->setChr($fields_line[0]);
	$overlap->setStart($fields_line[1]);
	$overlap->setEnd($fields_line[2]);
	$overlap->setOverlap($fields_line[3]);
	$overlap->setTrans($fields_line[4]);
	
	return \$overlap;
}

sub print_line
{
	my ($p_subexon, $score) = @_;
	
	print $$p_subexon->getChr(), "\t", $$p_subexon->getStart(), "\t", $$p_subexon->getEnd(), "\t", $$p_subexon->getTrans(), "\t", $score, "\n";
}