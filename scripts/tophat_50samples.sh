#$ -S /bin/bash
#$ -N tophat
#$ -o logs/$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -cwd
#$ -l h_vmem=3G
#$ -l mem_free=3G
#$ -l virtual_free=3G
#$ -l h_rt=999:00:00
#$ -l h=blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace
#$ -t 1-50
#$ -tc 5

# assemble RNA seq data using tophat/cufflinks

set -eu
set -o pipefail

export PATH=${PATH}:/home/vicker/programs/bowtie2-2.2.3
export PATH=${PATH}:/home/vicker/programs/samtools-1.1
export PATH=${PATH}:/home/vicker/programs/cufflinks-2.2.1.Linux_x86_64

ref=./refseq/unmasked.fa

#process largest files first
fastq=$(ls -1S ./rna_qc2/SRR*.fastq | head -n ${SGE_TASK_ID} | tail -n 1)
sample=$(basename ${fastq} .fastq)
outdir=tuxedo/${sample}

echo sample is ${sample}, fastq is ${fastq}, outdir is ${outdir}
mkdir -p ${outdir}

/home/vicker/programs/tophat-2.0.13.Linux_x86_64/tophat\
    --no-coverage-search\
    --min-intron-length 50\
    --max-intron-length 2000\
    --max-multihits 1\
    --b2-very-sensitive\
    -o ${outdir} ${ref} ${fastq}
