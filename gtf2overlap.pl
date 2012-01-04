#!/usr/bin/perl
## Author: Lei Sun
## Date: 26/10/2011
 
## Description: convert a gtf file to file containing details of overlapped exons
## Input: $ARGV[0]-exons.gtf.sorted
## Output: 
## Format of exon.overlap: chr1	4767606	4767729	2	CUFF.12.2,2;CUFF.12.1,2

use strict;
use warnings;
use Switch;

#use Subexon;
use LineGTF;
require "parse_gtf_line.pl";

# Variables
my $start;
my $end;
my $chr;
my @bd;
my @fields_line;
# prefix of the locus_id
# my $prefix = "subexon.";
my $index = 0;
my @trans_id;
my $i = 0;

#declare a subexon
#my $subexon = Subexon->new();
# point to the instance of current line
my $p_current_line;

# set an array for storing boundaries
my %bds;
# number of boundaries
my $nb;

open(EXON_GTF, $ARGV[0]) || die "Could not read from argv[0], program halting.";
my $line_count=0;
while(my $current_line=<EXON_GTF>){
    chomp($current_line);
    $line_count++;
    
    $p_current_line = parse_gtf_line(\$current_line);
	
	## initiate subexon using the first line
	if($line_count == 1)
	{
		init_locus();
		next;
	}
	
	if($$p_current_line->getChr() eq $chr)
	{
		# see if new_start is smaller than old_end
		if($$p_current_line->getStart() < $end  && $$p_current_line->getStart() >= $start)
		{
			# add the boundaries of the exon to the array
			add_b();
		}
		else
		{
			print_subexon();
			clear_b();
			init_locus();
		}
	}
	else
	{
		print_subexon();
		clear_b();
		init_locus();
	}
	
	#if($line_count==58){print $$p_current_line->getTransId();}
	#if($line_count == 20) {last;}
}

print_subexon();

close EXON_GTF;

sub clear_b
{
	undef %bds;
}

# the function for add boundaries
sub add_b
{
	# check the up boundary
	my $start_b = $$p_current_line->getStart() - 1;
	# check the down boundary
	my $end_b = $$p_current_line->getEnd();
	
	#my $current_trans_exon = $$p_current_line->getTransId().",".$$p_current_line->getExonNum().",".$$p_current_line->getStrand();
	my $current_trans_exon = $$p_current_line->getTransId();
	
	if(exists $bds{$start_b})
	{
		#print "herer\n";
		# if the $start_b has been stored
		# the the value of the up boundary will be added by 1
		$bds{$start_b}->{change_value} ++;
		$bds{$start_b}->{trans_str} = $bds{$start_b}->{trans_str}.";".$current_trans_exon;
		
		if(exists $bds{$end_b})
		{
			# the the value of up boundary will be substracted by 1
			#print "herer2\n";
			$bds{$end_b}->{change_value} --;
			$bds{$end_b}->{trans_str} = $bds{$end_b}->{trans_str}.";".$current_trans_exon;
		}
		else
		{
			# the the value of down boundary will be -1
			$bds{$end_b}->{change_value} = -1;
			$bds{$end_b}->{trans_str} = $current_trans_exon;
		}
	}
	else
	{
		# if the $start_b has not been stored
		$bds{$start_b}->{change_value} = 1;
		$bds{$start_b}->{trans_str} = $current_trans_exon;
		
		if(exists $bds{$end_b})
		{
			# the the value of up boundary will be substracted by 1
			$bds{$end_b}->{change_value} --;
			$bds{$end_b}->{trans_str} = $bds{$end_b}->{trans_str}.";".$current_trans_exon;
		}
		else
		{
			# the the value of down boundary will be -1
			$bds{$end_b}->{change_value} = -1;
			$bds{$end_b}->{trans_str} = $current_trans_exon;
		}
	}
	
	# sort the value in %bds
	@bd = sort {$a <=> $b} keys(%bds);
	# get the biggest value ans assign it to $end
	$end= $bd[-1];
	#print "end is $end \n";
}

sub print_subexon
{
	my $value = 0;
	my $trans_str;
	my $count = 0;
	my $begin_key;
	my @key = sort {$a <=> $b} keys(%bds);
	#print scalar(@key), "\n";
	foreach (@key)
	{
		$count ++;

		if($count == 1)
		{
			# set the beginning boundary
			$begin_key = $_;
			$value = $bds{$begin_key}->{change_value};
			$trans_str = $bds{$begin_key}->{trans_str};
			next;
		}
		
		# print 
		print $chr, "\t", $begin_key+1, "\t", $_, "\t", $value, "\t", $trans_str, "\n";
		
		# set the beginning of next region
		$begin_key = $_;
		my $change = $bds{$_}->{change_value};
		if($change > 0)
		{
			$trans_str = add_id($trans_str, $bds{$begin_key}->{trans_str});
		}
		else
		{
			$trans_str = del_id($trans_str, $bds{$begin_key}->{trans_str});
		}
		$value = $change + $value;
		
		
		
	}
	#print "\n";
}

sub add_id
{
	my ($old_id, $new_id) = @_;
	
	my $ret = $old_id.";".$new_id;
	
	return $ret;
}

sub del_id
{
	my ($old_id, $new_id) = @_;
	#print $old_id, "\n";
	my @array_old = split(";", $old_id);
	my @array_new = split(";", $new_id);
	
	my $id;
	my $n=0;
	my $flag;
	
	foreach(@array_old)
	{
		$flag = 1;
		for(my $i=0; $i<scalar(@array_new); $i++)
		{
			if($_ eq $array_new[$i])
			{
				$flag = -1;
				last;
			}
		}
		if($flag == 1)
		{
			# should output the id
			if($n > 0)
			{
				$id = $id.";".$_;
			}
			else
			{
				$id = $_;
			}
			$n ++;
		}
	}
	
	return $id;
}

sub init_locus
{
	# initiate a exon locus
	$start = $$p_current_line->getStart();
	$end = $$p_current_line->getEnd();
	$chr = $$p_current_line->getChr();
	
	# initiate a subexon region
=cut
	$subexon->setId($prefix.$index);
	$index++;
	$subexon->setChr($chr);
	$subexon->setStart($start);
	$subexon->setEnd($end);
	$subexon->setStrand($$p_current_line->getStrand());
	$subexon->setTrans($$p_current_line->getTransId().",".$$p_current_line->getExonNum());
=cut	
	# init a boundary
	undef %bds;
	#$bds{$start-1}={change_value=>1, trans_str=> $$p_current_line->getTransId().",".$$p_current_line->getExonNum().",".$$p_current_line->getStrand()};
	#$bds{$end}={change_value=>-1,trans_str=> $$p_current_line->getTransId().",".$$p_current_line->getExonNum().",".$$p_current_line->getStrand()};
	$bds{$start-1}={change_value=>1, trans_str=> $$p_current_line->getTransId()};
	$bds{$end}={change_value=>-1,trans_str=> $$p_current_line->getTransId()};
}