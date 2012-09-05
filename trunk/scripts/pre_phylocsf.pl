#!/usr/bin/perl
## Author: Lei Sun
## Date: 11/04/2012

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
=head
	elsif(exists $table{$fields_line[1]})
	{
		print $table{$fields_line[1]}, "\n";
		print $current_line, "\n\n";
	}
=cut
}
close(TAB);

#exit;
# scan the FASTA alignments
$line_count=0;
my $current_file;
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
    		#print $id_line[1],"\n";
    		$current_file = "file_pieces/".$table{$id_line[1]};
    		system("echo '$current_line' > $current_file");

    	}
    	next;
    }
    
    system ("echo '$current_line' >> $current_file");
}
close(FA);