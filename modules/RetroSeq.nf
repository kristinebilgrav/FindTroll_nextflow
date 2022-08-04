#!/usr/bin/env nextflow

/*
module to run RetroSeq

*/
nextflow.enable.dsl = 2

//create output channels
//queue channels (connecting several processes)

/*
Run retroseq - calling of Trolls (TRanspOsabLe eLementS)
*/


//run RetroSeq
process run_retro_discover {
  publishDir params.outdir, mode:'copy'

  cpus 2
  time '2h'

  input:
  path(params.bam) 

  output:
  path "${bam.baseName}.discovered.vcf" 

  script:
  """
  retroseq.pl -discover -bam ${params.bam} -output ${bam.baseName}.discover.vcf -refTEs ${params.ref_ME_tab} 
  """

}



process run_retro_call {
  publishDir params.outdir, mode: 'copy', overwrite: true
  errorStrategy 'ignore'

  cpus 2
  time '2h'

  input:
  path(params.bam)
  path("${bam.baseName}.discover.vcf")  

  output:
  path "${bam.baseName}.called.vcf" emit: called_vcf

  shell:
  """
  retroseq.pl -call -bam ${params.bam} -input ${bam.baseName}.discover.vcf -ref ${params.ref_fasta}  -output ${bam.baseName}.called.vcf
  """

}
