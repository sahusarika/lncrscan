# Introduction #
lncRScan (long non-coding RNA Scan) is a pipeline consists of five steps for detecting novel long non-coding RNAs from a set of candidate transcripts annotated by Cuffcompare.

# Steps of lncRScan #
  * Step 1 'extract\_category'-- extract several categories of transcripts, which may contain lncRNAs. The candidate categories can be `i' (a transfrag falling entirely within a reference intron), 'j' (potentially novel isoform), 'o'
(generic exonic overlap with a reference transcript), 'u' (intergenic transcript) and 'x' (exonic overlap with reference on the opposite strand).

  * Step 2 'extract\_length'-- extract the transcripts having long exonic length (> 200nt).

  * Step 3 'extract ORF'-- exclude the assemblies that have long (>= 300nt) putative ORF.

  * Step 4 'extract PhyloCSF'-- PhyloCSF was recruited to filter the transcripts of protein-coding potential from an evolutionary view.

  * Step 5 'extract Pfam'-- exclude transcripts with significant domain hits by searching Pfam.

# Input #
Candidate transcripts -- a GTF file annotated by Cuffcompare of Cufflinks.

Notes: each transcript in the GTF file has been assigned a classcode defined by
Cuffcompare and the classcode is needed for step 1 of lncRScan. If you have a GTF without Cuffcompare's annotation, you can just start from step 2.

# Tools used #
  * Scripts--

> (1) extract\_GTF\_class.pl -- extract GTF according to classcode list. e.g.

> ```
$ extract_GTF_class.pl example.gtf lnc_class```

> (2) seq2protein.pl -- convert nucleotide sequences to amino acid sequences. e.g.

> ```
$ seq2protein.pl example.fa > example.aa.fa```

> (3) extract\_long\_multi.pl -- extract long(>200) multi-exon RNAs according to a BED file of transcripts. e.g.

> ```
$ extract_long_multi.pl example.bed > example_long.bed```

> (4) 29mammals.sh -- change the names of 29mammal alignment downloaded from Galaxy

> ```
$ 29mammals.sh example_aln.fasta > example_aln_renamed.fasta```

> (5) extract\_BED\_id.pl -- extract transcript information in BED file according to a gene id list. e.g.

> ```
$ extract_BED_id.pl example_list example.bed > example_extracted.bed```

> (6) filter\_GTF\_isoform.pl -- filter transcripts of a GTF annotated by cuffcompare according to transcript ids if they exist

> ```
$ filter_GTF_isoform.pl example.gtf for_filtered.list > remaining.gtf```

> (7) longorf.pl -- get the longest ORF length of each transcript. This script is  modified from longorf.pl written by Dan Kortschak

> ```
$ longorf.pl --input example.fa > example.orf.list```

> (8) parse\_phylocsf\_output.pl -- Get noncoding transcripts by parsing test results of PhyloCSF, based on the set of FASTA alignments

> ```
$ parse_phylocsf_output.pl phylocsf.out > transcripts-4.list```

> (9) phylocsf.pl -- run PhyloCSF Batch

> ```
nohup phylocsf.pl &```

> (10) pre\_phylocsf -- cut the fasta alignments into several single alignments

> ```
$ pre_phylocsf.pl id-co.table 29_mammals_aln_renamed.fasta```

  * UCSC table browser(http://genome.ucsc.edu/cgi-bin/hgTables?command=start) -- extract BED and FASTA files according to GTF

  * Galaxy(https://main.g2.bx.psu.edu/) 'Stitch MAF blocks' -- fetch alignments of 29 mammals according to GTF/BED

  * PhyloCSF(https://github.com/mlin/PhyloCSF/wiki) -- a comparative genomics method for classifying protein-coding and non-coding regions

  * Pfam database(http://pfam.sanger.ac.uk/search#tabview=tab1) -- it is a large collection of protein families

  * Bioperl(http://www.bioperl.org/wiki/Main_Page)