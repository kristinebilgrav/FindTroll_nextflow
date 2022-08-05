#!/usr/bin/env nextflow

/*

Annotate output
*/

nextflow.enable.dsl = 2

process bgzip {
  publishDir params.outdir, mode: 'copy'
  beforeScript 'module load bioinfo-tools tabix vcftools'

  input:
  path(called_vcf)

  output:
  path "${called_vcf.baseName}.sort.vcf.gz", emit: called_gz

  shell:
  """
  vcf-sort -c ${called_vcf}  > ${called_vcf.baseName}.sort.vcf && bgzip ${called_vcf.baseName}.sort.vcf && tabix ${called_vcf.baseName}.sort.vcf.gz
  rm ${called_vcf.baseName}.sort.vcf
  """
}

//VEP
process run_vep {
  publishDir params.outdir, mode: 'copy'
  beforeScript 'module load bioinfo-tools vep'
 
  cpus 4
  time '1h'

  input:
  path(called_gz)

  output:
  path "${called_gz.baseName}.VEP.vcf", emit: annotated_vcf

  shell:
  """
  ${params.vep_path} -i ${called_vcf}.gz -o ${called_gz.baseName}.VEP.vcf ${params.vep_args}
  """

}