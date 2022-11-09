#!/usr/bin/env nextflow

/*
module to run delly

*/

// run delly
process run_delly {

    publishDir params.output, mode:'copy'
    cpus 4
    time '10h'

    input:
    //path(bam)
    tuple val(bamID), file(bamFile)
    path(bai)

    output:
    path "${bamID}.delly.bcf", emit: delly_bcf

    script:
    """
    delly call -o ${bamID}.delly.bcf -g ${params.ref_fasta} ${bamFile}
    """


}

process bcf_to_vcf {
    publishDir params.output, mode:'copy'
    beforeScript 'module load bioinfo-tools bcftools'
    cpus 2
    time '1h'

    input:
    path(delly_bcf)

    output:
    path "${delly_bcf.simpleName}.delly.vcf", emit: delly_vcf

    script:
    """
    bcftools view ${delly_bcf} > ${delly_bcf.simpleName}.delly.vcf 
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
    path "${delly_vcf.simpleName}.called.delly.retro.vcf", emit: DR_vcf

    script:
    """
    python MobileAnn.py --sv_annotate --sv ${delly_vcf} --db ${called_vcf} --rm ${params.ref_ME_bed} -d 300 > ${delly_vcf.simpleName}.mobileann.vcf &&  
    python ${params.working_dir}/scripts/filter_MAtoTEs.py ${delly_vcf.simpleName}.mobileann.vcf ${delly_vcf.simpleName}.called.delly.retro.vcf
    """
}