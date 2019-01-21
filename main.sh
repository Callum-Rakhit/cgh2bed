
# Annotate each base depending with features

bedtools genomecov -i summary.bed -g hg19.txt

# Filter out bases that don't have more than 100 features

awk '(NR>1) && ($3 > 100 ) ' summary_per_base.bed > summary_over_100_as_bed.bed

# Merge overlapping regions

bedtools merge -i summary_over_100_as_bed.bed -d 5  # Combine regions that overlap (-d) by 5
