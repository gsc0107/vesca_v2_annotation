#$ -S /bin/bash
#$ -N trinity
#$ -o logs/$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -V
#$ -cwd
#$ -l h_vmem=10G
#$ -l mem_free=10G
#$ -l virtual_free=10G
#$ -l h_rt=999:00:00
####$ -l h=blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace
#$ -t 1-6
#$ -tc 2
#$ -pe smp 4

# assemble RNA seq data using trinity

set -eu
set -o pipefail

#process largest files first
fastq1=$(ls -1S ./tophat_mildew/*/*_R1.fq | head -n ${SGE_TASK_ID} | tail -n 1)
fastq2=$(echo ${fastq1} | sed 's/_R1/_R2/g')
sample=$(echo ${fastq1} | cut -d '/' -f 3)
outdir=trinity/${sample}

#export PATH=/home/vicker/programs/bowtie2-2.2.3:${PATH}
export PATH=/home/vicker/programs/samtools-1.1:${PATH}
export PATH=/home/vicker/programs/bowtie-1.1.1:${PATH}
export PATH=/home/vicker/programs/trinityrnaseq_r20140717:${PATH}

/home/vicker/programs/trinityrnaseq_r20140717/Trinity\
    --seqType fq --JM 39G --CPU 4\
    --left ${fastq1} --right ${fastq2} --output ${outdir}
