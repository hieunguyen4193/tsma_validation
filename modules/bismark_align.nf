process  bismark_alignment {
    // FastQC quality control for sequencing reads
    tag "$sample_id"
    cache "deep";
    
    input:
        tuple val(sample_id), path(fastq1), path(fastq2)
        file(BismarkIndex)
    output:
        tuple val(sample_id), path("*.bam"), emit: bismark_bam

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    bismark \
        --multicore ${params.BismarkCores} \
        --genome ${BismarkIndex} \
        -1 ${fastq1} \
        -2 ${fastq2} \
        --non_directional
    """
}