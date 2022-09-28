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
  publishDir params.output, mode:'copy'

  cpus 2
  time '10h'
  //errorStrategy 'ignore'

  input:
  tuple val(bamID), file(bamFile)
  path(bai)

  output: 
  path "${bamID}.called.R.vcf", emit: called_vcf

  script:
  """
  retroseq.pl -discover -bam ${bamFile} -output ${bamID}.discover.vcf -refTEs ${params.ref_ME_tab} && \
  retroseq.pl -call -bam ${bamFile} -input ${bamID}.discover.vcf -ref ${params.ref_fasta}  -output ${bamID}.called.R.vcf
  """

}



