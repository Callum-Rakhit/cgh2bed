# cgh2bed

The "old_cgh_array_main.sh" was used to convert exported CGH data into a bed file summary.

 SNPs were taken from gnomAD and needed to have a AF of between 0.45 and 0.7. The "main.sh" was used to create a "SNP backbone" throughout the genome, with different regions having different resolutions. These were the most SNP dense 100bp region per 1Mb for normal areas and 0.5Mb for key areas listed in the test directory. All SNPs for the C19MC region were also included.
