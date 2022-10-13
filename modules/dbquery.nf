#!/usr/bin/env nextflow

/* 
module to query file against a database
*/

// make seperate to run at the same time
process query {
    publishDir params.output, mode:'copy'
    cpus 1
    time '5h'
    
    input:
    path(split)
    
    output:
    path "${split.baseName}.query.vcf", emit: query_vcf
    
    script:

    def values = "${split}".tokenize('.')
    TE = values[-2]

    """
    svdb --query --query_vcf $split --db ${params."${TE}"} --overlap -1 --bnd_distance 150 > ${split.baseName}.query.vcf
    """
}

