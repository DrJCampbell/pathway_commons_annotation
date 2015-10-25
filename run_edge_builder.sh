#perl ./build_edge_data.pl \
#--pc2_file ~/Downloads/Pathway\ Commons.7.All.BINARY_SIF.hgnc.sif \
#--geneB_file ./MCF10A_null_vs_par_100cntsPlus_top_50_most_sig_up_reg.txt \
#--geneA_file ./sig_geneAs_for_upreg_geneBs.txt \
#--outfile ~/Dropbox/DrJCampbell/pathway_commons_annotation/sig_geneAs_for_upreg_geneBs_networkx.py


perl ./build_edge_data.pl \
--pc2_file ~/Downloads/Pathway\ Commons.7.All.BINARY_SIF.hgnc.sif \
--geneB_file ./MCF10A_null_vs_par_100cntsPlus_top_50_most_sig_down_reg.txt \
--geneA_file ./sig_geneAs_for_downreg_geneBs.txt \
--outfile ~/Dropbox/DrJCampbell/pathway_commons_annotation/sig_geneAs_for_downreg_geneBs_networkx_with_colours.py







