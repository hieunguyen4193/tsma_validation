inputdir="/mnt/nvme/DATA_HIEUNGUYEN/outdir/TSMA_validation/reads";
path_to_all_fa="/mnt/nvme/DATA_HIEUNGUYEN/hg19_by_chroms";
all_samples=$(ls $inputdir/* -d);
outputdir="/mnt/nvme/DATA_HIEUNGUYEN/outdir/TSMA_validation/fragmentomics_features";
mkdir -p $outputdir;

for file in ${all_samples};do 
    # echo "Processing sample $file";
    # parallel -j 60 python 03_generate_fragmentomics_features.py -i {} -o ${outputdir} --fa ${path_to_all_fa} ::: ${all_samples}
    python 03_generate_fragmentomics_features.py -i ${file} -o ${outputdir} --fa ${path_to_all_fa}
done
