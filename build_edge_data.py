#!/usr/bin/python

import argparse
import networkx as nx
import matplotlib.pyplot as plt

# get file names from the command line args
parser = argparse.ArgumentParser()
parser.add_argument('--pc2_file', help='location of pathway commons sif file')
parser.add_argument('--geneA_file', help='location of file listing the enriched regulatory genes')
parser.add_argument('--geneB_file', help='location of file containing the list of differentially regulated genes')
parser.add_argument('--outfile', help='location of the output graphML file')
args = parser.parse_args()
pc2_file = args.pc2_file
geneB_file = args.geneB_file
geneA_file = args.geneA_file
outfile = args.outfile


# build a dict of geneAs
geneAs = {}
with open(geneA_file, 'r') as a:
	for line in a:
		line = line.rstrip("\n\r")
		geneAs[line] = "A"
file.close(a)


# build a dict of geneBs
geneBs = {}
with open(geneB_file, 'r') as b:
	for line in b:
		line = line.rstrip("\n\r")
		geneBs[line] = "B"
file.close(b)

# dicts used to store the used (connected) nodes
# and the edge directions
used_geneAs = {}
used_geneBs = {}
edges = []

# parse the pc2_file to build the node and edge data
with open(pc2_file, 'r') as p:
	for line in p:
		line = line.rstrip("\n\r")
		(geneA, connection, geneB) = line.split("\t")
		if(connection == 'controls-expression-of'):
			if geneAs.has_key(geneA):
				if geneBs.has_key(geneB):
					used_geneAs[geneA] = 1
					used_geneBs[geneB] = 1
					edges.append("%s,%s" % (geneA, geneB))

file.close(p)


# create a networkx directed graph using
# geneA and geneB as nodes (of type geneA
# or geneB) and with edges running in the
# direction of geneA to to geneB
G=nx.DiGraph()

for geneA in used_geneAs:
	G.add_node(geneA, type='geneA')

for geneB in used_geneBs:
	G.add_node(geneB, type='geneB')

for edge in edges:
	(geneA, geneB) = edge.split(',')
	G.add_edge(geneA,geneB)

nx.write_graphml(G,outfile)

nx.draw(G)
plt.show()

