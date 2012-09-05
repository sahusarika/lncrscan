#This file contains the definition for the line of a GTF file
package LineGTF;

use strict;

#The constructor 
sub new {

	my $class = shift();

	my $self = {};
	
	# chromosome that the feature belongs to
	$self->{"chr"} = shift();
	
	# Source
	$self->{"source"} = shift();
	
	# feature
	$self->{"feature"} = shift();
	
	# starting site of the transcript
	$self->{"start"} = shift();
	
	# ending site of the transcript
	$self->{"end"} = shift();
	
	$self->{"score"} = shift();
	
	# strand
	$self->{"strand"} = shift();
	
	# frame
	$self->{"frame"} = shift();
	
	# gene_id
	$self->{"gene_id"} = shift();
	
	# trans_id
	$self->{"trans_id"} = shift();
	
	# exon_number
	$self->{"exon_number"} = shift();
	
	# class code
	$self->{"class"} = shift();
	
	# old id
	$self->{"oldid"} = shift();
	
	bless $self, $class;

	return $self;
}

#get the chr
sub getChr {
	my ($self) = @_;
	return $self->{"chr"};
}
#set the chr
sub setChr {
	my ($self, $chr) = @_;
	$self->{"chr"} = $chr;
}

#get the source
sub getSource {
	my ($self) = @_;
	return $self->{"source"};
}
#set the source
sub setSource {
	my ($self, $source) = @_;
	$self->{"source"} = $source;
}

#get the gene feature
sub getFeature {
	my ($self) = @_;
	return $self->{"feature"};
}
#set the gene name
sub setFeature {
	my ($self, $feature) = @_;
	$self->{"feature"} = $feature;
}

#get the starting site
sub getStart {
	my ($self) = @_;
	return $self->{"start"};
}
#set the starting site
sub setStart {
	my ($self, $start) = @_;
	$self->{"start"} = $start;
}

#get the ending site
sub getEnd {
	my ($self) = @_;
	return $self->{"end"};
}
#set the ending site
sub setEnd {
	my ($self, $end) = @_;
	$self->{"end"} = $end;
}

#get the score
sub getScore {
	my ($self) = @_;
	return $self->{"score"};
}
#set the score
sub setScore {
	my ($self, $score) = @_;
	$self->{"score"} = $score;
}

#get the strand
sub getStrand {
	my ($self) = @_;
	return $self->{"strand"};
}
#set the strand
sub setStrand {
	my ($self, $strand) = @_;
	$self->{"strand"} = $strand;
}

#get the frame
sub getFrame {
	my ($self) = @_;
	return $self->{"frame"};
}
#set the frame
sub setFrame {
	my ($self, $frame) = @_;
	$self->{"frame"} = $frame;
}

#get the attributes
sub getGeneId {
	my ($self) = @_;
	return $self->{"gene_id"};
}
#set the strand
sub setGeneId {
	my ($self, $value) = @_;
	$self->{"gene_id"} = $value;
}

#get the transcript id
sub getTransId {
	my ($self) = @_;
	return $self->{"trans_id"};
}
#set the transcript id
sub setTransId {
	my ($self, $value) = @_;
	$self->{"trans_id"} = $value;
}

#get the exon number
sub getExonNum {
	my ($self) = @_;
	return $self->{"exon_number"};
}
#set the exon number
sub setExonNum {
	my ($self, $value) = @_;
	$self->{"exon_number"} = $value;
}

#get the class code
sub getClass {
	my ($self) = @_;
	return $self->{"class"};
}
#set the exon number
sub setClass {
	my ($self, $value) = @_;
	$self->{"class"} = $value;
}

#get the old id
sub getOldId {
	my ($self) = @_;
	return $self->{"oldid"};
}
#set the old id
sub setOldId {
	my ($self, $value) = @_;
	$self->{"oldid"} = $value;
}

1;