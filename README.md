# Batch Illumina paired-end read taxonomic classification and extraction using Kraken.
This repository features Kraken_Classify_Extract, a bash script intended for the assignment of taxonomic labels to Illumina paired-read files, followed by the extraction of all reads associated with a designated taxonomic ID. A metadata file contains the Sample ID, Virus species, and full path to sequence files. This data is processed to generate and execute a bash script for each individual sample that is intended to be executed on a High-Performance Computing (HPC) system.

## Background
Capripoxvirus is a genus of large DNA viruses. Several Capripox viruses (LSDV, GTPV, SPPV) samples were sequenced for  de novo assembly. This script was developed as an initial step to enhance the efficiency of subsequent analyses by removing host (and other potential contimant) derived reads. Following processing reads were processed using a previously developed and modified ASFV assembly Pipeline. https://github.com/Global-ASFV-Research-Alliance/ASFV_Pipeline

## Requirements
--Kraken

--Kraken tools

--minikraken_20171101_8GB_dustmasked database

-- MetaData.csv

The csv file will contain all metadata and files paths associated with each sample and will contain the following headers:

*Project_ID, 
Species collection_date country location host tissue_type collected_by isolate L1R1 L1R2 L2R1 L2R2 L3R1 L3R2 L4R1 L4R2 Nanopore_Directory*


## Code

Mark the file as executable (performed once) 

    chmod +x Capripox_Kraken_batch.sh

To run

    ./Capripox_Kraken_batch.sh

A bash script will be created for each Illumina paired-read and will be analyzed on its own HPC node.

### Usage
This script was designed for a particular experiment and not for deployment, and therefore, command-line arguments were not incorporated. Future applications involving different reference genomes and experiments would require modifications to lines 1-4 & 7.