# Introduction #

This is an example representing how to use lncRScan to detect novel lncRNAs.

# Input #
high-confident.gtf -- a GTF file recording high-quality assemblies with classcodes

lnc\_class -- a list of classcodes, which may contain lncRNAs

# Steps #

  * extract\_category -- extract 3287 transcripts from input GTF file according to the classcodes listed.
```

$ extract_GTF_class.pl high-confident.gtf lnc_class (then extracted.gtf and extracted_id are generated)
$ mv extracted.gtf transcripts_1.gtf
```
  * extract\_length -- extract transcripts from transcripts\_1.gtf according to length > 200nt

> (1) Get transcripts\_1.bed according to transcripts\_1.gtf using UCSC table browser

> (2) extract 3247 multi-exon transcript with length > 200nt
```

$ extract_long_multi.pl transcripts_1.bed > transcripts_2.bed
```
> (3) get transcripts\_2.fa according to transcripts\_2.bed

  * extract\_ORF -- get IDs of transcripts with ORF length < 300

> (1) get longest ORF length of transcripts\_2.fa using UCSC table browser
```

$ longorf.pl --input transcripts_2.fa > transcripts_2.orf.list
```

> (2) get 731 transcript ids with length < 300
```

$ awk '($2<300){print $1}' transcripts_2.orf.list > transcripts_3.list
```

> (3) trim the IDs in transcripts\_3.list (If the transcript IDs have been changed, you should recover the IDs using appropriate commands as below)
```

$ perl -ne '@aa = split(/_/);print $aa[4]; for($i=5;$i<scalar(@aa);$i++){print "_", $aa[$i]}' transcripts_3.list > transcripts_3.renamed.list
```
> (4) extract transcripts from transcripts\_1.bed according to transcripts\_3.renamed.list
```

$ extract_BED_id.pl transcripts_3.renamed.list transcripts_2.bed > transcripts_3.bed
```
  * Run PhyloCSF (score<0 or fail)

> (1) Stitch 29 mammalian genome alignment according to transcripts\_3.bed using "Stitch MAF blocks"

> -- Upload the BED file to Galaxy;

> -- On Galaxy, choose "Fetch Alignments" --> "Stitch MAF blocks";

> -- On the page of Stitch MAF blocks (version 1.0.1), click before the
> > 29 species that will be included in final alignment and leave other
> > parameters default.


> -- Click "Execute" and the final alignment will be put in your storage on Galaxy.

> (2) Download the 29 mammalian alignments and the BED file from Galaxy

> (3) Modify the species' name in the alignment FASTA file using 29mammals.sh
```

$ 29mammals.sh 29_mammals_aln.fasta > 29_mammals_aln_renamed.fasta
```
> (4) Create a table connecting transcript\_id and its coordinates using
```

$ awk '{print $4"\t"$1"("$6"):"$2"-"$3}' transcripts_3.bed > id-co.table
```
> (5) Separate 29\_mammals\_aln\_renamed.fasta into files, each of which only contains one alignment
```

$ mkdir file_pieces
$ pre_phylocsf.pl id-co.table 29_mammals_aln_renamed.fasta
```
> (6) Run PhyloCSF, which will output phylocsf.out
```

$ ln -s PATH_TO_PHYLOCSF/PhyloCSF .
$ ln -s PATH_TO_PHYLOCSF/PhyloCSF_Parameters .
$ ln -s PATH_TO_PHYLOCSF/bin .
$ ln -s PATH_TO_PHYLOCSF/share .
$ nohup ./phylocsf.pl &
```
> (7) Parse the output of the command above and get a new list of 382 transcripts
```

$ parse_phylocsf_output.pl phylocsf.out > transcripts-4.list
```
> (8) extract transcripts-4.gtf according to transcripts-4.list
```

$ extract_GTF_isoform.pl transcripts-1.gtf transcripts-4.list > transcripts-4.gtf
```

  * Search Pfam
> > (1) get transcripts-4.fa from UCSC according to transcripts-4.gtf


> (2) translate the nucleitide sequences into amino acid sequences
```

$ seq2protein.pl transcripts-4.fa > transcripts-4.aa.fa
```

> (3) search the transcripts-4.aa.fa in Pfam and get results of Pfam search by email.

> (4) store the results of Pfam search in Pfam.results

> (5) get a list of ids with significant Pfam results
```

$ awk '($14==1){print $1}' Pfam.results | uniq >  Pfam_significant.list
```
> > (6) rename the IDs in list
```

$ perl -ne '@aa = split(/[_-]/);print $aa[4] , "_", $aa[5],"\n"' Pfam_significant.list | uniq > Pfam_significant.renamed.list
```
> > (7) exclude the transcripts listed in Pfam\_significant.list
```

$ filter_GTF_isoform.pl transcripts-4.gtf Pfam_significant.renamed.list > transcripts-5.gtf
```

# Output #

> The remaining transcripts-5.gtf contains the 308 lncRNA candidates.