#!/bin/bash

#
# denovo assembly of transcripts
#

mkdir -p ./trinity

#run trinity per sample on JD dataset
qsub ./scripts/trinity_6samples.sh

#run trinity on SRA065786 dataset
qsub ./scripts/trinity_50samples.sh


