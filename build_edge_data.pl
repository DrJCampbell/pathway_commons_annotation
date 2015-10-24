#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;


# cheesey script to parse significant geneAs
# connected to regulated geneBs and write
# the python code to feed networkx

my $pc2_file;
my $geneB_file;
my $geneA_file;
my $outfile = undef;
my $args = scalar @ARGV;
my $help = undef;
GetOptions (
  "pc2_file=s" => \$pc2_file,
  "geneB_file=s" => \$geneB_file,
  "geneA_file=s" => \$geneA_file,
  "outfile=s" => \$outfile,
  "help" => \$help,
  );


#my $pc2_file = "/Users/jamesc/Downloads/Pathway\ Commons.7.All.BINARY_SIF.hgnc.sif";
#my $geneB_file = "/Users/jamesc/Dropbox/DrJCampbell/pathway_commons_annotation/MCF10A_null_vs_par_100cntsPlus_top_50_most_sig.txt";
#my $geneA_file = "/Users/jamesc/Dropbox/DrJCampbell/pathway_commons_annotation/MCF10A_null_vs_par_100cntsPlus_top_50_most_sig_regulatory_geneAs.txt";
#my $outfile = "/Users/jamesc/Dropbox/DrJCampbell/pathway_commons_annotation/MCF10A_null_vs_par_100cntsPlus_top_50_most_sig_networkx_code.py";

my $add_geneA_nodes = "";
my $add_geneB_nodes = "";
my $add_egdes = "";

my %geneAs_and_geneBs;
my %geneAs;
my %geneBs;

open GNA, "< $geneA_file" or die "Can't read file $geneA_file: $!\n";
while(<GNA>){
  my $geneA = $_;
  chomp($geneA);
  $geneAs{$geneA} = 1;
  $geneAs_and_geneBs{$geneA} = "A";
}
close GNA;

open GNB, "< $geneB_file" or die "Can't read file $geneB_file: $!\n";
while(<GNB>){
  my $geneB = $_;
  chomp($geneB);
  $geneBs{$geneB} = 1;
  $geneAs_and_geneBs{$geneB} = "B";
}
close GNB;


my %used_geneAs;
my %used_geneBs;

open PC2, "< $pc2_file" or die "Can't read file $pc2_file: $!\n";
while(<PC2>){
  my $line = $_;
  chomp($line);
  my ($geneA, $connection, $geneB) = split(/\t/, $line);
  if($connection eq 'controls-expression-of'){
#    print "found connection: a) $geneA b) $geneB\n";
    if(exists $geneAs{$geneA}){
#    if(exists $geneAs_and_geneBs{$geneA}){
#      print "found a geneA $geneA\n";
      if(exists $geneBs{$geneB}){
#      if(exists $geneAs_and_geneBs{$geneB}){
#        print "found a geneB $geneB\n";
        $used_geneAs{$geneA} = 1;
        $used_geneBs{$geneB} = 1;
        $add_egdes = $add_egdes . "G.add_edge('$geneA','$geneB')\n";
      }
    }
  }
}
close PC2;

foreach my $geneA (keys %used_geneAs){
  $add_geneA_nodes = $add_geneA_nodes . "G.add_node('$geneA')\n";
}
foreach my $geneB (keys %used_geneBs){
  $add_geneB_nodes = $add_geneB_nodes . "G.add_node('$geneB')\n";
}

open OUT, "> $outfile" or die "Can't write file $outfile: $!\n";
print OUT "$add_geneA_nodes\n$add_geneB_nodes\n$add_egdes\n";
close OUT;













