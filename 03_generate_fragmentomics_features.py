import pandas as pd 
import numpy as np 
import os 
import pathlib 
from tqdm import tqdm 
import argparse
import re

from helper_functions import * 

# path_to_sample_readdf = "/Volumes/HNSD01/storage/TSMA_validation_readdf/reads/1-MYAAAA29TS_M525-M725"
# outputdir = "./output"

def _parse_args(argv=None):
    parser = argparse.ArgumentParser(
        description="Extract reads from TSMA panel regions from a BAM file and save per-region CSVs."
    )
    parser.add_argument("-i", "--input", required=True,
                        help="Path to input directory containing all readdf files.")
    parser.add_argument("-o", "--output", default="./output",
                        help="Base output directory (will create per-sample subdir).")
    return parser.parse_args(argv)

if __name__ == "__main__":
    args = _parse_args()
else:
    args = _parse_args([])
    
path_to_sample_readdf = args.input
outputdir = args.output

samplename = path_to_sample_readdf.split("/")[-1]
path_to_save_output = f"./{outputdir}/{samplename}"

print(f"Working on sample {samplename}, output will be saved to {path_to_save_output}")

os.makedirs(path_to_save_output, exist_ok=True)

all_panels = ["Rare_cancers_panel",
              "TMD_450_panel",
              "TSMA_panel"]

for panel in all_panels:
    all_files = [item for item in pathlib.Path(path_to_sample_readdf).glob(f"{panel}/*.csv")]

    all_regions = []
    all_counts = []
    flendf = pd.DataFrame(data = {"size": np.arange(50, 351)})
    motifdf = pd.DataFrame(
        data = [f"{i}{j}{k}{l}" for i in ["A", "T", "C", "G"] for j in ["A", "T", "C", "G"] for k in ["A", "T", "C", "G"] for l in ["A", "T", "C", "G"]],
        columns = ["motif"]
    )
    def _get_read_length_on_alignment(cigar_string):
        # cigar_string = "5M1D72M"
        numbers = re.findall(r'\d+', cigar_string)
        total = sum(int(num) for num in numbers)
        return total

    path_to_all_fa = "/Volumes/HNSD01/storage/ref/hg19"
    def _get_motif_seq(path_to_all_fa, chrom, start, flen_sign, read_length):
        if flen_sign > 0:
            end = start +  4 - 1
            return get_refseq(path_to_all_fa, chrom, start, end)
        else:
            start = start + read_length - 1
            end = start
            start = start - 4 + 1
            return get_refseq(path_to_all_fa, chrom, start, end)
        
    for file in tqdm(all_files):
        regionname = file.name.replace("readdf_", "").replace(".csv", "")
        df = pd.read_csv(file, index_col = [0])
        if (df.shape[0] != 0):
            df["abs_flen"] = df["flen"].abs()
            df["read_length"] = df["cigar"].apply(lambda x: _get_read_length_on_alignment(x))
            df["motif"] = df[["chrom", "start", "flen", "read_length"]].apply(lambda x:
                _get_motif_seq(path_to_all_fa, x[0], x[1], x[2], x[3]), axis = 1)
            
            tmp_flendf = df.groupby("abs_flen")["sample"].count().reset_index()
            tmp_flendf.columns = ["size", regionname]
            flendf = flendf.merge(tmp_flendf, on = "size", how = "left").fillna(0)
            tmp_motifdf = df.groupby("motif")["sample"].count().reset_index()
            tmp_motifdf.columns = ["motif", regionname]
            motifdf = motifdf.merge(tmp_motifdf, on = "motif", how = "left").fillna(0)
        count = df.shape[0]
        all_regions.append(regionname)
        all_counts.append(count)
    depthdf = pd.DataFrame({"region": all_regions, "num_reads": all_counts})
    flendf.to_csv(f"{outputdir}/fragment_size_distribution_{panel}.csv")
    motifdf.to_csv(f"{outputdir}/motif_distribution_{panel}.csv")
    depthdf.to_csv(f"{outputdir}/depth_{panel}.csv")
    