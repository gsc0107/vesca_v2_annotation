#$ -S /bin/bash
#$ -o logs/$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -l h_vmem=45G
#$ -l mem_free=45G
#$ -l virtual_free=45G
#$ -l h_rt=999:00:00
#$ -t 2
#$ -tc 2
##$ -hold_jid_ad tophat50_3batch
###$ -l h=blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace

# assemble RNA seq data using tophat/cufflinks

#ram usage:
#task1 14G
#task2 > 14G

set -eu
set -o pipefail

export PATH=${PATH}:/home/vicker/programs/bowtie2-2.2.3
export PATH=${PATH}:/home/vicker/programs/samtools-1.1
export PATH=${PATH}:/home/vicker/programs/cufflinks-2.2.1.Linux_x86_64

ref=./refseq/unmasked.fa

#name of current batch
sample=$(head -n ${SGE_TASK_ID} ./auxfiles/50samples_grouping_names | tail -n 1)

outdir=tuxedo/${sample}

echo sample is ${sample}, outdir is ${outdir}
mkdir -p ${outdir}

/home/vicker/programs/cufflinks-2.2.1.Linux_x86_64/cufflinks\
    --min-isoform-fraction 0.1\
    --pre-mrna-fraction 0.15\
    --min-intron-length 50\
    --max-intron-length 2000\
    --small-anchor-fraction 0.09\
    --min-frags-per-transfrag 10\
    --max-multiread-fraction 0.05\
    --frag-bias-correct ${ref}\
    -o ${outdir}\
    ${outdir}/accepted_hits.bam
