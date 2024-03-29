% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getRanks.R
\name{getHierarchy}
\alias{getHierarchy}
\title{Get taxonomy hierarchy string for a list of taxon IDs}
\usage{
getHierarchy(inputTaxa = NULL, currentNCBIinfo = NULL)
}
\arguments{
\item{inputTaxa}{NCBI ID list of input taxa.}

\item{currentNCBIinfo}{table/dataframe of the pre-processed NCBI taxonomy
data (/PhyloProfile/data/preProcessedTaxonomy.txt)}
}
\value{
A list of taxonomy hierarchy vector for input taxon IDs
}
\description{
Get NCBI taxonomy IDs, ranks and names for an input taxon list.
}
\examples{
inputTaxa <- c("272557", "176299")
preProcessedTaxonomy <- getPreTaxonomyFile()
taxFun:::getHierarchy(inputTaxa, preProcessedTaxonomy)
}
\author{
Vinh Tran {tran@bio.uni-frankfurt.de}
}
