#$ -S /bin/bash
#$ -N fastqc
#$ -o logs/$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -cwd
#$ -l h_vmem=2G
#$ -l mem_free=2G
#$ -l virtual_free=2G
#$ -l h_rt=999:00:00
#$ -l h=blacklace04.blacklace|blacklace05.blacklace|blacklace03.blacklace
#$ -t 1-12
#$ -tc 6

fastq=$(ls -1 ./jd_rnaseq/*.fq|head -n ${SGE_TASK_ID}|tail -n 1)
sample=$(basename ${fastq} .fastq)
outdir=./fastqc/${sample}_rnaqc1

mkdir -p ${outdir}

#java heap size: threads * 250M
/home/master_files/prog_master/prog/FastQC/fastqc\
    --outdir ${outdir}\
    --threads 1\
    ${fastq}
