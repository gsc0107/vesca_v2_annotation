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
###$ -l h=blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace
#$ -t 1-3
#$ -tc 2
#$ -pe smp 4

# assemble RNA seq data using trinity
# the 50 samples are combined into 3 larger batches
# achene, receptacle and vegetative

set -eu
set -o pipefail

#name of current batch
sample=$(head -n ${SGE_TASK_ID} ./trinity/50samples_grouping_names | tail -n 1)

#list of sample names to process in current batch
samplenames=$(head -n ${SGE_TASK_ID} ./trinity/50samples_grouping | tail -n 1)

#convert from sample names into fastq file names
fastqs=$(\
for x in $(echo ${samplenames} | tr ',' ' ')
do
    grep ${x} ./trinity/samplename2srrnumber.csv | cut -d ',' -f 1
done\
| awk '{if(NR>1){printf","};printf "./rna_qc2/%s_1.fastq",$0}' )

#output directory
outdir=./trinity/${sample}

#export PATH=/home/vicker/programs/bowtie2-2.2.3:${PATH}
export PATH=/home/vicker/programs/samtools-1.1:${PATH}
export PATH=/home/vicker/programs/bowtie-1.1.1:${PATH}
export PATH=/home/vicker/programs/trinityrnaseq_r20140717:${PATH}

mkdir -p ${outdir}

/home/vicker/programs/trinityrnaseq_r20140717/Trinity\
    --seqType fq --JM 39G --CPU 4\
    --single ${fastqs} --output ${outdir}
