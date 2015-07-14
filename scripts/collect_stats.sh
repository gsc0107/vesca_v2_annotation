#!/bin/bash

#
# collect stats on the various outputs produced during the annotation
#

mkdir -p stats

#print sample name, number of transcripts, min, max and mean length
function length_stats
{
    for x in $@
    do
        sample=$(dirname ${x}|cut -d '/' -f 3)
        transcripts=$(grep -cw 'transcript' ${x})
        stats=$(cat ${x} | grep -w transcript\
                 | awk '{print $5-$4}'\
                 | Rscript -e 'x=scan(file("stdin"));min(x);max(x);mean(x)' 2> /dev/null\
                 | sed 's/\[1\]//g')
        minlen=$(echo ${stats} | cut -d ' ' -f 1)
        maxlen=$(echo ${stats} | cut -d ' ' -f 2)
        meanlen=$(echo ${stats} | cut -d ' ' -f 3)
        echo ${sample},${transcripts},${minlen},${maxlen},${meanlen}
    done
}

#collect transcript stats from tuxedo reference guided transcriptome assemblies
length_stats $(ls -1 ./tuxedo/[arv]*/transcripts.gtf) > ./stats/tuxedo_arv.csv
length_stats $(ls -1 ./tuxedo/[HY]*/transcripts.gtf) > ./stats/tuxedo_HY.csv
length_stats $(ls -1 ./tuxedo/SRR*/transcripts.gtf) > ./stats/tuxedo_SRR.csv


