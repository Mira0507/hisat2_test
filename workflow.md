## 1. Conda environment 

- **Conda**: https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
- **HISAT2**: http://daehwankimlab.github.io/hisat2/manual
- The HISAT2 version 2.2.1 was used 


```environment.yml
name: hisat2
channels:
  - conda-forge
  - bioconda 
  - defaults 
dependencies:
  - hisat2

```

Above conda environment (**environment.yml**) was written and created by following commend. 

```termina


conda env create -f environment.yml


```


The hisat2 conda env was activated by following commend. 

```terminal


conda activate hisat2


```



## 2. HISAT2 

### 2-1. Indexing 

- Check out **"The hisat2-build indexer"** description in the [**hisat2 user manual**](http://daehwankimlab.github.io/hisat2/manual)
- Reference genome: https://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/ ---> hg19.fa.gz ---> unzip
- Command lind: **hisat2-build [options] <reference_in> <ht2_base>**
- **reference_in**: comma-separated list of files with ref sequences
- **hisat2_index_base**: write ht2 data to files with this dir/basename


**Options**:
    -c                      reference sequences given on cmd line (as
                            <reference_in>)
    --large-index           force generated index to be 'large', even if ref
                            has fewer than 4 billion nucleotides
    -a/--noauto             disable automatic -p/--bmax/--dcv memory-fitting
    -p <int>                number of threads
    --bmax <int>            max bucket sz for blockwise suffix-array builder
    --bmaxdivn <int>        max bucket sz as divisor of ref len (default: 4)
    --dcv <int>             diff-cover period for blockwise (default: 1024)
    --nodc                  disable diff-cover (algorithm becomes quadratic)
    -r/--noref              don't build .3/.4.ht2 (packed reference) portion
    -3/--justref            just build .3/.4.ht2 (packed reference) portion
    -o/--offrate <int>      SA is sampled every 2^offRate BWT chars (default: 5)
    -t/--ftabchars <int>    # of chars consumed in initial lookup (default: 10)
    --localoffrate <int>    SA (local) is sampled every 2^offRate BWT chars (default: 3)
    --localftabchars <int>  # of chars consumed in initial lookup in a local index (default
: 6)
    --snp <path>            SNP file name
    --haplotype <path>      haplotype file name
    --ss <path>             Splice site file name
    --exon <path>           Exon file name
    --repeat-ref <path>     Repeat reference file name
    --repeat-info <path>    Repeat information file name
    --repeat-snp <path>     Repeat snp file name
    --repeat-haplotype <path>   Repeat haplotype file name
    --seed <int>            seed for random number generator
    -q/--quiet              disable verbose output (for debugging)
    -h/--help               print detailed description of tool and its options
    --usage                 print this usage message
    --version               print version information and quit


Write below bash file (**HISAT2index.sh**).  
```bash

#! bin/bash



cd index_files

ref_genome="hg19.fa" 


hisat2-build -f -o 4 -t 10 --localoffrate 3 --localftabchars 6 -p 8 --seed 67 $ref_genome "index" 

cd ..

# Basic command line: hisat2-build [options] <reference_in> <ht2_base>
# -f ~ --seed: options
# "hg19.fa": <reference_in> 
# "index": <ht2_base> 

```


Run indexing in the same directory as hg19.fa reference genome file.


```terminal

(hisat2) mira@mira-MS-7C90:~/Documents/programming/Bioinformatics/HISAT2-test$ bash HISAT2i
ndex.sh
Settings:
  Output files: "index.*.ht2"
  Line rate: 6 (line is 64 bytes)
  Lines per side: 1 (side is 64 bytes)
  Offset rate: 4 (one in 16)
  FTable chars: 10
  Strings: unpacked
  Local offset rate: 3 (one in 8)
  Local fTable chars: 6
  Local sequence length: 57344
  Local sequence overlap between two consecutive indexes: 10
  Endianness: little
  Actual local endianness: little
  Sanity checking: disabled
  Assertions: disabled
  Random seed: 67
  Sizeofs: void*:8, int:4, long:8, size_t:8
Input files DNA, FASTA:
  hg19.fa
Reading reference sizes
  Time reading reference sizes: 00:00:15

.
.
.
.
.

Exiting GFM::buildToDisk()
Returning from initFromVector
Wrote 969972432 bytes to primary GFM file: index.1.ht2
Wrote 724327620 bytes to secondary GFM file: index.2.ht2
Re-opening _in1 and _in2 as input streams
Returning from GFM constructor
Returning from initFromVector
Wrote 1274093467 bytes to primary GFM file: index.5.ht2
Wrote 737586876 bytes to secondary GFM file: index.6.ht2
Re-opening _in5 and _in5 as input streams
Returning from HGFM constructor
Headers:
    len: 2897310462
    gbwtLen: 2897310463
    nodes: 2897310463
    sz: 724327616
    gbwtSz: 724327616
    lineRate: 6
    offRate: 4
    offMask: 0xfffffff0
    ftabChars: 10
    eftabLen: 0
    eftabSz: 0
    ftabLen: 1048577
    ftabSz: 4194308
    offsLen: 181081904
    offsSz: 724327616
    lineSz: 64
    sideSz: 64
    sideGbwtSz: 48
    sideGbwtLen: 192
    numSides: 15090159
    numLines: 15090159
    gbwtTotLen: 965770176
    gbwtTotSz: 965770176
    reverse: 0
    linearFM: Yes
Total time for call to driver() for forward index: 00:14:42


```

