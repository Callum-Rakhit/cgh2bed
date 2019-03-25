#!/usr/bin/env sh

# Get the human genome, make a bed file out of it
wget "hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/hg19.2bit"
twoBitToFa hg19.2bit human_hg19.fa
samtools faidx human_hg19.fa
awk '{print $1 "\t0\t" $2}' human_hg19.fa.fai > human_hg19.bed
bedtools merge -i human_hg19.bed -d 10000 > human_hg19.bed

# Get the gnomAD data
wget "gnomad.com/wholegenome"

# Filter on AF and remove all INFO except AF from gnomad whole genome dowload
bcftools filter -i "INFO/AF>0.45 && INFO/AF<0.7" wholegenome.vcf.bgz | bcftools annotate -x ^INFO/AF | bgzip > wholegenome_AF_filter.vcf.bgz

# Filter out fails
bcftools view -Oz -f .,PASS wholegenome_AF_filter.vcf.bgz > wholegenome_AF_PASS_filtered.vcf.bgz

# Filter out INDELs/non-SNPs
bcftools view --types snps wholegenome_AF_PASS_filtered.vcf.bgz > wholegenome_AF_PASS_SNP_filtered.vcf

###########################################
#  Now using the genome_bins.bed to make  #
#    a bunch of vcf files for each bin    #
###########################################

# Create the regions (genome_bins) bed to pass to tabix
Rscript /mnt/shared_data/Callum/cgh2bed/cgh2bed/genome_splitter.R /mnt/shared_data/Callum/cgh2bed/cgh2bed/hg19_slim_sorted.nochr.bed /mnt/shared_data/Callum/cgh2bed/cgh2bed/genome_bins_1Mb.bed

temp=$(wc -l <genome_bins.bed)

for i in $(seq 1 $temp); do head -$i genome_bins_1Mb.bed | tail -1 > temp_tabix.bed; tabix -h -R temp_tabix.bed no_header_wholegenome_AF_PASS_SNP_filtered.vcf.gz > ./temp_folder_1/${i}_vcf.vcf; done

# Remove VCF header
for i in *.vcf; do egrep -v "^#" $i > no_header_${i}; done

# Remove empty vcf files 
find . -size 0 -delete

################################################
#  Split each vcf into chucks, pick the        #
#  largest file (i.e. highest number of SNPs)  #
################################################

##### Create bigzip and index files for tabix #####

# Bigzip the vcfs
for i in *vcf; do bgzip -c ${i} > ${i}.gz; done

# Create tabix index
for i in *vcf.gz; do tabix -p vcf ${i}; done

##### Tabix makes ~5,000 regions, pick largest, delete rest #####

# Make the output files
for i in *vcf; do Rscript /mnt/shared_data/Callum/cgh2bed/SNP_maximiser.R /mnt/shared_data/Callum/cgh2bed/temp_folder_0.5_unique/no_empties/${i} /mnt/shared_data/Callum/cgh2bed/temp_folder_0.5_unique/no_empties/temp_for_the_6000/${i}_output.bed; done

# Tabix a vcf based on the regions created for it
biggest_vcf () {
  for vcf in *vcf;
  do temp=$(wc -l < ./temp_for_the_6000/${vcf}_output.bed);
  for i in $(seq 1 $temp); 
  do head -$i ./temp_for_the_6000/${vcf}_output.bed | tail -1 > temp_tabix.bed; 
  tabix -h -R temp_tabix.bed ${vcf}.gz > ./temp_for_the_6000/${i}_${vcf};
  done;
  cp `find -L temp_for_the_6000 -maxdepth 1 -name \*.vcf -printf '%s %p\n' | sort -nr | head -1 | awk '{print $2}'` ./biggest_vcfs
  rm temp_tabix.bed
  rm ./temp_for_the_6000/*.vcf
  done
}

biggest_vcf # Run the function

# Paste all the vcfs into one file
for i in *.vcf; do cat ${i} >> collated_vcf.vcf; done

#  1Mbformost_0.5forsome_plusC19M_1.bed

# convert vcf into a bed
# awk '{print $1, $2, $2+1, $3"_"$8}' collated_vcf.vcf >> collated_bed.bed
awk '{print $1, $2, $2+1, $3}' collated_vcf.vcf >> collated_bed.bed

# Change whitespace to tab
sed -i.bak 's/ /\t/g' collated_bed.bed

# Sort the bed file
sortBed -i collated_bed.bed > collated_sorted_bed.bed

# Merge the bedtools regions based on overlap, save the features in the fourth column
bedtools merge -i collated_sorted_bed.bed -d 100 -c 4 -o collapse -delim "|" > collated_sorted_merged_bed.bed

# Filter based on the key regions of the test directory
bedtools intersect -a regions_0.5Mb_unique.bed -b targets_0.5Mb.bed > ./regions_0.5Mb_key_unique.bed

# Merge the three bed files
cat regions_0.5Mb_key_unique.bed regions_1Mb_unique.bed regions_miRNA.bed > 1Mbformost_0.5forsome_plusC19M_unique.bed
sortBed -i 1Mbformost_0.5forsome_plusC19M_unique.bed > 1Mbformost_0.5forsome_plusC19M_unique1.bed
bedtools merge -i 1Mbformost_0.5forsome_plusC19M_unique1.bed -d 100 -c 4 -o collapse -delim "|" > 1Mbformost_0.5forsome_plusC19M_unique.bed

##########################
# Calculating uniqueness #
##########################

# Download the uniqueness bed track from UCSC


# Filter based on the gnomAD SNPs we have

# Copy column 4
awk '{print $4}' < no_header_wholegenome_AF_PASS_SNP_filtered.bed | paste unique_scored_SNPs.bed - >unique_scored_SNPs_5cols.bed

# Remove all unique scores under 0.5
awk '{ if ($4 > 0.6) { print } }' unique_scored_SNPs_5cols.bed > perfectly_unique_SNPs.bed

# Remove the uniqueness score (all 1 now)
awk '{print $1, $2, $3, $5}' perfectly_unique_SNPs.bed > perfectly_1_unique_SNPs.bed
