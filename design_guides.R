#!/usr/bin/env Rscript

# Simple CRISPRi/a guide RNA design script
# Finds 20 nt guides upstream of NGG PAM sites (plus-strand only)

# Load libraries
t suppressPackageStartupMessages({
  library(optparse)
  library(Biostrings)
  library(dplyr)
})

# Command-line options
option_list <- list(
  make_option(c("-f", "--fasta"), type="character", help="Input FASTA file"),
  make_option(c("-o", "--out"),   type="character", help="Output CSV file path")
)
opt <- parse_args(OptionParser(option_list=option_list))

# Read sequences
fasta <- readDNAStringSet(opt$fasta)

# Function to design guides
design_guides <- function(seq, seqname, guide_len = 20) {
  # Find NGG PAM sites (plus strand)
  pam_patterns <- c("AGG", "TGG", "CGG", "GGG")
  hits <- unlist(lapply(pam_patterns, function(p) start(matchPattern(p, seq))))
  hits <- sort(unique(hits))

  guides <- lapply(hits, function(p) {
    guide_start <- p - guide_len
    if (guide_start >= 1) {
      guide_seq <- as.character(subseq(seq, start=guide_start, width=guide_len))
      pam_seq   <- as.character(subseq(seq, start=p, width=3))
      data.frame(
        seqname   = seqname,
        start     = guide_start,
        end       = p - 1,
        strand    = "+",
        guide_seq = guide_seq,
        pam_seq   = pam_seq,
        stringsAsFactors = FALSE
      )
    }
  })
  do.call(bind_rows, guides)
}

# Run design on all sequences
all_guides <- bind_rows(lapply(names(fasta), function(nm) {
  design_guides(fasta[[nm]], nm)
}))

# Write out
write.csv(all_guides, opt$out, row.names = FALSE, quote = FALSE)

cat("Done! Guides written to", opt$out, "\n")