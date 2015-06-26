#!/bin/bash

#map paired end rnaseq to downy mildew genome
qsub ./scripts/tophat_mildew_6samples.sh

#retain only unmapped read pairs
qsub ./scripts/get_unmapped_6samples.sh
