#!/usr/bin/env nextflow

/* 
module to query file against a database
*/

// make seperate to run at the same time
process query {
  publishDir params.outdir, mode:'copy'
  cpus 2
  time '1h'

  input:
  file split from splitfiles
    
  //output:
  //path "${split.baseName}*query.vcf" 
  script:
  if('ALU' in $split)
    """
    svdb --query --query_vcf $split --db ${params.alu_vcf} --overlap -1 --bnd_distance 150 > ${split.baseName}.ALU.query.vcf
    """

  else if('L1' in split)
    """
    svdb --query --query_vcf $split --db ${params.L1_vcf} --overlap -1 --bnd_distance 150 > ${split.baseName}.L1.query.vcf
    """

  else if('HERV' in split)
    """
    svdb --query --query_vcf $split --db ${params.HERV_vcf} --overlap -1 --bnd_distance 150 > ${split.baseName}.HERV.query.vcf
    """

  else
    """
   svdb --query --query_vcf $split --db ${params.SVA_vcf} --overlap -1 --bnd_distance 150 > ${split.baseName}.SVA.query.vcf
    """
    
}


