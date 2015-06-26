#!/bin/bash

#get vesca transcriptome data set SRA065786
#create SraAccList.txt by visiting:
#http://www.ncbi.nlm.nih.gov/sra/?term=SRA065786
#then clicking:
#send to => file => accession list => SraAccList.txt
mkdir -p vesca_transcriptome
cd vesca_transcriptome
for x in $(cat SraAccList.txt)
do
    /home/vicker/programs/sra_sdk-2.3.5-2/linux/gcc/stat/x86_64/rel/bin/fastq-dump \
        --split-files ${x}
    sleep 5 #make sure we don't send requests too fast
done
cd ..

#fastqc raw data
qsub ./scripts/fastqc_50samples_1.sh

#find which quality score encoding scheme each file uses
#output to a file, one line per sample
#check_fastq_quality.py measures the range of ascii values
#encountered in the quality scores
#66...105 indicates phred64 (Illumina v1.5)
#35...74 indicates phred33 (Sanger)
#this info is also available from fastqc output
for x in $(ls -1 ./vesca_transcriptome/SRR*fastq)
do
    ./utils/check_fastq_quality.py \
        --inp ${x} \
        --samples 100 \
    | xargs echo $(basename ${x})
done \
    | sed 's/66 105/phred64/g' \
    | sed 's/35 74/phred33/g' \
    > ./vesca_transcriptome/phred_type

#find which adapter seqs are present using blast on a sample of reads
#outputs to a csv file
#helpful to choose which sequences to give to trimmomatic for trimming
./utils/find_adapters.sh --adapters "/home/vicker/programs/Trimmomatic-0.32/adapters/*.fa" \
                         --fastqs "./vesca_transcriptome/SRR*fastq" \
                         --reads 5000 \
                         --outcsv ./vesca_transcriptome/adapter_info.csv

#remove adapter seqs convert all quality scores to PHRED33
qsub ./scripts/trimmomatic1_50samples.sh

#run fastqc again
qsub ./scripts/fastqc_50samples_2.sh

#quality trimming
qsub ./scripts/trimmomatic2_50samples.sh

#the remaining bias in base composition in the first few bases is likely
#due to the random hexamer primers used in the RNAseq protocol
#I have not trimmed them off
