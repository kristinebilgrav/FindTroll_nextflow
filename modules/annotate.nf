
#!/usr/bin/env nextflow

/*

Annotate output
*/

nextflow.enable.dsl = 2

//VEP
vep_exec = params.VEP_path
process run_vep {
  publishDir params.outdir, mode: 'copy'

  cpus 4

  input:
  path 

  output:
  path "${bam_file.baseName}.final.VEP.vcf" into publishDir

  """
  ${vep_exec} -i ${vcf_file} -o ${{bam_file.baseName}.final.VEP.vcf} ${params.vep_args}
  """

}