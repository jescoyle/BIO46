### Orders fungal isolate FASTA file by taxonomic hierarchy
### Author: Jes Coyle
### Created: 3/5/2018

# Set options
options(stringsAsFactors = FALSE)

# Load packages
library(googlesheets)
library(dplyr)
library(seqinr) # from Bioconducter


### Read in data

# Authorize googlesheets to access you Google Drive
gs_auth()

# Register the data tables
taxa_gs <- gs_key("1pbttwIAHZ8jijHdB9rvwkdxkh0rkLfKoegm07PxjB9Y")
fungi_gs <- gs_key("1KZFkry5qZwoYljhSEo9AbEcvj0borZZOF9sSkbdwLag")

# Read the googlesheets into R
taxa <- gs_read(taxa_gs)
fungi <- gs_read(fungi_gs)

### Merge and sort the data

fasta <- fungi %>%
  filter(!is.na(TaxonID)) %>% # only use isolates that have been IDed
  mutate(FASTA_ID = ifelse(grepl("T", IsolateID),
                           paste0("W17", gsub("-", "", IsolateID)),
                           IsolateID)
  ) %>%
  full_join(taxa) %>%
  arrange(Class, Order, Family, Genus, Species, TaxonID)

### Write fasta file in order 

# Read in fasta file 
# Note: sequence data stored locally on computer
seq_dir <- "C:/Users/jrcoyle/Google Drive/BIO46/Winter 2018 Course Materials/Data"
seqs <- read.fasta(file.path(seq_dir, "BIO46_ITS_fungal_sequences.fas"))

# Reorder
seqs_ordered <- seqs[fasta$FASTA_ID]

names(seqs)[which(!(names(seqs) %in% fasta$FASTA_ID))]
filter(fasta, !(FASTA_ID %in% names(seqs)))

# Rename with taxa
names(seqs_ordered) <- paste(fasta$TaxonID, fasta$IsolateID, sep = ".")

# Drop empty sequences shows entry in fungi didn't have a sequence in the original fasta file
seqs_ordered <- seqs_ordered[sapply(seqs_ordered, function(x) !is.null(x))]
                            

# Write out new FASTA file
write.fasta(seqs_ordered, names(seqs_ordered), file.path(seq_dir, "BIO46_ITS_fungal_sequences_ordered.fas"))
