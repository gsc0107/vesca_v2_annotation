#!/bin/bash

#
# Fragaria vesca annotation top level pipeline
#
# NOTE: this script, and the subscripts, are not intended to actually
# be run as-is, they simply document the steps I took
# for example it is usually neccessary to wait for the cluster jobs
# (submitted using qsub) to complete
# before proceeding to the next step
#

#repeat masking of the genome
./scripts/repeatmasking.sh

#download and qc 50 sample RNAseq data set
./scripts/qc_vesca_transcriptome.sh

#create reference guided transcripts using tophat/cufflinks
./scripts/tuxedo_transcriptome.sh

#augustus without hints using arabidopsis model
./scripts/augustus_nohints.sh
