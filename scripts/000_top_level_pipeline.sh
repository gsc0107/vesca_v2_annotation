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
./scripts/qc_rnaseq_50samples.sh

#qc 6 sample RNAseq data set
./scripts/qc_rnaseq_6samples.sh

#remove mildew contamination from 6 sample RNAseq data set
./scripts/remove_mildew_6samples.sh

#create reference guided transcripts using tophat/cufflinks
./scripts/tuxedo_all_samples.sh

#create denovo assembled transcripts using trinity
./scripts/trinity_all_samples.sh

#augustus without hints using arabidopsis model
./scripts/augustus_nohints.sh

#augustus with hints
./scripts/augustus_hints.sh
