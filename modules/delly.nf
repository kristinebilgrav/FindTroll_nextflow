#!/usr/bin/env nextflow

/*
module to run delly

*/

// run delly
process run_delly {

    tag "${SampleID}:Delly"
   
    
    input:
    tuple val(SampleID), file(bam), file(bai)

    output:
    tuple val(SampleID), file("${bam.baseName}.delly.bcf")

    script:
    """
    delly call -o ${bam.baseName}.delly.bcf -g ${params.ref_fasta} ${bam}
    """


}

process bcf_to_vcf {
    tag "${SampleID}:BCFtoVCF"
    publishDir "${params.output}/${SampleID}_out/", mode: 'copy'

    input:
    tuple val(SampleID), file(delly_bcf)

    output:
    tuple val(SampleID), file("${delly_bcf.simpleName}.delly.vcf")

    script:
    """
    bcftools view ${delly_bcf} > ${delly_bcf.simpleName}.delly.vcf 
    """
}

process MobileAnn {
    tag "${SampleID}:MobileAnn"
    publishDir "${params.output}/${SampleID}_out/", mode: 'copy'

    input:
    tuple val(SampleID), file(delly_vcf), file(called_vcf)

    output:
    tuple val(SampleID), file("${delly_vcf.simpleName}.called.delly.retro.vcf")

    script:
    """
    python MobileAnn.py --sv_annotate --sv ${delly_vcf} --db ${called_vcf} --rm ${params.ref_ME_bed} -d 300 > ${delly_vcf.simpleName}.mobileann.vcf &&  
    python ${params.working_dir}/scripts/filter_MAtoTEs.py ${delly_vcf.simpleName}.mobileann.vcf ${delly_vcf.simpleName}.called.delly.retro.vcf
    """
}