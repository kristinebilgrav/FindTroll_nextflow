#!/usr/bin/env nextflow

/*
main pipeline script
*/

nextflow.enable.dsl = 2


log.info """\
FindTroll pipeline
------------------
config: ${params.config}
sample(s) : ${params.bam}
output directory :  ${params.output}

"""

String[] names = "${params.bam}".split("[/.]")
params.sample_ID = names[-2]
 
 // include modules
include { run_retro } from './modules/RetroSeq'
include { run_delly ; bcf_to_vcf ; MobileAnn } from './modules/delly'
include { bgzip; bgzip as zip; run_vep } from './modules/annotate'
include { run_split } from './modules/TEsplit'
include { query } from './modules/dbquery'
include { svdb_merge ; merge_calls } from  './modules/combine'

//channels 


workflow {
    bam = Channel
        .fromFilePairs("${params.bam}")
        //.map {file -> tuple(file.baseName, file)}
        .view()
    bai = Channel.fromPath("${params.bam}.bai")    
    run_retro(bam, bai) 
    run_delly(bam, bai)
    bcf_to_vcf(run_delly.out)

    //teannotate = Channel.fromFilePairs(["${params.output}/*called.R.vcf", "${params.output}/*.delly.vcf"])

    MobileAnn(run_retro.out.called_vcf , bcf_to_vcf.out)
    svdb_merge(run_retro.out.called_vcf , MobileAnn.out.DR_vcf)
    //bgzip(MobileAnn.out.DR_vcf)

    run_vep(svdb_merge.out)
    run_split(run_vep.out.annotated_vcf) 

    splitfiles = Channel.fromPath("${params.tmpfiles}/*.VEP.*.vcf")
    query(splitfiles)
    zip(query.out)
    tomerge = Channel.fromPath("${params.tmpfiles}/*.query.sort.vcf.gz").collect()
    merge_calls(tomerge)
}


//completion handler
workflow.onComplete {
    log.info (workflow.success ? "Done, trolls found and captured in ${params.output}!" : "Failed, did the sun come too soon and turn the troll to stone? :(")
}