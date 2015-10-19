#!/usr/bin/perl

use warnings;
use strict;

# Script to estimate observed and expected counts of
# regulatory genes in a sample of differential expressed
# genes.
# 
# 1. Download Pathway\ Commons.7.All.BINARY_SIF.hgnc.sif
# 2. find lines matching geneA	controls-expression-of geneB
#    e.g. /^([^\t]+)\tcontrols-expression-of\t([^\t\r\n]+)$/
#    Add these to a hash %regulated_by with geneB as the key
#    and multiple geneAs as an array of values
# 3. read a list of differentially regulated genes
#    set up a hash %reg_gene_count and increment for every
#    differentially regulated gene - use geneB as a key to
#    the %regulated_by hash to find all associated regulatory
#    geneAs. Use these geneAs as a key to increment %reg_gene_count
# 4. repeat step 4 with random samples of genes that could have been
#    differentially regulated (ie. all detected RNA-seq genes). Store
#    these counts in a hash %random_gene_count. This should be
#    initialised with keys for all geneAs (regulatory genes)
# 5. write out the observed and random samples of regulatory
#    gene counts
# 

my %regulated_by;
my %reg_gene_count;
my %random_gene_count;




sub get_regulated_by{
  my $pc2_file = shift;
  my %regulated_by;
  open PC2, "< $pc2_file" or die "Can't read file $pc2_file: $!\n";
  while(<PC2>){
  
  }
  
}








