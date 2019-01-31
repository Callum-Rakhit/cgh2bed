#/usr/bin/Rscript

args <- commandArgs(trailingOnly = TRUE)

input = args[1]

summary_over_10 <- read.csv(input, sep = "\t", header = F)
summary_over_10$Freq <- summary_over_10$V3
summary_over_10$V3 <- summary_over_10$V2+1
write.table(summary_over_10, file = paste(input, ".bed"), 
            col.names = F, row.names = F, quote = F, sep = "\t")

