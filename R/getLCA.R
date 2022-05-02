#' Get last common ancestor for a list of taxa
#' @export
#' @importFrom stats complete.cases
#' @param taxonList List of taxa
#' @return A dataframe contains taxon ID and name of the last common ancestor
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' taxonList <- c("Homo sapiens", "Mus musculus", "Bos taurus")
#' getLCA(taxonList)

getLCA <- function(taxonList = NULL) {
    if (is.null(taxonList)) stop("No list of taxa given!")
    # convert taxon list and supertaxon into IDs
    idList <- convert2id(taxonList)
    # create taxonomy matrix
    taxMatrix <- createTaxonomyMatrix(idList)
    # get LCA
    df <- t(taxMatrix[taxMatrix$ncbiID %in% idList,])
    df <- df[complete.cases(df),]
    common <- apply(df, 1, function(x) length(unique(x[!is.na(x)])) == 1)
    ancestor <- df[common,][1]
    out <- id2name(ancestor)
    return(out)
}