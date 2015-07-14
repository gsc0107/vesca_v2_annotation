#!/bin/bash

#
# repeat masking with transposon_psi and repeatmasker
#

#run transposon_psi and repeat masker
qsub ./scripts/transposon_psi.sh
qsub ./scripts/repeat_mask_vesca.sh

#sort output
./programs/bedtools2/bin/bedtools sort\
    -i ./transposonpsi/tpsi_vesca.gff3\
    > ./transposonpsi/tpsi_vesca.sort.gff3

./programs/bedtools2/bin/bedtools sort\
    -i ./refseq/repeat_masker.gff\
    > ./refseq/repeat_masker.sort.gff


#combine masking from both programs
#apply transposonpsi masking to repeatmasker version using bedtools
./programs/bedtools2/bin/bedtools maskfasta\
    -fi  ./refseq/Fragaria_vesca_v2.0.a1_pseudomolecules.fasta.masked\
    -bed ./transposonpsi/Fragaria_vesca_v2.0.a1_pseudomolecules.fasta.TPSI.allHits.chains.bestPerLocus.gff3\
    -fo  ./refseq/final_masked.fa
