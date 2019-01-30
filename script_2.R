#/usr/bin/Rscript

args <- commandArgs(trailingOnly = TRUE)

input = args[1]

# install.packages("ssh")
# library(ssh)
# session <- ssh_connect("crakhit@10.131.69.226")
# 
# data <- read.csv("sftp://crakhit@10.131.69.226/mnt/shared_data/Callum",
#                  sep = "\t", header = T)

summary_over_10 <- read.csv(input, sep = "\t", header = F)
summary_over_10$Freq <- summary_over_10$V3
summary_over_10$V3 <- summary_over_10$V2+1
write.table(summary_over_10, file = paste(input, ".bed"), col.names = F, row.names = F,
              quote = F, sep = "\t")
  
# singlebp2bed <- fucntion(input) {
#   summary_over_10 <- read.csv(input, sep = "\t", header = T)
#   summary_over_10$Freq <- summary_over_10$X104
#   summary_over_10$X104 <- summary_over_10$X74631690+1
#   summary_over_10 <- summary_over_10[c("chr10", "X74631690", "X104", "Freq")]
#   write.table(summary_over_10, file = input, col.names = F, row.names = F,
#               quote = F, sep = "\t")
# }
# 
# if (!interactive()) {
#   singlebp2bed(input)
# }

