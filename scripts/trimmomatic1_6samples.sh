#$ -S /bin/bash
#$ -N trimmomatic
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

#
# remove adapter sequences
# do not do any cropping or quality trimming yet
# drop and unpaired reads after trimming
#

#which fastq are we processing
fastq1=$(ls -1 ./jd_rnaseq/*_R1.fq | head -n ${SGE_TASK_ID} | tail -n 1)
fastq2=$(echo ${fastq1} | sed 's/_R1/_R2/g')
sample=$(basename ${fastq1} _R1.fq)
outdir=./jd_rnaseq_qc1

#extract phred type
#phred_type=$(cat ./vesca_transcriptome/phred_type | grep ${sample} | cut -d ' ' -f 2)

java -Xmx1g -jar /home/vicker/programs/Trimmomatic-0.32/trimmomatic-0.32.jar\
    PE -threads 1 -phred33 -trimlog /dev/null\
    ${fastq1} ${fastq2}\
    ${outdir}/${sample}_R1.fq /dev/null ${outdir}/${sample}_R2.fq /dev/null\
    ILLUMINACLIP:/home/vicker/programs/Trimmomatic-0.32/adapters/TruSeq3-PE-2.fa:2:30:10\
    MINLEN:30
