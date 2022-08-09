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

// include modules
include { run_retro } from './modules/RetroSeq'
include { bgzip; run_vep } from './modules/annotate'
include { run_split } from './modules/TEsplit'
include { query } from './modules/dbquery'

// main script flow
workflow{
    call = Channel.fromPath(params.bam) //queue channel
    run_retro(call) 
    bgzip(run_retro.out)
    run_vep(bgzip.out)
    run_split(run_vep.out) 
    splitfiles = Channel.fromPath('results/*.*.vcf') //.buffer(size:4)
    query(splitfiles)
}



//filter/rank/sort


//completion handler
workflow.onComplete {
    log.info (workflow.success ? "Done, trolls found and captured in results!" : "Failed, did the sun come too soon and turn the troll to stone? :(")
}