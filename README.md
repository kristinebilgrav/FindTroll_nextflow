# FindTroll_nextflow
Find TRanspOsabLe eLements in short-read WGS data. 

Contains RetroSeq, SVDB, VEP and custom annotation scripts

# RUN
nextflow run main.nf -config < config > --bam < sample > -with-singularity FindTroll.sif

for resuming, add -resume to command line

