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

# get the unmapped read pairs out of unmapped.bam from tophat

set -e
set -u

export PATH=/home/vicker/programs/bedtools2/bin:${PATH}
export PATH=/home/vicker/programs/samtools-1.1:${PATH}

samtools='/home/vicker/programs/samtools-1.1/samtools'
bedtools='/home/vicker/programs/bedtools2/bin/bedtools'

#sort fastq by query (readname), required by bedtools
#with 3.5G of RAM
#should automatically merge the subfiles as required
${samtools} sort -n -m 3500000000 unmapped.bam unmapped_sorted

#get only pairs where both are unmapped
#ie require unmapped and mate unmapped
#FAILED: mate unmapped flag is not set correctly
#would have been: ${samtools} view -b -f '0xC' @{sortedbam}.bam > @{filteredbam}

#convert bam into pair of fastqs
#seems to skip unpaired reads with a warning message
${bedtools} bamtofastq -i unmapped_sorted.bam -fq unmapped_R1.fq -fq2 unmapped_R2.fq

#check read pairing is intact
valid_2fastq.py unmapped_R1.fq unmapped_R2.fq '/'
