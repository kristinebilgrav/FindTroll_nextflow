# FindTroll_nextflow
Find TRanspOsabLe eLements in short-read WGS data. 

Calls transposable elements in SR data using RetroSeq. 
Annotates and queries against database of common TE insertions using cutsom databases.   

Docker image with RetroSeq, delly, MobileAnn and SVDB. 


# RUN
    nextflow run main.nf -config < config > 
    --input < sample bam or crai OR csv samplesheet > 
    --file < type of file; bam or cram >
    --output < output_directory> 
    --gene_list < optional gene list for filtering >
    -with-trace

samplesheet (csv) must include SampleID and SamplePath
for resuming after fail, add -resume to command line

Loaded in evironment: \n
Python3, Nextflow, tabix, vcftools , bcftools

# Output
VCF file with annotated TEs and their population frequency. 
