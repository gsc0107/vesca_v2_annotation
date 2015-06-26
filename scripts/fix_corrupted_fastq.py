#!/usr/bin/python

'''
rescue usable read pairs from a pair of fastq files
for some read pairs R2 is over written with nulls
method assumes all read pairs have matching read lengths for
read1 and read2 which is true the the data set concerned

the first corrupted R2 read is
@HWI-ST759:176:C1D9KACXX:6:2312:7768:57503 2:N:0:GTGAAA

R2 data is apparently overwritten by null bytes (0's) for about 5% of the file
'''

import sys,argparse

ap = argparse.ArgumentParser(description=__doc__,formatter_class=argparse.ArgumentDefaultsHelpFormatter)
ap.add_argument('--inp1',required=True,type=str,help='input FASTQ read1')
ap.add_argument('--inp2',required=True,type=str,help='input FASTQ read2')
ap.add_argument('--out1',required=True,type=str,help='output FASTQ read1')
ap.add_argument('--out2',required=True,type=str,help='output FASTQ read2')
conf = ap.parse_args()

#note template placeholders
f1 = open(conf.inp1)
f2 = open(conf.inp2)

fout1 = open(conf.out1,'wb')
fout2 = open(conf.out2,'wb')

while True:
    #read four line from R1 file
    fq1 = [f1.readline() for i in xrange(4)]
    if fq1[0] == '': break #end of file
    fq1 = [x.strip() for x in fq1]

    #assumes R2 is always same number of bases as R1
    #which happens to be true for the present case
    #but will not hold generally
    fq2 = f2.read(f1.tell() - f2.tell())

    if '\0' in fq2:
        #treat R2 as corrupted if it contains null bytes
        #fout3.write('\n'.join(fq1) + '\n')
        continue

    #treat R2 as uncorrupted
    fq2 = [x.strip() for x in fq2.strip().split('\n')]

    assert fq1[0].split()[0] == fq2[0].split()[0] #verify correct pairing

    fout1.write('\n'.join(fq1) + '\n')
    fout2.write('\n'.join(fq2) + '\n')

f1.close()
f2.close()

fout1.close()
fout2.close()
