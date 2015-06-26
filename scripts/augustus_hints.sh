#!/bin/bash

#
# run augustus with hints
#

#make intron hints from merged bam file
~/programs/augustus-3.0.3/auxprogs/bam2hints/bam2hints\
    --intronsonly --minintronlen=15\
    --in=tuxedo_merged/merged.bam\
    --out=tuxedo_merged/intronhints.gff

#make exon hints from cuffmerged gtf
./utils/cuffmerge2hint.py --inp ./tuxedo_merged/merged.gtf\
                          --hint_type exonpart\
                          --out ./tuxedo_merged/augustus_exon_hints.gff

#combine all hints
cat ./tuxedo_merged/intronhints.gff ./tuxedo_merged/augustus_exon_hints.gff\
    > ./tuxedo_merged/combined_hints.gff

#run one augustus job per chromosome
qsub ./scripts/augustus_nohints_per_lg.sh
