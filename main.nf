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
outdir :  ${params.outdir}

"""

String[] names = "${params.bam}".split("[/.]")
params.sample_ID = names[-2]
 
 // include modules
include { run_retro } from './modules/RetroSeq'
include { bgzip; bgzip as zip; run_vep } from './modules/annotate'
include { run_split } from './modules/TEsplit'
include { query } from './modules/dbquery'
include { merge } from  './modules/combine'

// main script flow
workflow{
    call = Channel.fromPath(params.bam)
    run_retro(call) 
    bgzip(run_retro.out)
    run_vep(bgzip.out)
    run_split(annotated_vcf) 
    splitfiles = Channel.fromPath('./results*.VEP.*.vcf')
    query(splitfiles)
    zip(query.out)
    tomerge = Channel.fromPath('./results/*.query.sort.vcf.gz').buffer(size:4)
    merge(tomerge)
}



//completion handler
workflow.onComplete {
    log.info (workflow.success ? "Done, trolls found and captured in results!" : "Failed, did the sun come too soon and turn the troll to stone? :(")
}