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
#$ -t 1-50

#
# remove adapter sequences, convert all to phred33
# do not do any cropping or quality trimming yet
#

#which fastq are we processing
fastq=$(ls -1 ./vesca_transcriptome/SRR*.fastq | head -n ${SGE_TASK_ID} | tail -n 1)
sample=$(basename ${fastq} .fastq)
outdir=./rna_qc

#extract phred type
phred_type=$(cat ./vesca_transcriptome/phred_type | grep ${sample} | cut -d ' ' -f 2)

java -Xmx1g -jar /home/vicker/programs/Trimmomatic-0.32/trimmomatic-0.32.jar\
    SE -threads 1 -${phred_type} -trimlog /dev/null\
    ${fastq}\
    ${outdir}/${sample}.fastq\
    ILLUMINACLIP:/home/vicker/programs/Trimmomatic-0.32/adapters/TruSeq3-SE.fa:2:30:10\
    MINLEN:30\
    TOPHRED33
