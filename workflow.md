## 1. Conda environment 

- **Conda**: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
- **HISAT2**: http://daehwankimlab.github.io/hisat2/manual
- **Samtools**: http://www.htslib.org/doc/samtools.html
- HISAT2 version 2.2.1 was used 


```environment.yml
name: hisat2
channels:
  - conda-forge
  - bioconda 
  - defaults 
dependencies:
  - hisat2=2.2.1
  - samtools
```

Above conda environment (**environment.yml**) was written and created by following commend. 

```termina
conda env create -f environment.yml
```


The hisat2 conda env was activated by following commend. 

```terminal
conda activate hisat2
```


## 2. Raw data
- Link: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE155518


## 3. HISAT2 

### 3-1. Indexing 

- Check out **"The hisat2-build indexer"** description in the [**hisat2 user manual**](http://daehwankimlab.github.io/hisat2/manual)
- Reference genome: ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_35/GRCh38.primary_assembly.genome.fa.gz --> manually unzip
- **reference_download.sh** was run to download the reference genome from [GENCODE](https://www.gencodegenes.org)

```bash
#!/bin/bash

# Download reference genome
mkdir reference_genome | cd reference_genome

wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_35/GRCh38.primary_assembly.genome.fa.gz


cd ..


# Download reference annotation (GTF)
mkdir reference_gtf | cd reference_gtf 

wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_35/gencode.v35.primary_assembly.annotation.gtf.gz

cd .. 
```


- Command lind: **hisat2-build [options] <reference_in> <ht2_base>**
- **reference_in**: comma-separated list of files with ref sequences
- **hisat2_index_base**: write ht2 data to files with this dir/basename


**Options**:
- **-c**: reference sequences given on cmd line (as <reference_in>)    
- **--large-index**: force generated index to be 'large', even if ref has fewer than 4 billion nucleotides
- **-a/--noauto**: disable automatic -p/--bmax/--dcv memory-fitting
- **-p <int>**: number of threads
- **--bmax <int>**: max bucket sz for blockwise suffix-array builder
- **--bmaxdivn <int>**: max bucket sz as divisor of ref len (default: 4)
- **--dcv <int>**: diff-cover period for blockwise (default: 1024)
- **--nodc**: disable diff-cover (algorithm becomes quadratic)
- **-r/--noref**: don't build .3/.4.ht2 (packed reference) portion
- **-3/--justref**: just build .3/.4.ht2 (packed reference) portion
- **-o/--offrate <int>**: SA is sampled every 2^offRate BWT chars (default: 5)
- **-t/--ftabchars <int>**: # of chars consumed in initial lookup (default: 10)
- **--localoffrate <int>**: SA (local) is sampled every 2^offRate BWT chars (default: 3)
- **--localftabchars <int>**: # of chars consumed in initial lookup in a local index (default: 6)
- **--snp <path>**: SNP file name
- **--haplotype <path>**: haplotype file name
- **--ss <path>**: Splice site file name
- **--exon <path>**: Exon file name
- **--repeat-ref <path>**: Repeat reference file name
- **--repeat-info <path>**: Repeat information file name
- **--repeat-snp <path>**: Repeat snp file name
- **--repeat-haplotype <path>**: Repeat haplotype file name
- **--seed <int>**: seed for random number generator
- **-q/--quiet**: disable verbose output (for debugging)
- **-h/--help**: print detailed description of tool and its options
- **--usage**: print this usage message
- **--version**: print version information and quit


- **HISAT2index.sh** was run to index in the same directory as the reference genome (fasta) file

```bash

#!/bin/bash


cd reference_genome 

ref_genome=*.fa 

hisat2-build -f -o 4 -t 10 --localoffrate 3 --localftabchars 6 -p 8 --seed 67 $ref_genome "index" 

cd ..

# Basic command line: hisat2-build [options] <reference_in> <ht2_base>
# -f ~ --seed: options
# "hg19.fa": <reference_in> 
# "index": <ht2_base> 

```


### 3-2. Alignment 

Command line: hisat2 [options] -x <hisat2-idx> {-1 <m1> -2 <m2> | -U <r> | --sra-acc <SRA accession number>} [-S <hit>]
- **hisat2_test.sh**


```bash

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

```

## 4. Samtools

- Manual: [Samtools](http://www.htslib.org/doc/samtools.html) [HISAT2](http://daehwankimlab.github.io/hisat2/manual)

### 4-1. Coverting SAM to BAM 

- **samtobam.sh**

```bash

#!/bin/bash

cd hisat2_output

input=(mock{1..3} CoV{1..3})

for f in ${input[*]}

do
    samtools view -bS $f.sam > $f.bam 
done 


cd ..
```

### 4-2. Sorting BAM 

- **bamsort.sh**

```bash

#!/bin/bash

cd hisat2_output

input=(mock{1..3} CoV{1..3})

for f in ${input[*]}

do
    samtools sort $f.bam -o $f.sorted.bam

done 


cd ..

# Delete SAM files after samtools run
```


## 5. Counting aligned reads with featureCounts 

The [**featureCounts**](http://subread.sourceforge.net) was run with [**Rsubread**](https://pubmed.ncbi.nlm.nih.gov/30783653) package in R 

R (ver. 4.0.3) script: https://github.com/Mira0507/hisat2_test/blob/master/hisat2_featurecounts.Rmd
