#' Create an aligned taxonomy matrix for a list of taxon IDs
#' @export
#' @param idList list of taxonomy IDs
#' @return A dataframe contains clustered taxonomy matrix
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' idList <- c("9606", "5207", "40674", "4751", "3702", "72664")
#' createTaxonomyMatrix(idList)

createTaxonomyMatrix <- function(idList) {
    if (is.null(idList)) stop("No list of taxon IDs given!")
    currentNCBIinfo <- getPreTaxonomyFile()
    print("Creating taxonomy matrix...")
    newTaxInfo <- PhyloProfile::getIDsRank(
        inputTaxa = idList, currentNCBIinfo = currentNCBIinfo
    )
    rankList <- as.data.frame(newTaxInfo[2])
    idList <- as.data.frame(newTaxInfo[1])
    write.table(
        idList, file  = "tmp.idList",
        col.names = FALSE, row.names = FALSE, quote = FALSE, sep = "\t"
    )
    write.table(
        rankList, file = "tmp.rankList",
        col.names = FALSE, row.names = FALSE, quote = FALSE, sep = "\t"
    )
    taxMatrix <- PhyloProfile::taxonomyTableCreator(
        "tmp.idList", "tmp.rankList"
    )
    unlink("tmp.idList")
    unlink("tmp.rankList")
    return(taxMatrix)
}

#' Sort a taxonomy matrix based on a defined reference species
#' @description Sort a clustered taxonomy matrix for a list of taxon IDs, 
#' sorted based on a defined reference species
#' @export
#' @param taxonList list of taxonomy IDs
#' @param refspec reference taxon
#' @return A dataframe contains clustered taxonomy matrix
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' taxonList <- c("Homo sapiens", "5207", "40674", "4751", "3702", "72664")
#' sortTaxonomyMatrix(taxonList, "Homo sapiens")

sortTaxonomyMatrix <- function(taxonList = NULL, refspec = NULL) {
    if (is.null(taxonList)) stop("No list of taxon IDs given!")
    if (is.null(refspec)) stop("A reference species muss be specified")
    ncbiID <- fullName <- NULL
    # convert taxon list and refspec to IDs
    idList <- convert2id(taxonList)
    refspec <- convert2name(refspec)
    # create taxonomy matrix
    taxMatrix <- createTaxonomyMatrix(idList)
    # sort taxonomy matrix
    repTaxon <- taxMatrix[taxMatrix$fullName == refspec, ][1, ]
    distDf <- subset(taxMatrix, select = -c(ncbiID, fullName))
    row.names(distDf) <- distDf$abbrName
    distDf <- distDf[, -1]
    taxaTree <- PhyloProfile::createRootedTree(
        distDf, as.character(repTaxon$abbrName)
    )
    taxonList <- PhyloProfile::sortTaxaFromTree(taxaTree)
    sortedTaxMatrix <- taxMatrix[match(taxonList, taxMatrix$abbrName), ]
    selectedCols <- c(
        "fullName",
        colnames(sortedTaxMatrix)[
            colnames(sortedTaxMatrix) %in% taxFun::getAllTaxonomyRanks()
        ]
    )
    sortedTaxMatrix <- sortedTaxMatrix[, selectedCols]
    return(sortedTaxMatrix)
}