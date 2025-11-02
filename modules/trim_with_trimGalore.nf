process  trim_Galore {
    // FastQC quality control for sequencing reads
    tag "$sample_id"
    cache "deep";
    
    input:
        tuple val(sample_id), path(fastq1), path(fastq2)
    output:
        tuple val(sample_id), path("${sample_id}.trimGalore_R1.fastq.gz"), path("${sample_id}.trimGalore_R2.fastq.gz"), emit: trimmed_fastqs

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    trim_galore --paired \
        ${fastq1} ${fastq2} \
        --cores 5 \
        --basename $sample_id  \
        --clip_r2 8 \
        --three_prime_clip_r1 15 \
        --three_prime_clip_r2 15 \
        --gzip -o .
    mv ${sample_id}_val_1.fq.gz ${sample_id}.trimGalore_R1.fastq.gz
    mv ${sample_id}_val_2.fq.gz ${sample_id}.trimGalore_R2.fastq.gz
    """
}