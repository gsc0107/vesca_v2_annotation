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
    /home/vicker/programs/sra_sdk-2.3.5-2/linux/gcc/stat/x86_64/rel/bin/fastq-dump\
        --split-files ${x}
done
cd ..

#fastqc
qsub ./pipelines/fastqc_50samples.sh

#find which quality score encoding scheme each file uses
for x in $(ls -1 ./vesca_transcriptome/SRR*fastq)
do
    ./utils/check_fastq_quality.py\
        --inp ${x}\
        --samples 100\
    | xargs echo $(basename ${x})
done \
    | sed 's/66 105/phred64/g' \
    | sed 's/35 74/phred33/g' \
    > ./vesca_transcriptome/phred_type

#find which adapter seqs are present
./utils/find_adapters.sh --adapters "/home/vicker/programs/Trimmomatic-0.32/adapters/*.fa"\
                         --fastqs "./vesca_transcriptome/SRR*fastq"\
                         --reads 5000\
                         --outcsv ./vesca_transcriptome/adapter_info.csv

#remove adapter seqs convert all quality scores to PHRED33
qsub ./pipelines/trimmomatic1_50samples.sh

#quality trimming
qsub ./pipelines/trimmomatic2_50samples.sh
