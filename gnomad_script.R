if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("SNPlocs.Hsapiens.dbSNP144.GRCh37", version = "3.8")
BiocManager::install("MafDb.gnomAD.r2.1.hs37d5", version = "3.8")

install.packages("S4Vectors")

# install.packages("SNPlocs.Hsapiens.dbSNP144.GRCh37")
# install.packages("MafDb.gnomAD.r2.0.1.hs37d5")
# These did not work

library(SNPlocs.Hsapiens.dbSNP144.GRCh37)
library(MafDb.gnomAD.r2.0.1.hs37d5)
library(S4Vectors)

ls("package:MafDb.gnomAD.r2.0.1.hs37d5")
mafdb <- MafDb.gnomAD.r2.0.1.hs37d5
mafdb
citation(mafdb)
populations(mafdb)

snpdb <- SNPlocs.Hsapiens.db
SNP144.GRCh37rng <- snpsById(snpdb, ids="rs1129038")
rng
gscores(mafdb, rng)
gscores(mafdb, GRanges("15:28356859"))

chr1 <- readRDS("~/Downloads/MafDb.gnomAD.r2.1.hs37d5/inst/extdata/MafDb.gnomAD.r2.1.hs37d5.RLEnonsnv.AF.1.rds")

chr1 <- 

write.csv()
