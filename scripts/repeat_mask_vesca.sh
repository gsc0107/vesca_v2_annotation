#$ -S /bin/bash
#$ -N repeatmasker
#$ -o logs/$JOB_NAME.$JOB_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.err
#$ -cwd
#$ -V
#$ -l h_vmem=4G
#$ -l mem_free=4G
#$ -l virtual_free=4G
#$ -l h_rt=999:00:00
####$ -pe smp 4

#
# repeat masker
#

set -eu
set -o pipefail

~/programs/repeat_masker/RepeatMasker/RepeatMasker\
    -species "Fragaria vesca"\
    -gff\
    ./refseq/unmasked.fa
