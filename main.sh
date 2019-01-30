#!/usr/bin/env sh


# Covert files to bed format and summarise all chromosomes in one file
for file in *.txt; do Rscript ./script_1.R $file; done

#Sort the bed file
# bedtools sort -chrThenSizeA -i summary.bed > summary_sorted.bed
sort-bed summary.bed > summary_sorted.bed

# Annotate each base depending with features
bedtools genomecov -d -i summary.txt -g hg19.txt > summary_per_base.txt

# Filter out bases that don't have more than 100 features
# local var1='(NR>1) && ($3>50)'  # No spaces allowed in variable declaration (=)
# local summary_over_10 = awk $var1 summary_per_base.txt
# awk '(NR>1) && ($3>10)' summary_per_base.txt > summary_over_10.txt
  
# Covert output back to bed file
Rscript ./script_2.R summary_over_10.txt > summary_over_10.bed
  
# Merge overlapping regions, combine regions that overlap (-d) by 5
bedtools merge -i summary_over_50.bed -d 5 > merged_50.bed
