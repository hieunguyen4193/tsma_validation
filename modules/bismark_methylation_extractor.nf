process bismark_methylation_extractor {
    // FastQC quality control for sequencing reads
    tag "$sample_id"
    cache "deep";
    
    input:
        tuple val(sample_id), path(input_bam)
    output:
        tuple val(sample_id), path("*.cov"), emit: bismark_cov

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    bismark_methylation_extractor --parallel ${params.MethExtractCores} \
        --paired-end --comprehensive --bedGraph --zero_based \
        ${input_bam}
    """
}