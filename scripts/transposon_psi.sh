#$ -S /bin/bash
#$ -N transposon_psi
#$ -o logs/$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -cwd
#$ -V
#$ -l h_vmem=3G
####$ -l h=blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace
#$ -t 1-1

#run transposonPSI on vesca

set -eu
set -o pipefail

#legacy blast
export PATH=/home/vicker/programs/blast-2.2.26/bin:${PATH}

export PERL5LIB=${PERL5LIB}:~/perl5/lib/perl5

mkdir -p transposonpsi
cd transposonpsi

~/programs/TransposonPSI_08222010/transposonPSI.pl \
        ../refseq/unmasked.fa \
        nuc
