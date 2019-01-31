#!/usr/bin/env sh

# Covert files to bed format and summarise all chromosomes in one file
# Saves output as "summary.bed"
for file in *.txt; do Rscript ./script_1.R $file; done

# Sort the bed file
# bedtools sort -chrThenSizeA -i summary.bed > summary_sorted.bed
sort-bed summary.bed > summary_sorted.bed

# Create a merged genome file of the key regions of interest
bedtools merge -i summary.bed -d 5 > summary_merged

# Take only chromosome number and the end position
awk -v OFS='\t' '{print $1, $3}' summary_merged.bed > summary_merged_genome.bed

# Annotate each base depending with features
# This works by looking at the chrosome number and the crawling through each base up to the number
# in the first column, e.g. chr1 100 would be 1:100 for chr1. Must be tab deliminated.
# -dz only non-zero coverage reported
# -bg report in bedgraph format, only report non-zero
# -d report at every base

bedtools genomecov -bg -i summary_sorted.bed -g summary_merged_genome.bed > summary_per_base_bedgraph.bed

# Covert output back to bed file using an R script
# Rscript ./script_2.R summary_per_base_bedgraph.txt > summary_per_base_bedgraph.bed

# Select bases with than 0 features (can change this to whatever cutoff needed)
awk '(NR>1) && ($4>10)' summary_per_base_bedgraph.bed > summary_over_10.bed

# Merge overlapping regions, combine regions that overlap (-d) by 2
bedtools merge -i summary_over_10.bed -d 2 > merged_over_10.bed
