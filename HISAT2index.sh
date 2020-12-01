#!/bin/bash



cd reference_genome 

ref_genome=*.fa 


hisat2-build -f -o 4 -t 10 --localoffrate 3 --localftabchars 6 -p 8 --seed 67 $ref_genome "index" 

cd ..


# Basic command line: hisat2-build [options] <reference_in> <ht2_base>
# -f ~ --seed: options
# "hg19.fa": <reference_in> 
# "index": <ht2_base> 




