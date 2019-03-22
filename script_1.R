#/usr/bin/Rscript

# Function to install packages (if not installed already) and load them

GetPackages <- function(required.packages) {
  packages.not.installed <- 
    required.packages[!(required.packages %in% installed.packages()[, "Package"])]
  if(length(packages.not.installed)){
    install.packages(packages.not.installed)}
  lapply(required.packages, require, character.only = TRUE)
}

# Install and load required packages

GetPackages(c("stringr"))

args <- commandArgs(trailingOnly = TRUE)

input = args[1]

# This function reformats the input .txt file to the bed format

CGH2BED <- function(input) {
  data <- read.csv(input, header = TRUE,
                 sep = "\t")
  Full.Location <- as.data.frame(str_split_fixed(data$Full.Location, ":", 2))
  Full.Location$Start <- (str_split_fixed(Full.Location$V2, "-", 1))
  Full.Location <- as.data.frame(str_split_fixed(Full.Location$V2, "-", 2))
  data$Full.Location.Start <- Full.Location$V1
  data$Full.Location.End <- Full.Location$V2
  data <- data[ which(data$Call == 'Pathogenic' | data$Call == 'Likely Pathogenic'),]
  bed <- data[c("Chromosome", "Full.Location.Start", "Full.Location.End",
              "Type", "CN.State")]
  bed$Strand = "+"
  bed$thickStart <- data$Min
  bed$thickEnd <- data$Max
  write.table(bed, sep="\t", file = paste("summary.bed"),
           row.names = F, col.names = F, quote = F, append = T)
}

# This function reformats the input .txt file to three bedgraphs, for LOH, gains and losses 

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

  # Covert bedgraphs into data frames

  bedgraph.LOH <- as.data.frame(bedgraph.LOH)
  bedgraph.Gain <- as.data.frame(bedgraph.Gain)
  bedgraph.Loss <- as.data.frame(bedgraph.Loss)

  # write three tables for LOH, gain and loss

  write.table(bedgraph.LOH, sep="\t", file = paste("summary_loh.bedgraph"),
              row.names = F, col.names = F, quote = F, append = F)
  write.table(bedgraph.Gain, sep="\t", file = paste("summary_gain.bedgraph"),
              row.names = F, col.names = F, quote = F, append = F)
  write.table(bedgraph.Loss, sep="\t", file = paste("summary_loss.bedgraph"),
              row.names = F, col.names = F, quote = F, append = F)
}

# Currently not using the bedgraph function

# main <- function(input) {
#   CGH2BED(input)
#   CGH2BEDgraph(input)
# }
# 
# if (!interactive()) {
#   main(input)
# }
