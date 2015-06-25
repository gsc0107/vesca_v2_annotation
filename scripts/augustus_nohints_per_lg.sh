#$ -S /bin/bash
#$ -N augustus
#$ -o logs/$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -cwd
#$ -V
#$ -l h_vmem=4G
#$ -l mem_free=4G
#$ -l virtual_free=4G
#$ -l h_rt=999:00:00
###$ -l h=blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace
#$ -t 1-8
####$ -pe smp 4

#
# augustus ab initio gene prediction
#

set -e
set -u
set -o pipefail

lg_name=$(head -n ${SGE_TASK_ID} ./augustus_nohints/lg_names | tail -n 1)
refseq=./refseq/unmasked.fa
outdir=./augustus_nohints

./utils/extract_records.py --inp ${refseq}\
                           --seqid ${lg_name}\
                           --out ./tmp/${lg_name}.fa

export AUGUSTUS_CONFIG_PATH=/home/vicker/programs/augustus-3.0.3/config

/home/vicker/programs/augustus-3.0.3/bin/augustus\
    --species=arabidopsis\
    ./tmp/${lg_name}.fa\
    > ${outdir}/${lg_name}.out
    
cat ${outdir}/${lg_name}.out\
    | /home/vicker/programs/augustus-3.0.3/scripts/augustus2gbrowse.pl\
    > ${outdir}/${lg_name}.out.gff
    
./utils/augustus2gff.py --inp ${outdir}/${lg_name}.out.gff\
                        --prefix ${lg_name}\
                        --out ${outdir}/${lg_name}.out.gff3
