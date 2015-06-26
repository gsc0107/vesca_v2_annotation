#$ -S /bin/bash
#$ -N tophat
#$ -o logs/$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -cwd
#$ -l h_vmem=2G
#$ -l mem_free=2G
#$ -l virtual_free=2G
#$ -l h_rt=999:00:00
#$ -l h=blacklace04.blacklace|blacklace05.blacklace|blacklace03.blacklace
#$ -t 1-6
#$ -tc 6

# map RNA seq data using tophat against mildew genome

set -eu

export PATH=${PATH}:/home/vicker/programs/bowtie2-2.2.3
#export PATH=${PATH}:/home/vicker/programs/samtools-1.1

tophat=''
#cufflinks='/home/vicker/programs/cufflinks-2.2.1.Linux_x86_64/cufflinks'

#mildew
#full path might be needed here
ref='/home/vicker/vesca_annotation/downy_mildew/GCA_000151065.3_ASM15106v3_genomic.fa'
outdir='/home/vicker/vesca_annotation/tophat_mildew_@{sample}'
/home/vicker/programs/tophat-2.0.13.Linux_x86_64/tophat\
    --no-coverage-search\
    -o ${outdir}\
    ${ref}\
    @{reads1} @{reads2}
