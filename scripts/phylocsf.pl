#!/usr/bin/perl -w

#submit_my_jobs_to_cluster

my @AllFiles=<./file_pieces/*>;
foreach my $onefile(@AllFiles){
  system("PhyloCSF 29mammals $onefile --orf=ATGStop --frames=3 --removeRefGaps --aa >> phylocsf.out");
}
