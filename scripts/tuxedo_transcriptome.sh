#!/bin/bash

#
# reference guided assembly of transcripts
# from RNAseq data mapped against the genome
#

export PATH=${PATH}:/home/vicker/programs/bowtie2-2.2.3
export PATH=${PATH}:/home/vicker/programs/samtools-1.1
export PATH=${PATH}:/home/vicker/programs/cufflinks-2.2.1.Linux_x86_64

#run tophat+cufflinks on SRA065786 dataset
qsub ./scripts/tophat_50samples.sh
qsub ./scripts/cufflinks_50samples.sh

#run tophat+cufflinks on JD dataset
qsub ./scripts/tophat_6samples.sh
qsub ./scripts/cufflinks_6samples.sh

#merge bams produced by tophat
mkdir -p ./tuxedo_merged
~/programs/samtools-1.1/samtools merge -f ./tuxedo_merged/merged.bam\
                                          ./tuxedo/[SHY]*/accepted_hits.bam

#merge transcripts into master transcriptome
ls -1 ./tuxedo/[SHY]*/transcripts.gtf > ./tuxedo_merged/gtf_list

~/programs/cufflinks-2.2.1.Linux_x86_64/cuffmerge\
    -o ./tuxedo_merged\
    -s ./refseq/unmasked.fa\
    ./tuxedo_merged/gtf_list
