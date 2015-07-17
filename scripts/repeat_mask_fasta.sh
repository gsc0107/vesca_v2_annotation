#$ -S /bin/bash
#$ -l h_vmem=2G
#$ -l mem_free=2G
#$ -l virtual_free=2G
#$ -l h_rt=999:00:00
####$ -pe smp 4

#
# repeat masker
#

set -eu
#set -o pipefail

~/programs/repeat_masker/RepeatMasker/RepeatMasker\
    -species "Fragaria vesca"\
    -gff\
    $1
