#!/bin/bash

#
# reference guided assembly of transcripts
# from RNAseq data mapped against the genome
#

export PATH=${PATH}:/home/vicker/programs/bowtie2-2.2.3
export PATH=${PATH}:/home/vicker/programs/samtools-1.1
export PATH=${PATH}:/home/vicker/programs/cufflinks-2.2.1.Linux_x86_64

#make bowtie index
~/programs/bowtie2-2.2.3/bowtie2-build\
    ./refseq/unmasked.fa\
    ./refseq/unmasked.fa

#run tophat+cufflinks on SRA065786 dataset
#map samples individually
qsub ./scripts/tophat_50samples.sh
qsub ./scripts/cufflinks_50samples.sh

#run tophat+cufflinks on SRA065786 dataset
#treat data pooled into 3 batches (achene, receptacle, vegetative)
qsub ./scripts/tophat_50samples_3batch.sh
qsub ./scripts/cufflinks_50samples_3batch.sh

#run tophat+cufflinks on JD dataset
#treat each sample separately
qsub ./scripts/tophat_6samples.sh
qsub ./scripts/cufflinks_6samples.sh

export PATH=${PATH}:/home/vicker/programs/bowtie2-2.2.3
export PATH=${PATH}:/home/vicker/programs/samtools-1.1
export PATH=${PATH}:/home/vicker/programs/cufflinks-2.2.1.Linux_x86_64
mkdir -p ./tuxedo_merged

#merge transcripts into master transcriptome
ls -1 ./tuxedo/[arvHY]*/transcripts.gtf > ./tuxedo_merged/gtf_list

./programs/cufflinks-2.2.1.Linux_x86_64/cuffmerge\
    -o ./tuxedo_merged\
    -s ./refseq/unmasked.fa\
    ./tuxedo_merged/gtf_list

#merge bams produced by tophat
./programs/samtools-1.1/samtools merge -f ./tuxedo_merged/merged.bam\
                                          ./tuxedo/[arvHY]*/accepted_hits.bam

#count transcripts (61843)
cat ./tuxedo_merged/merged.gtf | cut -f 9 | cut -d ' ' -f 4 | sort -u | wc --lines

#convert to gffutils database
./utils/make_gff_database.py --inp ./tuxedo_merged/merged.gtf\
                             --db ./tuxedo_merged/merged_gtf.db

#convert gtf database into gff file
./utils/gtfdb2gfffile.py --inpdb ./tuxedo_merged/merged_gtf.db\
                         > ./tuxedo_merged/merged.gff

#sort by seqid and start
./programs/bedtools2/bin/bedtools sort -i ./tuxedo_merged/merged.gff\
                         > ./tuxedo_merged/merged.sorted.gff

#convert to gffutils database
./utils/make_gff_database.py --inp ./tuxedo_merged/merged.sorted.gff\
                             --db ./tuxedo_merged/merged_gff.db

#extract only the longest transcript per gene
./utils/extract_longest.py --gffdb ./tuxedo_merged/merged_gff.db\
                           --type1 gene\
                           --type2 mRNA\
                           --type3 exon\
                           > ./tuxedo_merged/merged_transcripts_longest.gff

#count longest transcripts (41359)
cat ./tuxedo_merged/merged_transcripts_longest.gff | grep -w mRNA | wc --lines

#extract predicted transcripts from merged gtf file
./utils/make_gff_database.py --inp ./tuxedo_merged/merged_transcripts_longest.gff\
                             --db ./tuxedo_merged/merged_transcripts_longest.db

./utils/extract_genes2.py --inpfasta ./refseq/unmasked.fa\
                          --gffdb ./tuxedo_merged/merged_transcripts_longest.db\
                          --featuretype mRNA\
                          --subfeaturetype exon\
                          --out ./tuxedo_merged/merged_transcripts_longest.fa

#predict proteins from transcripts
outdir=./tuxedo_merged/transdecode
mkdir -p ${outdir}
cd ${outdir}
fasta=../merged_transcripts_longest.fa
~/programs/TransDecoder-2.0.1/TransDecoder.LongOrfs -t ${fasta}
~/programs/TransDecoder-2.0.1/TransDecoder.Predict -t ${fasta}
cd -
