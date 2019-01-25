#!/usr/bin/env sh

main () {
  # Covert files to bed format and summarise all chromosomes in one file
  for file in *.txt; do; Rscript ./script_1.R $file; done

  # Annotate each base depending with features
  bedtools genomecov -d -i summary.txt -g hg19.txt > summary_per_base.txt

  # Filter out bases that don't have more than 100 features
  local var1='(NR>1) && ($3>'$1')'  # No spaces allowed in variable declaration (=)
  awk $var1 summary_per_base.txt > 'summary_over_'$1'_as_bed.bed'

  # Merge overlapping regions, combine regions that overlap (-d) by 5
  bedtools merge -i 'summary_over_'$1'_as_bed.bed' -d 5 > merged.txt

  # Covert output back to bed file
  Rscript ./script_2.R summary.txt > merged.bed

}

main
