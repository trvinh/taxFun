# taxFun

*taxFun* is an R package that provides functions for working with NCBI taxonomy IDs and names.

# Table of Contents
* [Installation &amp; Usage](#installation--usage)
* [Functions](#functions)
* [Bugs](#bugs)
* [License](#license)
* [How-to-cite](#how-to-cite)
* [Contact](#contact)

# Installation & Usage
*taxFun* requires the latest version of [R](https://cran.r-project.org). Please install or update R on your computer before continue.

* [R for Linux](https://cran.r-project.org/bin/linux/)
* [R for Mac OS](https://cran.r-project.org/bin/macosx/)
* [R for Windows](https://cran.r-project.org/bin/windows/base/)

## Install using devtools
*taxFun* can be installed from this github repository using `devtools`:

```r
if (!requireNamespace("devtools"))
    install.packages("devtools")
devtools::install_github("trvinh/taxFun", INSTALL_opts = c('--no-lock'), build_vignettes = TRUE)
```

## Usage

From the R terminal, enter:
```r
library(taxFun)
```

to load *taxFun* package. Then to learn about *taxFun* functions please use this command
```r
?taxFun
```

# Functions
*taxFun* command has this structure
```r
taxFun(function_name, input, options, output)
```

These are the list of available functions in *taxFun* and their parameters

| Function name | <img width=300/>Main input | <img width=400/>Output | Other options |
|---|---|---|---|
| getAllTaxonomyRanks | None | A list of all available NCBI taxonomy ranks | None |
| id2name | List of taxon IDs | A table containing input taxon IDs and their scientific names | None |
| name2id | List of taxon names | A table containing input taxon names and their taxon IDs | None |
| id2rank | List of taxon IDs | A table containing input taxon IDs and their taxonomy ranks | None |
| name2rank | List of taxon names | A table containing input taxon names and their taxonomy ranks | None |
| getRanks4Id | List of taxon IDs | A table containing input taxon IDs, their scientific names and the names of selected taxonomy ranks | List of selected taxonomy ranks (Options: if not given, all possible taxonomy ranks will be considered) |
| getRanks4Name | List of taxon names | A table containing input taxon names, their taxon IDs and the names of selected taxonomy ranks | List of selected taxonomy ranks (Options: if not given, all possible taxonomy ranks will be considered) |
| sortTaxonomyMatrix4Id | List of taxon IDs | A clustered taxonomy matrix, shorted by a selected reference species | A specified reference species |
| sortTaxonomyMatrix4Name | List of taxon names | A clustered taxonomy matrix, shorted by a selected reference species | A specified reference species |
| getRepresentative | coming soon | coming soon | coming soon |
| getTree | coming soon | coming soon | coming soon |

*If not specified, output file will be saved as `input.out`*

For example:

```r
# convert IDs to names
idFile <- "inst/ids.txt"
taxFun(id2name, idFile)

# get names of class, family and phylum for a list of given taxon names
nameFile <- "inst/names.txt"
selectedRanks <- c("class", "family", "phylum")
taxFun(getRanks4name, nameFile, ranks = selectedRanks)
```

# Bugs
Any [bug reports or comments, suggestions](https://github.com/BIONF/PhyloProfile/blob/master/CONTRIBUTING.md) are highly appreciated. Please [open an issue on GitHub](https://github.com/BIONF/PhyloProfile/issues/new) or be in touch via email.

# License
This tool is released under [MIT license](https://github.com/BIONF/PhyloProfile/blob/master/LICENSE).

# How-To Cite
Use the citation function in R CMD to have it directly in BibTex or LaTeX format
```r
citation("taxFun")
```
# Contact
Vinh Tran
tran@bio.uni-frankfurt.de
