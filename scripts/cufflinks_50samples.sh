#$ -S /bin/bash
#$ -N cufflinks
#$ -o logs/$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -cwd
#$ -l h_vmem=3G
#$ -l mem_free=3G
#$ -l virtual_free=3G
#$ -l h_rt=999:00:00
#$ -l h=blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace
#$ -t 1-50
#$ -tc 10

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

/home/vicker/programs/cufflinks-2.2.1.Linux_x86_64/cufflinks\
    --min-isoform-fraction 0.1\
    --pre-mrna-fraction 0.15\
    --min-intron-length 50\
    --max-intron-length 2000\
    --small-anchor-fraction 0.09\
    --min-frags-per-transfrag 10\
    --max-multiread-fraction 0.05\
    -o ${outdir}\
    ${outdir}/accepted_hits.bam

#    --frag-bias-correct ${ref}
