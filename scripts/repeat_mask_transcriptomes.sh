#!/bin/bash

#
# repeat mask denovo assembled transcriptomes
#

#mkdir -p ./trinity_repeat_masked

for x in $(ls -1 ./trinity/*/Trinity.fasta)
do
    ./utils/myqsub.sh ./scripts/repeat_mask_fasta.sh ${x}
done
