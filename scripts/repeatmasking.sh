#!/bin/bash

#
# repeat masking with transposon_psi and repeatmasker
#

qsub ./scripts/transposon_psi.sh

qsub ./scripts/repeat_mask_vesca.sh
