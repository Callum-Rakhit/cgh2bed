library(stringr)

args <- commandArgs(trailingOnly = TRUE)

input = args[1]

CGH2BED <- function(input) {
  data <- read.csv(input, header = TRUE,
                 sep = "\t")
  Full.Location <- as.data.frame(str_split_fixed(data$Full.Location, ":", 2))
  Full.Location$Start <- (str_split_fixed(Full.Location$V2, "-", 1))
  Full.Location <- as.data.frame(str_split_fixed(Full.Location$V2, "-", 2))
  data$Full.Location.Start <- Full.Location$V1
  data$Full.Location.End <- Full.Location$V2
  bed <- data[c("Chromosome", "Full.Location.Start", "Full.Location.End",
              "Type", "CN.State")]
  bed$Strand = "+"
  bed$thickStart <- data$Min
  bed$thickEnd <- data$Max
  write.table(bed, sep="\t", file = paste("summary.bed"),
           row.names = F, col.names = F, quote = F, append = T)
}

CGH2BEDgraph <- function(input) {
  data <- read.csv(input, header = TRUE, sep = "\t")
  Full.Location <- as.data.frame(str_split_fixed(data$Full.Location, ":", 2))
  Full.Location$Start <- (str_split_fixed(Full.Location$V2, "-", 1))
  Full.Location <- as.data.frame(str_split_fixed(Full.Location$V2, "-", 2))
  
  data$Full.Location.Start <- Full.Location$V1
  data$Full.Location.End <- Full.Location$V2
  
  bedgraph <- (data[c("Chromosome", "Min", "Max", "Type")])
  bedgraph$Type <- as.character(bedgraph$Type)
  bedgraph.LOH <- bedgraph[(bedgraph$Type == "LOH"),]
  bedgraph.LOH$Type[bedgraph$Type == "LOH"] <- "1"
  bedgraph.Gain <- bedgraph[!(bedgraph$Type == "Gain"),]
  bedgraph.Gain$Type[bedgraph$Type == "Gain"] <- "1"
  bedgraph.Loss <- bedgraph[!(bedgraph$Type == "Loss"),]
  bedgraph.Loss$Type[bedgraph$Type == "Loss"] <- "1"
  
  bedgraph.LOH <- as.data.frame(bedgraph.LOH)
  bedgraph.Gain <- as.data.frame(bedgraph.Gain)
  bedgraph.Loss <- as.data.frame(bedgraph.Loss)
  
  write.table(bedgraph.LOH, sep="\t", file = paste("summary_loh.bedgraph"),
              row.names = F, col.names = F, quote = F, append = F)
  write.table(bedgraph.Gain, sep="\t", file = paste("summary_gain.bedgraph"),
              row.names = F, col.names = F, quote = F, append = F)
  write.table(bedgraph.Loss, sep="\t", file = paste("summary_loss.bedgraph"),
              row.names = F, col.names = F, quote = F, append = F)
}

CGH2BED(input)
CGH2BEDgraph(input)
