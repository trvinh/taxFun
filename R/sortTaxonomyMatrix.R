#' Create a clustered taxonomy matrix for a list of taxon IDs
#' @description Create a clustered taxonomy matrix for a list of taxon IDs, 
#' sorted based on a defined reference species
#' @export
#' @param idList list of taxonomy IDs
#' @param refspec reference taxon
#' @return A dataframe contains clustered taxonomy matrix
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' idList <- c("9606", "5207", "40674", "4751", "3702", "72664")
#' sortTaxonomyMatrix4Id(idList, "Homo sapiens")

sortTaxonomyMatrix4Id <- function(idList = NULL, refspec = NULL) {
    if (is.null(idList)) stop("No list of taxon IDs given!")
    if (is.null(refspec)) stop("A reference species muss be specified")
    ncbiID <- fullName <- NULL
    refspecTmp <- suppressWarnings(as.numeric(refspec))
    if (!is.na(refspecTmp)) {
        refspecDf <- id2name(refspecTmp)
        refspec <- refspecDf$fullName
    }
    currentNCBIinfo <- getPreTaxonomyFile()
    print("Parsing taxonomy info...")
    newTaxInfo <- PhyloProfile::getIDsRank(
        inputTaxa = idList, currentNCBIinfo = currentNCBIinfo
    )
    rankList <- as.data.frame(newTaxInfo[2])
    idList <- as.data.frame(newTaxInfo[1])
    print("Output temp files...")
    write.table(
        idList,
        file  = "tmp.idList",
        col.names = FALSE, row.names = FALSE, quote = FALSE, sep = "\t"
    )
    write.table(
        rankList,
        file = "tmp.rankList",
        col.names = FALSE, row.names = FALSE, quote = FALSE, sep = "\t"
    )
    taxMatrix <- PhyloProfile::taxonomyTableCreator(
        "tmp.idList", "tmp.rankList"
    )
    unlink("tmp.idList")
    unlink("tmp.rankList")
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

#' Create a clustered taxonomy matrix for a list of taxon names
#' @description Create a clustered taxonomy matrix for a list of taxon names, 
#' sorted based on a defined reference species
#' @export
#' @param nameList list of taxonomy names
#' @param refspec reference taxon
#' @return A dataframe contains clustered taxonomy matrix
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' nameList <- c(
#' "Homo sapiens", "Mammalia", "Cryptococcus neoformans", "Fungi", 
#' "Arabidopsis thaliana", "Eutrema salsugineum"
#' )
#' sortTaxonomyMatrix4Name(nameList, "Homo sapiens")

sortTaxonomyMatrix4Name <- function(nameList = NULL, refspec = NULL) {
    if (is.null(nameList)) stop("No list of taxon names given!")
    if (is.null(refspec)) stop("A reference species muss be specified")
    
    idsDf <- name2id(nameList)
    if (nrow(idsDf) < 1) stop("Input file contains all invalid taxon names")
    
    sortedTaxMatrix <- sortTaxonomyMatrix4Id(idsDf$ncbiID, refspec)
    return(sortedTaxMatrix)
}