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

fastq1=$(ls -1S ./jd_rnaseq_qc2/*_R1.fq | head -n ${SGE_TASK_ID} | tail -n 1)
fastq2=$(echo ${fastq1} | sed 's/_R1/_R2/g')
sample=$(basename ${fastq1} _R1.fq)
outdir=./tophat_mildew/${sample}
ref=./downy_mildew/mildew_unmasked.fa

echo sample is ${sample}, fastqs are ${fastq1} ${fastq2}, outdir is ${outdir}
mkdir -p ${outdir}

#mildew
/home/vicker/programs/tophat-2.0.13.Linux_x86_64/tophat\
    --no-coverage-search\
    -o ${outdir}\
    ${ref}\
    ${fastq1} ${fastq2}
