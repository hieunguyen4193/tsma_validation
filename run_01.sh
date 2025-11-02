# test on mac studio
# bamfile="/Volumes/HNSD01/outdir/tsma_validation_bam/4-LC030TS_M569-M769.trimGalore_R1_bismark_bt2_pe.sorted.bam";
# outputdir="./output";
# python 01_fetch_reads_from_BAM_files.py --bamfile ${bamfile} --outputdir ${outputdir}

# scripts for running on HPC GS
bamdir="/mnt/nvme/DATA_HIEUNGUYEN/outdir/TSMA_validation/20251027batch*/SampleSheet_20251027batch*/BISMARK_ALIGNMENT"
all_bam_files=$(ls $bamdir/*.sorted.bam);
outputdir="/mnt/nvme/DATA_HIEUNGUYEN/outdir/TSMA_validation/reads"
mkdir -p ${outputdir}
