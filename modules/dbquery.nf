#!/usr/bin/env nextflow

/* 
module to query file against a database
*/

// make seperate to run at the same time
process query {
    tag "${SampleID}:query"
    publishDir "${params.output}/${SampleID}_out/", mode: 'copy'
    
    
    input:
    tuple val(SampelID), file(split)
    
    output:
    tuple val(SampleID) , file("${split.baseName}.query.vcf")
    
    script:

    def values = "${split}".tokenize('.')
    TE = values[-2]

    """
    svdb --query --query_vcf ${split} --db ${params."${TE}"} --overlap -1 --bnd_distance 150 > ${split.baseName}.query.vcf
    """
}

