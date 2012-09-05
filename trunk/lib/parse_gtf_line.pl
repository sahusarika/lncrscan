## Author: Lei Sun
## Date: 17/08/2011
## Email: leisuncumt@yahoo.com
 
## Description: It is a subroutine to parse a line of GTF file from Cufflinks 
## Subroutine: idHash(knownGene.TSS, return_flag)
## Input parameter: a line of the GTF file
use Switch;
use strict;
use LineGTF;

sub parse_gtf_line
{
	# get the line
	my $line = shift;
	chomp($$line);
	
	# split current line
	my @fields_line = split("	", $$line);
	
	# variables for a line
	my $chrName = $fields_line[0];
	my $source = $fields_line[1];
	my $feature = $fields_line[2];
	my $start = $fields_line[3];
	my $end = $fields_line[4];
	my $score = $fields_line[5];
	my $strand = $fields_line[6];
	my $frame = $fields_line[7];
	my $attributes = $fields_line[8];
	my $gene_id;
	my $trans_id;
	my $gene_name;
	my $exon_number;
	my $class_code;
	my $old_id;
	
	#split the attribute field
	my @fields_attr = split(" ",$attributes);
					
	#get some attributes
	for(my $i=0; $i<scalar(@fields_attr); $i=$i+2)
	{
		switch  ($fields_attr[$i]) {
			case "gene_id"
			{
				my @split = split("\"", $fields_attr[$i+1]);
				$gene_id = $split[1];
			}
			case "transcript_id"
			{
				my @split = split("\"", $fields_attr[$i+1]);
				$trans_id = $split[1];
			}
			case "exon_number"
			{
				my @split = split("\"", $fields_attr[$i+1]);
				$exon_number = $split[1];
			}
			case "gene_name"
			{
				my @split = split("\"", $fields_attr[$i+1]);
				$gene_name = $split[1];
			}
			case "class_code"
			{
				my @split = split("\"", $fields_attr[$i+1]);
				$class_code = $split[1];
			}
			case "oId"
			{
				my @split = split("\"", $fields_attr[$i+1]);
				$old_id = $split[1];
			}
		}
	}

	# construct a line instance
	my $gtf_line =  LineGTF->new();
	$gtf_line->setChr($chrName);
	$gtf_line->setFeature($feature);
	$gtf_line->setSource($source);
	$gtf_line->setStart($start);
	$gtf_line->setEnd($end);
	$gtf_line->setScore($score);
	$gtf_line->setStrand($strand);
	$gtf_line->setFrame($frame);
	$gtf_line->setGeneId($gene_id);
	$gtf_line->setTransId($trans_id);
	$gtf_line->setExonNum($exon_number);
	$gtf_line->setClass($class_code);
	$gtf_line->setOldId($old_id);
	
	return \$gtf_line;
}

1;