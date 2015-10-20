#!/usr/bin/perl

use warnings;
use strict;
use List::Util qw(shuffle);
use Getopt::Long;

# ==================================================================== #
# Script to estimate observed and expected counts of
# regulatory genes in a sample of differential expressed
# genes.
# ==================================================================== #
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
# ==================================================================== #


my $pc2_file = undef;
my $diff_expr_file = undef;
my $all_expr_file = undef;
my $out_prefix = undef;
my $args = scalar @ARGV;
my $help = undef;
GetOptions (
  "pc2_file=s" => \$pc2_file,
  "diff_expr_file=s" => \$diff_expr_file,
  "all_expr_file=s" => \$all_expr_file,
  "out_prefix=s" => \$out_prefix,
  "help" => \$help,
  );

# print usage message if requested or no args supplied
if(defined($help) || !$args) {
  &usage;
  exit(0);
}

my %regulated_by = &get_regulated_by($pc2_file);
my %reg_gene_count = &get_reg_gene_count($diff_expr_file, %regulated_by);
my %random_gene_count = &get_random_gene_count($all_expr_file, $diff_expr_file, %regulated_by);

open OUTOBS, "> $out_prefix.obsereved.txt" or die "Can't write to output $out_prefix.observed.txt: $!\n";
foreach my $key (keys %reg_gene_count){
  print OUTOBS "$key\t$reg_gene_count{$key}\n";
}
close OUTOBS;

open OUTRAN, "> $out_prefix.random.txt" or die "Can't write to output $out_prefix.random.txt: $!\n";
foreach my $key (keys %random_gene_count){
  print OUTRAN "$key\t" . join("\t", @{ $random_gene_count{$key} }) . "\n";
}
close OUTRAN;



sub get_regulated_by{
  my $pc2_file = shift;
  my %regulated_by;
  open PC2, "< $pc2_file" or die "Can't read file $pc2_file: $!\n";
  while(<PC2>){
    
    if(/^([^\t]+)\tcontrols-expression-of\t([^\t\r\n]+)$/){
      my $geneA = $1;
      my $geneB = $2;
      
      if(exists $regulated_by{$geneB}){
        push @{ $regulated_by{$geneB} }, $geneA;
      }
      else{
        $regulated_by{$geneB} = [$geneA];
      }
    }
  }
  close PC2;
  return %regulated_by;
}

sub get_reg_gene_count{
  my $diff_expr_file = shift;
  my (%regulated_by) = @_;
  my %reg_gene_count;
  
  # initialise %reg_gene_count keys
  # with values from %regulated_by
  my @geneBs = keys %regulated_by;
  foreach my $geneB (@geneBs){
    foreach my $geneA ( @{ $regulated_by{$geneB} }){
      $reg_gene_count{$geneA} = 0;
    }
  }
  
  open DEG, "< $diff_expr_file" or die "Can't read from file $diff_expr_file: $!\n";
  while(<DEG>){
    next if /^#/;
    my $geneB = $_;
    chomp($geneB);
    my @geneAs = @{ $regulated_by{$geneB} };
    foreach my $geneA (@geneAs){
      $reg_gene_count{$geneA} ++;
    }
  }
  close DEG;
  return %reg_gene_count;
}


sub get_random_gene_count{
  my $all_expr_file = shift;
  my $diff_expr_file = shift;
  my (%regulated_by) = @_;
  my %random_gene_count;
  
  # find the number of differentially expressed
  # genes to use as a sample size value when
  # randomly sampling all_expressed_genes
  my $count_diff_expr_genes = 0;
  open DEG, "< $diff_expr_file" or die "Can't read from file $diff_expr_file: $!\n";
  while(<DEG>){
    next if /^#/;
    my $count_diff_expr_genes ++;
  }
  close DEG;
  
  
  # initialise %random_gene_count keys
  # with values from %regulated_by
  my @geneBs = keys %regulated_by;
  foreach my $geneB (@geneBs){
    foreach my $geneA ( @{ $regulated_by{$geneB} }){
      $random_gene_count{$geneA} = ();
    }
  }
  
  # get list of all expressed genes to sample from
  my @all_genes;
  open RAN, "< $all_expr_file" or die "Can't read from file $diff_expr_file: $!\n";
  while(<RAN>){
    next if /^#/;
    my $geneB = $_;
    chomp($geneB);
    push @all_genes, $geneB;
  }
  close RAN;
  
  my $its = 100;
  
  # store %random_gene_count needs to be a hash
  # of arrays where each array is $its long.
  my %copy_of_random_gene_count = %random_gene_count;
  for(my $i = 0; $i <= $its; $i ++){
    my %temp_random_gene_count = %copy_of_random_gene_count;
    my @shuffled_genes = shuffle(@all_genes);
    my @random_sample = $shuffled_genes[0..$count_diff_expr_genes];
    foreach my $random_gene (@random_sample){
      my @random_geneAs = @{ $regulated_by{$random_gene} };
      foreach my $random_geneA (@random_geneAs){
        $temp_random_gene_count{$random_geneA} ++;
      }
    }
    foreach my $sampled_random_gene (keys %temp_random_gene_count){
      push @{ $random_gene_count{$sampled_random_gene} }, $temp_random_gene_count{$sampled_random_gene};
      #push @{ $random_gene_count{$sampled_random_gene} }, 1;
    } 
  }
  return %random_gene_count;
}





sub usage{
        my $usage =<<END;
        
pc2_regulator_counter.pl

usage:  perl pc2_regulator_counter.pl\
             --pc2_file        path to pc2 sif file
             --diff_expr_file  path to file listing interest genes
             --all_expr_file   path to file listing all expressed genes
             --out_prefix      prefix to add to output files
or
        perl pc2_regulator_counter.pl --help # to see this message

END
        print $usage;
}
 
