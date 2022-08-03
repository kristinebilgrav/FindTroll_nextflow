#!/usr/bin/env nextflow

/*
main pipeline script
*/

nextflow.enable.dsl = 2


params.config=""
//parmas.outdir = ""

log.info """\
FindTroll pipeline
------------------
sample(s) : ${params.bam}
outdir :  ${params.outdir}

"""

// include modules
include { run_retro_discover; run_retro_call } from './modules/RetroSeq'
include {run_vep} from './modules/annotate'

// main script flow
workflow{
    bam = Channel.fromPath(params.bam)
    run_retro_discover(bam) 
    run_retro_call(bam)
    run_vep(run_retro_call.out)
}


//split ?

//ALU database

//L1 database

//SVA database

//HERV database



//filter/rank


//completion handler
workflow.onComplete {
    log.info (workflow.success ? "Done, Trolls found!" : "Failed, did sun come too soon? :(")
}