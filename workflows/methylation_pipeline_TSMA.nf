// include MODULES
include { fastqc } from "../modules/fastqc.nf"
include { multiqc } from "../modules/multiqc.nf"

// include SUB-WORKFLOWS
include { FASTQ_QC } from "../subworkflows/QC.nf"
include { PIPELINE_INIT } from "../subworkflows/pipeline_init.nf"
include { ALIGNMENT_AND_METHYLATION_CALLING } from "../subworkflows/bismark_methylation_calling.nf"
include { TRIM } from "../subworkflows/trim.nf"

// MAIN WORKFLOW: INPUT FASTQS --> PREPROCESS THE UMI --> ALIGN AND CALL METHYLATION
workflow METHYLATION_PIPELINE_TSMA {
    take:
        input_SampleSheet // path to the input samplesheet .csv file, the sampleshet file should contain the columns SampleID, FASTQ1, and FASTQ2
        BismarkIndex
        trim_algorithm

    main:
        PIPELINE_INIT(input_SampleSheet)   
        FASTQ_QC(
            PIPELINE_INIT.out.samplesheet
        )
        
        TRIM(
            PIPELINE_INIT.out.samplesheet,
            trim_algorithm
        )

        ALIGNMENT_AND_METHYLATION_CALLING(
            TRIM.out.trimmed_fastqs,
            BismarkIndex
            )
}