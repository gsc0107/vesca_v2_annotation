#!/bin/bash

#
# repeat masking with transposon_psi and repeatmasker
#

qsub ./scripts/transposon_psi.sh

qsub ./scripts/repeat_mask_vesca.sh

#combine masking from both programs
# === VESCA ===
#apply transposonpsi masking to repeatmasker version using bedtools
./programs/bedtools2/bin/bedtools maskfasta\
    -fi  ./refseq/Fragaria_vesca_v2.0.a1_pseudomolecules.fasta.masked\
    -bed ./transposonpsi/Fragaria_vesca_v2.0.a1_pseudomolecules.fasta.TPSI.allHits.chains.bestPerLocus.gff3\
    -fo  ./refseq/final_masked.fa
