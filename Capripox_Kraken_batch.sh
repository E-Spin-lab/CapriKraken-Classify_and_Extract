CapripoxDirectory="/path/to/project/"
ExtractReadDirectory="/path/to/project/Illumina/directories/"
DB="/path/to/Kraken/minikraken_20171101_8GB_dustmasked"
FileLocations="MetadataNew_Master.csv"

## Capripox Taxonomic ID
Capripox________Parent="10265"

tail -n +2 $CapripoxDirectory$FileLocations | while read LINE; do
    
    ## Parsing CSV for metadata
    Virus="$(cut -d',' -f2 <<< $LINE)"
    Sample="$(cut -d',' -f9 <<< $LINE)"
    Read01=$CapripoxDirectory"$(cut -d',' -f10 <<< $LINE)"
    Read02=$CapripoxDirectory"$(cut -d',' -f11 <<< $LINE)"
    Read03=$CapripoxDirectory"$(cut -d',' -f12 <<< $LINE)"
    Read04=$CapripoxDirectory"$(cut -d',' -f13 <<< $LINE)"

    ## Set Kraken output file names
    paired_01_kraken=$DB"/Capripox_Batch/"$Sample"_output.kraken"
    paired_02_kraken=$DB"/Capripox_Batch/"$Sample"_output_2.kraken"

    ## Set Extracted Paired-Read File Names
    Classified_read_01=$CapripoxDirectory$ExtractReadDirectory$Sample"_classified_Capri_R1.fastq"
    Classified_read_02=$CapripoxDirectory$ExtractReadDirectory$Sample"_classified_Capri_R2.fastq"
    Classified_read_03=$CapripoxDirectory$ExtractReadDirectory$Sample"_classified_Capri_R3.fastq"
    Classified_read_04=$CapripoxDirectory$ExtractReadDirectory$Sample"_classified_Capri_R4.fastq"

    taxid=$Capripox________Parent

    echo $Virus
    echo $Sample
    echo $taxid
    echo ""
    echo $Read01
    echo $Read02
    echo $Read03
    echo $Read04
    echo "#########################################"
    
    # Create batch file 01
    echo \
"#!/usr/bin/env bash
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --partition=cpu_compute
#SBATCH --cpus-per-task=96
#SBATCH --job-name=${Sample}
#SBATCH --time=7-10:00:00
#SBATCH --output=${Sample}_capri_01.log

module load kraken
module load kraken_tools

kraken --fastq-input ${Read01} ${Read02} --paired --gzip-compressed --db ${DB} --threads 95 --only-classified-output --out-fmt interleaved> ${paired_01_kraken}
kraken-report --db ${DB} ${paired_01_kraken} > ${paired_01_kraken}_report.txt
extract_kraken_reads.py -k ${paired_01_kraken} -s ${Read01} -s2 ${Read02} -t ${taxid} -r ${paired_01_kraken}_report.txt --fastq-output -o ${Classified_read_01} -o2 ${Classified_read_02} --include-children
gzip ${Classified_read_01}
gzip ${Classified_read_02}"\
    > $Sample"_capri_01.sh"
    
        # Create batch file 02
        echo \
"#!/usr/bin/env bash
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --partition=cpu_compute
#SBATCH --cpus-per-task=96
#SBATCH --job-name=${Sample}
#SBATCH --time=7-10:00:00
#SBATCH --output=${Sample}_capri_02.log

module load kraken
module load kraken_tools

kraken --fastq-input ${Read03} ${Read04} --paired --gzip-compressed --db ${DB} --threads 95 --only-classified-output --out-fmt interleaved> ${paired_02_kraken}
kraken-report --db ${DB} ${paired_02_kraken} > ${paired_02_kraken}_report.txt
extract_kraken_reads.py -k ${paired_02_kraken} -s ${Read03} -s2 ${Read04} -t ${taxid} -r ${paired_02_kraken}_report.txt --fastq-output -o ${Classified_read_03} -o2 ${Classified_read_04} --include-children
gzip ${Classified_read_03}
gzip ${Classified_read_04}"\
    > $Sample"_capri_02.sh"

    
    # Run batch files
    sbatch $Sample"_capri_01.sh"
    sbatch $Sample"_capri_02.sh"

done
echo "Complete"
