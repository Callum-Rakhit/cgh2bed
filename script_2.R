#/usr/bin/Rscript

args <- commandArgs(trailingOnly = TRUE)

input = args[1]

summary_per_base_bedgraph <- read.csv(input, sep = "\t", header = F)
summary_per_base_bedgraph$Freq <- summary_per_base_bedgraph$V3
summary_per_base_bedgraph$V3 <- summary_per_base_bedgraph$V2+1
write.table(summary_per_base_bedgraph, file = paste(input, ".bed"), 
            col.names = F, row.names = F, quote = F, sep = "\t")

