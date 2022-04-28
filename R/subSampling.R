#' Get representative from a list of taxa based on a selected taxonomy rank
#' @export
#' @param taxonList List of taxa
#' @param rank Taxonomy rank used for sub-sampling. Each super taxon of this
#' rank will have one representative.
#' @return A dataframe contains sub-selected taxa including their IDs, names, as
#' well as IDs and names of the supertaxa from the selected rank.
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' taxonList <- c(
#'     214684, 246409, 3055, 336722, 3702, 400682, 441375, 45351, 4558, 559292, 
#'     6239, 7227, "Homo sapiens"
#' )
#' getRepresentative(taxonList, rank = "phylum")

getRepresentative <- function(taxonList = NULL, rank = NULL) {
    if (is.null(taxonList)) stop("No list of taxa given!")
    if (is.null(rank)) stop("No rank specified!")
    # convert taxon list into IDs
    idList <- convert2id(taxonList)
    # create taxonomy matrix
    taxMatrix <- createTaxonomyMatrix(idList)
    # check valid rank input
    if (!(rank %in% colnames(taxMatrix))) {
        matrixRanks <- levels(as.factor(colnames(taxMatrix)))
        validRanks <- matrixRanks[
            matrixRanks %in% PhyloProfile::mainTaxonomyRank()
        ]
        stop(paste(
            rank, "invalid or not found. Avaliable ranks are:",
            paste(validRanks, collapse = ", ")
        ))
    }
    # get representative taxon for selected rank
    taxMatrixSub <- taxMatrix[, c("ncbiID", "fullName", rank)]
    taxMatrixSub <- taxMatrixSub[!(duplicated(taxMatrixSub[rank])),]
    superTaxonDf <- id2name(taxMatrixSub[[rank]])
    colnames(superTaxonDf) <- c(rank, "superTaxon")
    outDf <- merge(taxMatrixSub, superTaxonDf, by = rank, all.x = TRUE)
    outDf <- outDf[, c("ncbiID", "fullName", rank, "superTaxon")]
    return(outDf)
}


#' Get subset of taxa that belong to a specified taxonomy clade
#' @export
#' @importFrom dplyr filter
#' @param taxonList List of taxa
#' @param supertaxon Clade / supertaxon ID or name
#' @return A dataframe contains sub-selected taxa including their IDs and names
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' taxonList <- c(
#'     214684, 246409, 3055, 336722, 3702, 400682, 441375, 45351, 4558, 559292, 
#'     6239, 7227, "Homo sapiens"
#' )
#' getClade(taxonList, supertaxon = "metazoa")

getClade <- function(taxonList = NULL, supertaxon = NULL) {
    if (is.null(taxonList)) stop("No list of taxa given!")
    if (is.null(supertaxon)) stop("No supertaxon specified!")
    # convert taxon list and supertaxon into IDs
    idList <- convert2id(taxonList)
    supertaxonID <- convert2id(supertaxon)
    # create taxonomy matrix
    taxMatrix <- createTaxonomyMatrix(idList)
    # get all taxa belong to supertaxon
    outDf <- dplyr::filter(
        taxMatrix, 
        row.names(taxMatrix) %in% 
            rownames(which(taxMatrix == supertaxonID, arr.ind=TRUE))
    )
    outDf <- outDf[, c("ncbiID", "fullName")]
    return(outDf)
}