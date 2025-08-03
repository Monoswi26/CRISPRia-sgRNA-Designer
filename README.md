#  CRISPRi/a sg-RNA Designer
A small R-based project to batch-design CRISPRi/a guide RNAs (20-nt guides targeting NGG PAM sites) from a user-provided FASTA sequence.

This project provides an R script to identify 20 nt guide RNAs upstream of NGG PAM sites in a DNA sequence for CRISPR interference (i) or activation (a).

## Requirements
- R (>= 4.0)
- Bioconductor packages: Biostrings, dplyr

## Installation
```sh
Rscript -e "if (!requireNamespace('BiocManager', quietly=TRUE)) install.packages('BiocManager'); BiocManager::install(c('Biostrings'))"
R -e "install.packages('dplyr')"

**## Usage**
# Make sure you are in the project root directory
Rscript scripts/design_guides.R \
  --fasta data/example_target.fasta \
  --out output/guides.csv
