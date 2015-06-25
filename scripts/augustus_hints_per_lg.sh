#$ -S /bin/bash
#$ -N augustus
#$ -o logs/$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -cwd
#$ -V
#$ -l h_vmem=3G
#$ -l mem_free=3G
#$ -l virtual_free=3G
#$ -l h_rt=999:00:00
####$ -l h=blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace
#$ -t 1-8
####$ -pe smp 4

#
# augustus with hints for vesca assembly version 2
#

set -eu
set -o pipefail

export AUGUSTUS_CONFIG_PATH=/home/vicker/programs/augustus-3.0.3/config

#split into separate chromosomes
./utils/chunk_fasta.py --inp ./refseq/unmasked.fa\
                       --chunks 8 --thischunk ${SGE_TASK_ID}\ |
    /home/vicker/programs/augustus-3.0.3/bin/augustus\
        --extrinsicCfgFile=./tux_v2_merged/extrinsic.cfg\
        --hintsfile=./tux_v2_merged/combined_hints.gff\
        --species=arabidopsis\
        /dev/fd/0\
    > ./tux_v2_merged/aughints_vesca_v2.${SGE_TASK_ID}.out
    
cat ./tux_v2_merged/aughints_vesca_v2.${SGE_TASK_ID}.out\
    | /home/vicker/programs/augustus-3.0.3/scripts/augustus2gbrowse.pl\
    > ./tux_v2_merged/aughints_vesca_v2.${SGE_TASK_ID}.gff

./tools/augustus2gff.py --inp ./tux_v2_merged/aughints_vesca_v2.${SGE_TASK_ID}.gff\
                        --prefix chunk${SGE_TASK_ID}_\
                        --out ./tux_v2_merged/aughints_vesca_v2.${SGE_TASK_ID}.gff3
