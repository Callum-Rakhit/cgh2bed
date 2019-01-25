#!/usr/bin/env sh

main (cutoff) {

  # Summarise all chromosomes in one file

  for file in *.txt; do; Rscript script_1.R "$file" >> summary.txt; done

  # Annotate each base depending with features

  bedtools genomecov -d -i summary.txt -g hg19.txt > summary_per_base.txt

  # Filter out bases that don't have more than 100 features

  $a="(NR>1) && ($3 >"$1" ) "  # No spaces allowed in variable declaration (=)

  awk $a summary_per_base.txt > summary_over_100_as_bed.bed

  # Merge overlapping regions

  bedtools merge -i summary_over_100_as_bed.bed -d 5 > merged.txt  # Combine regions that overlap (-d) by 5

  # Covert output back to bed file

  Rscript script_2.R summary.txt > merged.bed

}

main()
