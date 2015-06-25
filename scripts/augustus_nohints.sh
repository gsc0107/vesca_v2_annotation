#!/bin/bash

#make list of chromosome names
cat ./refseq/unmasked.fa | grep '^>' | sed 's/>//g' > ./augustus_nohints/lg_names

#run one augustus job per chromosome
qsub ./scripts/augustus_nohints_per_lg.sh
