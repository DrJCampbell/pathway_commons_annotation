#!/bin/bash

perl ./pc2_regulator_counter_test.pl \
--pc2_file ~/Downloads/Pathway\ Commons.7.All.BINARY_SIF.hgnc.sif \
--diff_expr_file /Users/jamesc/Dropbox/DrJCampbell/pathway_commons_annotation/test_genes_for_ACTL6A.txt \
--all_expr_file /Users/jamesc/Downloads/Pathway\ Commons.7.All.BINARY_SIF.hgnc.sif.geneBs.txt \
--out_prefix ~/Dropbox/DrJCampbell/pathway_commons_annotation/test.txt
             

