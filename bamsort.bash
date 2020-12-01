
#!/bin/bash

cd hisat2_output

input=(mock{1..3} CoV{1..3})

for f in ${input[*]}

do
    samtools sort $f.bam -o $f.sorted.bam

done 


cd ..
