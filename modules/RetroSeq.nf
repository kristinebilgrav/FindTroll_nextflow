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
  tag "${SampleID}:RetroSeq"
  publishDir "${params.output}/${SampleID}_out/", mode: 'copy'
  errorStrategy 'ignore'

  input:
  tuple val(SampleID), file(bam), file(bai)

  output: 
  tuple val(SampelID), file("${bam.baseName}.called.R.vcf"), emit: called_vcf

  script:
  """
  retroseq.pl -discover -bam ${bam} -output ${bam.baseName}.discover.vcf -refTEs ${params.ref_ME_tab} && \
  retroseq.pl -call -bam ${bam} -input ${bam.baseName}.discover.vcf -ref ${params.ref_fasta}  -output ${bam.baseName}.called.R.vcf
  """

}



