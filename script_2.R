#/usr/bin/Rscript

args <- commandArgs(trailingOnly = TRUE)

input = args[1]

singlebp2bed <- fucntion(input) {
  summary_over_100 <- read.csv(data, sep = "\t", header = T)
  summary_over_100$Freq <- summary_over_100$X104
  summary_over_100$X104 <- summary_over_100$X74631690+1
  
  summary_over_100 <- summary_over_100[c("chr10", "X74631690", "X104", "Freq")]
  
  write.table(summary_over_100, file = paste(input, "as_bed.bed"), 
              col.names = F, row.names = F, quote = F, sep = "\t")

}

if (!interactive()) {
  singlebp2bed(input)
}

