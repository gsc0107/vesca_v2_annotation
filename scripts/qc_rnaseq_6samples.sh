#!/bin/bash

#rescue usable data from corrupted fastq
./scripts/fix_corrupted_fastq.py --inp1 ./jd_rnaseq/HC_R1_error\
                                 --inp2 ./jd_rnaseq/HC_R2_error\
                                 --out1 ./jd_rnaseq/HC_R1.fq\
                                 --out2 ./jd_rnaseq/HC_R2.fq

#fastqc raw data
qsub ./scripts/fastqc_6samples_1.sh

#find which quality score encoding scheme each file uses
#check_fastq_quality.py measures the range of ascii values
#encountered in the quality scores
#35...74 indicates phred33 (Sanger)
#all files were Sanger / phred33
#this info is also available from fastqc output
for x in $(ls -1 ./jd_rnaseq/*.fq)
do
    ./utils/check_fastq_quality.py \
        --inp ${x} \
        --samples 200 \
    | xargs echo $(basename ${x})
done

#find which adapter seqs are present using blast on a sample of reads
#outputs to a csv file
#helpful to choose which sequences to give to trimmomatic for trimming
./utils/find_adapters.sh --adapters "/home/vicker/programs/Trimmomatic-0.32/adapters/*.fa" \
                         --fastqs "./jd_rnaseq/*.fq" \
                         --reads 15000 \
                         --outcsv ./jd_rnaseq/adapter_info.csv

#remove adapter seqs
mkdir -p ./jd_rnaseq_qc1
qsub ./scripts/trimmomatic1_6samples.sh

#quality trimming
mkdir -p ./jd_rnaseq_qc2
qsub ./scripts/trimmomatic2_6samples.sh

#the remaining bias in base composition in the first few bases is likely
#due to the random hexamer primers used in the RNAseq protocol
#I have not trimmed them off
