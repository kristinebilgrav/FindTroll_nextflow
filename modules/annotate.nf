#!/usr/bin/env nextflow

/*

Annotate output
*/

process bgzip {
  publishDir params.output, mode: 'copy'
  beforeScript 'module load bioinfo-tools tabix vcftools'
  errorStrategy 'ignore'

  input:
  path vcf

  output:
  path "${vcf.baseName}.sort.vcf.gz", emit: gzipped
  path "${vcf.baseName}.sort.vcf.gz.tbi", emit: index

  script:
  """
  vcf-sort -c ${vcf}  > ${vcf.baseName}.sort.vcf && bgzip ${vcf.baseName}.sort.vcf && tabix ${vcf.baseName}.sort.vcf.gz
  """
}

//VEP
process run_vep {
  publishDir params.output, mode: 'copy'
  beforeScript 'module load bioinfo-tools vep'
 
  cpus 4
  time '1h'

  input:
  path(gzipped)

  output:
  path "${gzipped.baseName}.VEP.vcf", emit: annotated_vcf

  script:
  """
  ${params.vep_path} -i ${gzipped} -o ${gzipped.baseName}.VEP.vcf ${params.vep_args} && rm ${gzipped}
  """

}