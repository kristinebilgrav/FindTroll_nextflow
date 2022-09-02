#!/usr/bin/env nextflow

/*
module to run delly

*/

// run delly
process run_delly {

    publishDir params.output, mode:'copy'
    cpus 2
    time '10h'

    input:
    path(bam)

    output:
    path "${bam.baseName}.delly.bcf", emit: delly_bcf

    script:
    """
    delly call -o ${bam.baseName}.delly.vcf -g ${params.ref_fasta} ${bam}
    """


}

process bcf_to_vcf {
    publishDir params.output, mode:'copy'
    
    cpus 2

    input:
    path(delly_bcf)

    output:
    "${params.sample_ID}.delly.vcf", emit: delly_vcf

    script:
    """
    bcftools view ${delly_bcf} > ${params.sample_ID}.delly.vcf 
    """
}

process MobileAnn {
    publishDir params.output, mode:'copy'

    cpus 2
    time '1h'

    input:
    path(delly_vcf)
    path(called_vcf)

    output:
    path "${params.sample_ID}.delly.retro.vcf", emit: DR_vcf

    script:
    """
    MobileAnn.py --sv_annotate --sv ${delly_vcf} --db ${called_vcf} --rm ${params.ref_ME_tab} -d 300 > ${params.sample_ID}.delly.retro.vcf
    """
}