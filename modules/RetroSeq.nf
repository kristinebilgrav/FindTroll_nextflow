#!/usr/bin/env nextflow

/*
module to run RetroSeq

*/


//create output channels
//queue channels (connecting several processes)

/*
Run retroseq - calling of Trolls (TRanspOsabLe eLementS)
*/


//run RetroSeq
process run_retro{
  publishDir params.outdir, mode:'copy'

  cpus 2
  time '5h'
  errorStrategy 'ignore'

  input:
  path(bam) 

  output: 
  path "${bam.baseName}.called.vcf", emit: called_vcf

  shell:
  """
  retroseq.pl -discover -bam ${params.bam} -output ${bam.baseName}.discover.vcf -refTEs ${params.ref_ME_tab} && \
  retroseq.pl -call -bam ${params.bam} -input ${bam.baseName}.discover.vcf -ref ${params.ref_fasta}  -output ${bam.baseName}.called.vcf
  """

}



