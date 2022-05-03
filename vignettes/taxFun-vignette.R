## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
    library(taxFun),
    collapse = TRUE,
    comment = "#>",
    dev = 'png',
    crop = NULL
)

## -----------------------------------------------------------------------------
if (!requireNamespace("devtools"))
    install.packages("devtools")
devtools::install_github("trvinh/taxFun", INSTALL_opts = c('--no-lock'), build_vignettes = TRUE)

## -----------------------------------------------------------------------------
# specify list of taxon IDs or taxon names
idFile <- system.file(
    "extdata", "ids.txt", package = "taxFun", mustWork = TRUE
)
nameFile <- system.file(
    "extdata", "names.txt", package = "taxFun", mustWork = TRUE
)

# convert IDs to names
taxFun("id2name", idFile)

# get names of class, family and phylum for a list of given taxon names
taxFun("getRanks", nameFile, ranks = c("class", "family", "phylum"))

# create an aligned taxonomy hierarchies for a list of taxon IDs
taxFun("sortTaxonomyMatrix", idFile, refspec = "Homo sapiens")

# create taxonomy tree rooted by an outgroup species
taxFun("createTree", nameFile, outgroup = "Homo sapiens")

# sub-sample taxa on phylum level
taxFun("getRepresentative", idFile, rank = "phylum")

# get all metazoa species
taxFun("getClade", idFile, supertaxon = "metazoa")

# get last common ancestor
taxFun("getLCA", nameFile)

## -----------------------------------------------------------------------------
citation("taxFun")

## ----sessionInfo, echo = FALSE------------------------------------------------
sessionInfo(package = "taxFun")

