#$ -S /bin/bash
#$ -N trimmomatic
#$ -o logs/$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -cwd
#$ -l h_vmem=2G
#$ -l mem_free=2G
#$ -l virtual_free=2G
#$ -l h_rt=999:00:00
#$ -l h=blacklace04.blacklace|blacklace05.blacklace|blacklace03.blacklace|blacklace01.blacklace
#$ -t 1-50

#
# apply quality trimming
#

#which fastq are we processing
fastq=$(ls -1 ./rna_qc/SRR*.fastq | head -n ${SGE_TASK_ID} | tail -n 1)
sample=$(basename ${fastq} .fastq)
outdir=./rna_qc2

java -Xmx1g -jar /home/vicker/programs/Trimmomatic-0.32/trimmomatic-0.32.jar\
    SE -threads 1 -phred33 -trimlog /dev/null\
    ${fastq}\
    ${outdir}/${sample}.fastq\
    LEADING:10 TRAILING:10\
    SLIDINGWINDOW:4:20\
    MINLEN:30
