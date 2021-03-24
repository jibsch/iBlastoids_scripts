#!/bin/bash
# Script to deconvolute donors from scRNA-seq using vireo

### Setup
# Commands to install cellSNP and vireo
pip install -U cellSNP
pip install vireoSNP

# Download vcf file
wget http://ufpr.dl.sourceforge.net/project/cellsnp/SNPlist/genome1K.phase3.SNP_AF5e2.chr1toX.hg19.vcf.gz
gunzip genome1K.phase3.SNP_AF5e2.chr1toX.hg19.vcf.gz


### Start running
# cellSNP to pileup expressed alleles
# input: iBlastoid.bam: BAM file from cellranger
#        iBlastoid_barcodes.tsv: filtered barcodes from cellranger
#        genome1K.phase3.SNP_AF5e2.chr1toX.hg19.vcf: 1000 genome project SNPs
cellSNP -s iBlastoid.bam -b iBlastoid_barcodes.tsv -O ~/fastq/fastq_iBlast_10X/ -R genome1K.phase3.SNP_AF5e2.chr1toX.hg19.vcf -p 20 --minMAF 0.1 --minCOUNT 20

# vireo to demultiplex single-cell library
# input: cellSNP.cells.vcf: vcf generated by cellSNP
vireo -c ~/fastq/fastq_iBlast_10X/cellSNP.cells.vcf -N 2 -o ~/fastq/fastq_iBlast_10X/ --randSeed=42

# final output: donor_ids.tsv
