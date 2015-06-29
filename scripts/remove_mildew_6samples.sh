#!/bin/bash

#remove soft masking
./utils/remove_soft_masking.sh\
    --inp ./downy_mildew/GCA_000151065.3_ASM15106v3_genomic.fa\
    --out ./downy_mildew/mildew_unmasked.fa

#make index
~/programs/bowtie2-2.2.3/bowtie2-build\
    ./downy_mildew/mildew_unmasked.fa\
    ./downy_mildew/mildew_unmasked.fa

#map paired end rnaseq to downy mildew genome
mkdir -p ./tophat_mildew
qsub ./scripts/tophat_mildew_6samples.sh

#retain only unmapped read pairs
qsub ./scripts/get_unmapped_6samples.sh
