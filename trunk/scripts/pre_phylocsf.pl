#!/usr/bin/perl
## Author: Lei Sun
## Date: 2012/10.06
## Email: leisuncumt@yahoo.com

## Goal - Cut the fasta alignments into several single alignments
## Input - 1) id-co.table; 2) FASTA alignments 
## Output - a table

use strict;

# store the table in a hash
my %table;
my $line_count=0;
open(TAB, $ARGV[0]) || die "Could not read from argv[0], program halting.";
while(my $current_line=<TAB>){
	chomp($current_line);
    $line_count++;
    
    # split current line
	my @fields_line = split("\t", $current_line);
	
	if(!exists $table{$fields_line[1]})
	{
		$table{$fields_line[1]} = $fields_line[0];
	}
	elsif(exists $table{$fields_line[1]})
	{
		# for storing ids located at the same loci
		$table{$fields_line[1]} = $table{$fields_line[1]}.";".$fields_line[0];
	}
}
close(TAB);

#exit;
# scan the FASTA alignments
$line_count=0;
my $current_file;
my @table_ids;
open(FA, $ARGV[1]) || die "Could not read from argv[0], program halting.";
while(my $current_line=<FA>){
	chomp($current_line);
    $line_count++;
    
    if($current_line=~/^\s*$/){
    	next;
    }
    
    if(substr($current_line, 0, 7) eq ">Mouse|")
    {
    	# parse this line
    	my @id_line = split(/\./, $current_line);
    	#print "$id_line[1]\n";
    	if(exists $table{$id_line[1]})
    	{
    		@table_ids = split(/;/, $table{$id_line[1]});
    		foreach(@table_ids){
    			$current_file = "file_pieces/".$_;
    			system("echo '$current_line' > $current_file");
    		}
    	}
    	next;
    }
    
    foreach(@table_ids){
    	$current_file = "file_pieces/".$_;
    	system ("echo '$current_line' >> $current_file");
    }
}
close(FA);