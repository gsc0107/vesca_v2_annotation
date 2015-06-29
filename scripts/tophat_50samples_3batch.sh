#$ -S /bin/bash
#$ -N tophat50_3batch
#$ -o logs/$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -cwd
#$ -l h_vmem=5G
#$ -l mem_free=5G
#$ -l virtual_free=5G
#$ -l h_rt=999:00:00
#$ -l h=blacklace03.blacklace|blacklace04.blacklace|blacklace05.blacklace
#$ -t 1-3
#$ -tc 1

# assemble RNA seq data using tophat/cufflinks

set -eu
set -o pipefail

export PATH=${PATH}:/home/vicker/programs/bowtie2-2.2.3
export PATH=${PATH}:/home/vicker/programs/samtools-1.1
export PATH=${PATH}:/home/vicker/programs/cufflinks-2.2.1.Linux_x86_64

ref=./refseq/unmasked.fa

#name of current batch
sample=$(head -n ${SGE_TASK_ID} ./auxfiles/50samples_grouping_names | tail -n 1)

#list of sample names to process in current batch
samplenames=$(head -n ${SGE_TASK_ID} ./auxfiles/50samples_grouping | tail -n 1)

#convert from sample names into fastq file names
fastqs=$(\
for x in $(echo ${samplenames} | tr ',' ' ')
do
    grep ${x} ./auxfiles/samplename2srrnumber.csv | cut -d ',' -f 1
done\
| awk '{if(NR>1){printf","};printf "./rna_qc2/%s_1.fastq",$0}' )

outdir=tuxedo/${sample}

echo sample is ${sample}, fastqs are ${fastqs}, outdir is ${outdir}
mkdir -p ${outdir}

/home/vicker/programs/tophat-2.0.13.Linux_x86_64/tophat\
    --no-coverage-search\
    --min-intron-length 50\
    --max-intron-length 2000\
    --max-multihits 1\
    --b2-very-sensitive\
    -o ${outdir} ${ref} ${fastqs}
