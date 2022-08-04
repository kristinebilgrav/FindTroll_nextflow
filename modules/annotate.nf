#!/usr/bin/env nextflow

/*

Annotate output
*/

nextflow.enable.dsl = 2

//VEP

process run_vep {
  publishDir params.outdir, mode: 'copy'

  cpus 4
  time '1h'

  input:
  path(called_vcf)
  //path "${bam.baseName}.called.vcf

  output:
  path "${bam_file.baseName}.called.VEP.vcf" 

  """
  ${params.vep_path} -i ${called_vcf} -o ${bam_file.baseName}.called.VEP.vcf ${params.vep_args}
  """

}