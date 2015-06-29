#$ -S /bin/bash
#$ -N getunmapped
#$ -o logs/$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e logs/$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -cwd
#$ -l h_vmem=4G
#$ -l mem_free=4G
#$ -l virtual_free=4G
#$ -l h_rt=999:00:00
#$ -l h=blacklace04.blacklace|blacklace05.blacklace|blacklace03.blacklace
#$ -t 1-6
#$ -tc 6

# get the unmapped read pairs out of unmapped.bam from tophat

set -eu
set -o pipefail

export PATH=/home/vicker/programs/bedtools2/bin:${PATH}
export PATH=/home/vicker/programs/samtools-1.1:${PATH}

sample=$(ls -1 ./tophat_mildew | head -n ${SGE_TASK_ID} | tail -n 1)
outdir=./tophat_mildew/${sample}
inpbam=${outdir}/unmapped.bam
sortbam=${outdir}/unmapped_nsorted
fastq1=${outdir}/unmapped_R1.fq
fastq2=${outdir}/unmapped_R2.fq

echo sample $sample inpbam $inpbam sortbam $sortbam fastqs $fastq1 $fastq2

#sort fastq by query (readname), required by bedtools
#with 3.5G of RAM
#should automatically merge the subfiles as required
~/programs/samtools-1.1/samtools sort -n -m 3500000000 ${inpbam} ${sortbam}

#get only pairs where both are unmapped
#ie require unmapped and mate unmapped
#FAILED: mate unmapped flag is not set correctly
#would have been: ${samtools} view -b -f '0xC' @{sortedbam}.bam > @{filteredbam}

#convert bam into pair of fastqs
#seems to skip unpaired reads with a warning message
~/programs/bedtools2/bin/bedtools\
    bamtofastq -i ${sortbam}.bam -fq ${fastq1} -fq2 ${fastq2}

#check read pairing is intact
#valid_2fastq.py unmapped_R1.fq unmapped_R2.fq '/'
