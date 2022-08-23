# FindTroll_nextflow
Find TRanspOsabLe eLements in short-read WGS data. 

Calls transposable elements in SR data using RetroSeq. 
Annotates and queries against database of common TE insertions using cutsom databases.   

Docker image with RetroSeq and SVDB. 

Requires VEP. 

# RUN
nextflow run main.nf -config < config > --bam < sample > --output < output_directory>

for resuming, add -resume to command line

# Output
VCF file with annotated TEs and their population frequency. 
