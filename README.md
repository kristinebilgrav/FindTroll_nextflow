# FindTroll_nextflow
Find TRanspOsabLe eLements in short-read WGS data. 

Calls transposable elements in SR data using RetroSeq. 
Annotates and queries against database of common TE insertions using cutsom databases.   

Docker image with RetroSeq, delly, MobileAnn and SVDB. 


# RUN
nextflow run main.nf -config < config > --bam < sample > --output < output_directory>

for resuming after fail, add -resume to command line

Loaded in evironment: \n
Python3, Nextflow, tabix, vcftools , bcftools

# Output
VCF file with annotated TEs and their population frequency. 
