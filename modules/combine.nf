#!/usr/bin/env nextflow

/* 
module to merge TE files to one and delete unneeded files 
*/

process svdb_merge {
    tag "${SampleID}:SVDB_merge"
    publishDir "${params.output}/${SampleID}_out/", mode: 'copy'

    input:
    tuple val(SampleID), path(retrofile), file(delly_vcf)


    output:
    tuple val(SampleID), file("${called_vcf.simpleName}.called.vcf"), emit: all_calls

    script:
    """
    svdb --merge --vcf  ${called_vcf} ${delly_vcf} --bnd_distance 150 > ${called_vcf.simpleName}.all.called.vcf &&
    python ${params.working_dir}/scripts/filter_MAtoTEs.py ${called_vcf.simpleName}.all.called.vcf ${called_vcf.simpleName}.called.vcf
    """
    
}

process merge_calls {
    tag "${SampleID}:merge"
    publishDir "${params.output}/${SampleID}_out/", mode: 'copy'
    errorStrategy 'ignore'
    
    input:
    tuple val(SampelID), file(queryList) 
 
    output:
    tuple val(SampleID), file("${queryList[0].simpleName}.TEcalls.vcf.gz")

    script:
    """
    zgrep '#' ${queryList[0]} > ${queryList[0].simpleName}.TEcalls.vcf.gz |
    for qFile in ${queryList}
    do
        zgrep -v '#' \$qFile  >> ${queryList[0].simpleName}.TEcalls.vcf.gz 
    done 
    """
}

