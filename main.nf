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
include { merge } from  './modules/combine'

// main script flow
workflow{
    call = Channel.fromPath(params.bam)
    run_retro(call) 
    run_delly(call)
    bcf_to_vcf(run_delly.out)
    MobileAnn()
    bgzip(MobileAnn.out.DR_vcf)
    run_vep(bgzip.out)
    run_split(run_vep.out.annotated_vcf) 
    splitfiles = Channel.fromPath("${params.tmpfiles}/*.VEP.*.vcf")
    query(splitfiles)
    zip(query.out)
    tomerge = Channel.fromPath("${params.tmpfiles}/*.query.sort.vcf.gz").collect()
    merge(tomerge)
}



//completion handler
workflow.onComplete {
    log.info (workflow.success ? "Done, trolls found and captured in ${params.tmpfiles}!" : "Failed, did the sun come too soon and turn the troll to stone? :(")
}