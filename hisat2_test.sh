#!/bin/bash 


mkdir hisat2_output

cd hisat2_output  

raw=(mock{1..3} CoV{1..3})
path=../rawdata

for f in ${raw[*]} 

do 

    hisat2 -q -p 8 --seed 23 -x ../reference_genome/index -U $path/$f.fastq -S $f.sam 

done 

cd ..



