#!/bin/bash


qsub ./pipelines/tophat_cufflinks_vesca.sh
qsub ./pipelines/tophat_50samples.sh
qsub ./pipelines/cufflinks_50samples.sh

#to find which cufflinks jobs failed
qacct -j 6272642\
    | grep -e 'failed' -e 'exit_status' -e 'taskid' -e 'maxvmem'\
    | awk '{printf " %s",$0}  /maxvmem/{printf "\n"}'\
    | grep 'exit_status  134'

export PATH=${PATH}:/home/vicker/programs/bowtie2-2.2.3
export PATH=${PATH}:/home/vicker/programs/samtools-1.1

#merge bams produced by tophat
~/programs/samtools-1.1/samtools merge -f ./tuxedo_merged/merged.bam\
                                          ./tuxedo_[SHY]*/accepted_hits.bam

#make hints
~/programs/augustus-3.0.3/auxprogs/bam2hints/bam2hints\
    --intronsonly --minintronlen=15\
    --in=tuxedo_merged/merged.bam\
    --out=tuxedo_merged/intronhints.gff

#merge transcripts into master transcriptome
ls -1 ./tuxedo_[SHY]*/transcripts.gtf > ./tuxedo_merged/gtf_list

export PATH=${PATH}:/home/vicker/programs/bowtie2-2.2.3
export PATH=${PATH}:/home/vicker/programs/samtools-1.1
export PATH=${PATH}:/home/vicker/programs/cufflinks-2.2.1.Linux_x86_64
~/programs/cufflinks-2.2.1.Linux_x86_64/cuffmerge\
    -o ./tuxedo_merged\
    -s ./refseq/fvesca_v1.1_pseudo_and_unanchored.fa\
    ./tuxedo_merged/gtf_list

./utils/cuffmerge2hint.py --inp ./tuxedo_merged/merged.gtf\
                          --hint_type exonpart\
                          --out ./tuxedo_merged/augustus_exon_hints.gff
    
cat ./tuxedo_merged/intronhints.gff ./tuxedo_merged/augustus_exon_hints.gff\
    > ./tuxedo_merged/combined_hints.gff
