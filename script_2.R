data <- read.csv("~/Documents/CGH2BED/CGH info/summary.bed", sep = "\t")
# hg19 <- read.csv("~/Documents/CGH2BED/hg19.bed", sep = "\t")

summary_over_100 <- read.csv("~/Documents/CGH2BED/CGH info/summary_per_base_over_100.txt", sep = "\t", header = T)
summary_over_100$Freq <- summary_over_100$X104
summary_over_100$X104 <- summary_over_100$X74631690+1

summary_over_100 <- summary_over_100[c("chr10", "X74631690", "X104", "Freq")]

summary_over_100

write.table(summary_over_100, file = "~/Documents/CGH2BED/CGH info/summary_over_100_as_bed.bed", 
            col.names = F, row.names = F, quote = F, sep = "\t")

