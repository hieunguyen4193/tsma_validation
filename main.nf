#!/usr/bin/env nextflow
/*
NEXTFLOW DSL 2 pipeline for single cell data analysis
This pipeline is designed to process single-cell RNA sequencing data using the 10X Genomics Cell Ranger pipeline.

tronghieunguyen@pm.me
*/

// enable nextflow DSL2

nextflow.enable.dsl = 2

include { METHYLATION_PIPELINE_TSMA } from "./workflows/methylation_pipeline_TSMA.nf"

workflow {
    main:
    //  run the main pipieline. 
    METHYLATION_PIPELINE_TSMA(
        file(params.SAMPLE_SHEET),
        file(params.BismarkIndex)
    )
}