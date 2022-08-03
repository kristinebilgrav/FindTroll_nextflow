#!/usr/bin/env nextflow

/*
module to run RetroSeq

*/
nextflow.enable.dsl = 2

//create output channels
//queue channels (connecting several processes)

filter = Channel.fromPath('filter/output')

/*
Run retroseq - calling of Trolls (TRanspOsabLe eLementS)
*/


//run RetroSeq
process run_retro_discover {
  publishDir params.outdir, mode:'copy'
  errorStrategy 'ignore'

  cpus 2

  input:
  file(params.bam) 
  // bam

  output:
  path "${bam.baseName}.vcf" 

  shell:
  """
  singularity exec ${params.FindTroll_home}/FindTroll.sif retroseq.pl -discover -bam ${bam} -output ${{bam.baseName}.vcf} -refTEs ${params.ref_ME_tab}
  """

}

process run_retro_call {
  publishDir "${params.outdir}", mode: 'copy', overwrite: true
  errorStrategy 'ignore'


  cpus 2

  input:
  bam, file x from run_retro_discover //how to get the name connected?

  output:
  path "${bam.baseName}.final.vcf" 

  shell:
  """
  singularity exec ${params.FindTroll_home}/FindTroll.sif retroseq.pl -call -bam ${bam} -input ${discover_vcf}   -ref ${params.ref_fasta}  -output ${{bam.baseName}.final.vcf}
  """

}


