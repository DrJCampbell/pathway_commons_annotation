#!/bin/bash

#perl ./pc2_regulator_counter.pl \
#--pc2_file ~/Downloads/Pathway\ Commons.7.All.BINARY_SIF.hgnc.sif \
#--diff_expr_file /Users/jamesc/Dropbox/DrJCampbell/pathway_commons_annotation/MCF10A_null_vs_par_100cntsPlus_top_50_most_sig.txt \
#--all_expr_file /Users/jamesc/Downloads/Pathway\ Commons.7.All.BINARY_SIF.hgnc.sif.geneBs.txt \
#--out_prefix ~/Dropbox/DrJCampbell/pathway_commons_annotation/test.txt
             
perl ./pc2_regulator_counter.pl \
--pc2_file ~/Downloads/Pathway\ Commons.7.All.BINARY_SIF.hgnc.sif \
--diff_expr_file /Users/jamesc/Dropbox/DrJCampbell/pathway_commons_annotation/MCF10A_null_vs_par_100cntsPlus_top_50_most_sig_down_reg.txt \
--all_expr_file /Users/jamesc/Downloads/Pathway\ Commons.7.All.BINARY_SIF.hgnc.sif.geneBs.txt \
--out_prefix ~/Dropbox/DrJCampbell/pathway_commons_annotation/MCF10A_null_vs_par_100cntsPlus_top_50_most_sig_down_reg_regulator_counts.txt

perl ./pc2_regulator_counter.pl \
--pc2_file ~/Downloads/Pathway\ Commons.7.All.BINARY_SIF.hgnc.sif \
--diff_expr_file /Users/jamesc/Dropbox/DrJCampbell/pathway_commons_annotation/MCF10A_null_vs_par_100cntsPlus_top_50_most_sig_up_reg.txt \
--all_expr_file /Users/jamesc/Downloads/Pathway\ Commons.7.All.BINARY_SIF.hgnc.sif.geneBs.txt \
--out_prefix ~/Dropbox/DrJCampbell/pathway_commons_annotation/MCF10A_null_vs_par_100cntsPlus_top_50_most_sig_up_reg_regulator_counts.txt

#--diff_expr_file /Users/jamesc/Dropbox/DrJCampbell/pathway_commons_annotation/test_genes_for_ACTL6A.txt \

