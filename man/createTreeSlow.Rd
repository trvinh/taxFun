% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getTree.R
\name{createTreeSlow}
\alias{createTreeSlow}
\title{Create taxonomy tree for a list of taxa (slow version)}
\usage{
createTreeSlow(taxonList = NULL, outgroup = NULL)
}
\arguments{
\item{taxonList}{list of taxonomy IDs}

\item{outgroup}{a taxon used for rooting}
}
\value{
A taxonomy tree as a phylo object
}
\description{
Create taxonomy tree for a list of taxa (slow version)
}
\examples{
taxonList <- c("Homo sapiens", "5207", "40674", "4751")
tree <- createTreeSlow(taxonList, "5207")
plot(tree)
}
\author{
Vinh Tran {tran@bio.uni-frankfurt.de}
}
