# Script to pick SNPs at evenly spaced intervals
# of 500,000 from across the genome

install.packages("tabix")
library(tabix)

hg19 <- read.delim("~/cgh2bed/hg19_slim_sorted.nochr.bed", header = F)
data <- read.delim("~/cgh2bed/no_header_wholegenome_AF_PASS_SNP_filtered.vcf", header = F)
example_vcf <- read.delim("~/cgh2bed/temp_folder/no_header1_vcf.vcf", header = F)

options(scipen = 999) # Remove scientific notation


binmaker <- function(input, output_name){
  output_name <- data.frame(matrix(ncol = 3, nrow = 0))
  for(i in 1:dim(input)[1]){
    chr <- hg19[i,][1]
    start <- as.integer(hg19[i,][2])
    end <- as.integer(hg19[i,][3])
    bins <- as.integer(floor(end/500000))
    tmp_value <- 0
    for (i in ((1:bins)-1)){
      tmp_value_old <- tmp_value
      tmp_value <- tmp_value + 500000
      names(output_name) <- c("Chr", "Start", "End")
      output_name[nrow(output_name) + 1,] <- list(as.character(chr[1,]), tmp_value_old+1, tmp_value)
    }
    output_name[nrow(output_name) + 1,] <- list(as.character(chr[1,]), tmp_value_old+500001, end)
  }
  return(output_name)
}


# for(i in 1:24){
#   chr <- hg19[i,][1]
#   hist_data <- data[(data$V1 == as.character(chr[1,])),]
#   hist(hist_data$V2, breaks = 600, xlab = as.character(chr[1,]))
#   }

chr1 <- data[(data$V1 == "1"),]
chr2 <- data[(data$V1 == "2"),]
chr9 <- data[(data$V1 == "9"),]
chr16 <- data[(data$V1 == "16"),]

hist(chr1$V2, breaks = 600, xlab = "chr1")
hist(chr2$V2, breaks = 600, xlab = "chr2")
hist(chr9$V2, breaks = 600, xlab = "chr9")
hist(chr16$V2, breaks = 600, xlab = "chr16")

df <- binmaker(hg19, df)
df <- apply(df, 2, as.character) # Flattens the data frame so you can write to file

write.table(x = df, file = "~/cgh2bed/genome_bins.bed", 
            sep = "\t", quote = F, row.names = F, col.names = F)

example_vcf <- read.delim("~/cgh2bed/temp_folder/1_vcf.vcf", header = F)

binmaker2electricboogaloo <- function(example_vcf, output_name){
  output_name <- data.frame(matrix(ncol = 3, nrow = 0))
    chr <- example_vcf[1,][1]
    start <- as.integer(example_vcf[1,][2])
    end <- as.integer(tail(example_vcf[2], 1))
    bins <- as.integer(floor((end-start)/100))
    tmp_value <- start
    for (i in (1:(bins-1))){
      tmp_value_old <- tmp_value
      tmp_value <- tmp_value + 100
      names(output_name) <- c("Chr", "Start", "End")
      output_name[nrow(output_name) + 1,] <- list(
        as.character(chr[1,]), tmp_value_old+1, tmp_value)
    }
    output_name[nrow(output_name) + 1,] <- list(
      as.character(chr[1,]), tmp_value_old+101, end)
  return(output_name)
}

example_output <- binmaker2electricboogaloo(example_vcf, example_output)

write.table(x = example_output, file = "~/cgh2bed/temp_folder/largest_vcf_of_100_bins.bed", 
            sep = "\t", quote = F, row.names = F, col.names = F)

