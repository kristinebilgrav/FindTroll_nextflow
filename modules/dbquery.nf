#!/usr/bin/env nextflow

/* 
module to query file against a database
*/

// make seperate to run at the same time
process query {
    publishDir params.outdir, mode:'copy'
    cpus 1
    time '1h'
    
    input:
    path(split)
    
    output:
    path "${split.baseName}.query.vcf"
    
    script:
    if( "${split}" =~ '*ALU.vcf')
        """
        svdb --query --query_vcf $split --db ${params.alu_vcf} --overlap -1 --bnd_distance 150 > ${split.baseName}.query.vcf
        """

    else if("${split}" =~ *L1.vcf)
        """
        svdb --query --query_vcf $split --db ${params.l1_vcf} --overlap -1 --bnd_distance 150 > ${split.baseName}.L1.query.vcf
        """

    else if("${split}" =~ *HERV.vcf)
        """
        svdb --query --query_vcf $split --db ${params.herv_vcf} --overlap -1 --bnd_distance 150 > ${split.baseName}.HERV.query.vcf
        """

    else
        """
        svdb --query --query_vcf $split --db ${params.sva_vcf} --overlap -1 --bnd_distance 150 > ${split.baseName}.SVA.query.vcf
        """
    
}


