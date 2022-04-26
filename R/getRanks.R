#' Get taxonomy ranks for a list of taxon IDs
#' @export
#' @param idList list of taxonomy IDs
#' @return A dataframe contains input taxon Ids, their full names and the 
#' corresponding ranks
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' idList <- c("9606", "5207", "40674", "4751")
#' id2rank(idList)

id2rank <- function(idList = NULL) {
    if (is.null(idList)) stop("No list of taxon IDs given!")
    preProcessedTaxonomy <- getPreTaxonomyFile()
    # get taxon ranks
    rankList <- preProcessedTaxonomy[
        preProcessedTaxonomy$ncbiID %in% idList, c("ncbiID", "fullName", "rank")
    ]
    return(rankList)
}

#' Get taxonomy ranks for a list of taxon names
#' @export
#' @param nameList list of taxonomy names
#' @return A dataframe contains input taxon names, their IDs and the 
#' corresponding ranks
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' nameList <- c("Homo sapiens", "fungi", "mammalia", "Cryptococcus neoformans")
#' name2rank(nameList)

name2rank <- function(nameList = NULL) {
    if (is.null(nameList)) stop("No list of taxon names given!")
    preProcessedTaxonomy <- getPreTaxonomyFile()
    # get taxon ranks
    rankList <- preProcessedTaxonomy[
        preProcessedTaxonomy$fullName %in% firstup(nameList),
        c("ncbiID", "fullName", "rank")
    ]
    return(rankList)
}

#' Get taxonomy hierarchy string for a list of taxon IDs
#' @export
#' @import data.table
#' @description Get NCBI taxonomy IDs, ranks and names for an input taxon list.
#' @param inputTaxa NCBI ID list of input taxa.
#' @param currentNCBIinfo table/dataframe of the pre-processed NCBI taxonomy
#' data (/PhyloProfile/data/preProcessedTaxonomy.txt)
#' @return A list of taxonomy hierarchy vector for input taxon IDs
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' inputTaxa <- c("272557", "176299")
#' preProcessedTaxonomy <- getPreTaxonomyFile()
#' getHierarchy(inputTaxa, preProcessedTaxonomy)

getHierarchy <- function(inputTaxa = NULL, currentNCBIinfo = NULL){
    if (is.null(currentNCBIinfo)) stop("Pre-processed NCBI tax data is NULL!")
    inputTaxaInfo <- PhyloProfile::getTaxonomyInfo(inputTaxa, currentNCBIinfo)
    allMainRank <- PhyloProfile::mainTaxonomyRank()
    ## get reduced taxonomy info (subset of preProcessedTaxonomy.txt)
    reducedDf <- unique(rbindlist(inputTaxaInfo))
    ## get list of all rank#IDs
    rankMod <- ncbiID <- NULL
    inputRankIDDf <- lapply(
        seq_len(length(inputTaxaInfo)),
        function (x) {
            inputTaxaInfo[[x]]$rank[
                !(inputTaxaInfo[[x]]$rank %in% allMainRank)] <- "norank"
            inputTaxaInfo[[x]]$rankMod <- inputTaxaInfo[[x]]$rank
            if (inputTaxaInfo[[x]]$rank[1] == "norank")
                inputTaxaInfo[[x]]$rankMod[1] <-
                paste0("strain_", inputTaxaInfo[[x]]$ncbiID[1])
            inputTaxaInfo[[x]]$rankMod <- with(
                inputTaxaInfo[[x]],
                ifelse(rankMod == "norank", paste0("norank_", ncbiID), rankMod))
            inputTaxaInfo[[x]]$id <- paste0(
                inputTaxaInfo[[x]]$fullName, "#", inputTaxaInfo[[x]]$rankMod)
            return(inputTaxaInfo[[x]][ , c("rankMod", "id")])
        }
    )
    taxStringList <- lapply(
        seq_len(length(inputRankIDDf)),
        function (x) {
            ll <- c(paste0(
                reducedDf$fullName[reducedDf$ncbiID==inputTaxa[x]],"#name"),
                inputRankIDDf[[x]]$id, "1#norank_1")
        }
    )
    return(taxStringList)
}

#' Get defined taxonomy ranks for a list of taxon IDs
#' @export
#' @import tidyr
#' @param idList list of taxonomy IDs
#' @param ranks list of defined ranks. If not given, all available ranks will 
#' be considered
#' @return A dataframe contains input taxon Ids, their full names and names of 
#' defined taxonomy ranks
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' idList <- c("9606", "5207", "40674", "4751")
#' ranks <- c("family", "class", "phylum", "kingdom")
#' getRanks4Id(idList, ranks)

getRanks4Id <- function(idList = NULL, ranks = NULL) {
    if (is.null(idList)) stop("No list of taxon IDs given!")
    if (is.null(ranks)) ranks <- PhyloProfile::mainTaxonomyRank()
    ori <- name <- NULL
    
    preProcessedTaxonomy <- getPreTaxonomyFile()
    # get taxonomy hierarchy list
    taxStringList <- getHierarchy(idList, preProcessedTaxonomy)
    # return selected rank names
    outDfList <- lapply(
        seq_len(length(taxStringList)), 
        function (x) {
            tmp <- as.data.frame(taxStringList[[x]])
            colnames(tmp) <- c("ori")
            tmp_split <- tidyr::separate(
                data = tmp, col = ori, into = c("name", "rank"), sep = "#"
            )
            tmp_reduced <- tmp_split[tmp_split$rank %in% c("name", ranks),]
            outDf <- tidyr::spread(tmp_reduced, rank, name)
            return(outDf)
        }
    )
    finalDf <- data.table::rbindlist(outDfList, fill = TRUE)
    finalDf <- finalDf[!duplicated(finalDf), ]
    finalDf <- as.data.frame(finalDf)
    finalDf$id <- idList
    finalDf <- finalDf[, c("id", "name", ranks[ranks %in% colnames(finalDf)])]
    return(finalDf)
}

#' Get defined taxonomy ranks for a list of taxon names
#' @export
#' @import tidyr
#' @param nameList list of taxonomy names
#' @param ranks list of defined ranks. If not given, all available ranks will 
#' be considered
#' @return A dataframe contains input taxon names, their IDs and names of 
#' defined taxonomy ranks
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' nameList <- c("Homo sapiens", "fungi", "mammalia", "Cryptococcus neoformans")
#' ranks <- c("family", "class", "phylum", "kingdom")
#' getRanks4Name(nameList, ranks)

getRanks4Name <- function(nameList = NULL, ranks = NULL) {
    if (is.null(nameList)) stop("No list of taxon names given!")
    if (is.null(ranks)) ranks <- PhyloProfile::mainTaxonomyRank()
    ori <- name <- NULL
    
    preProcessedTaxonomy <- getPreTaxonomyFile()
    # get taxonomy hierarchy list
    idList <- preProcessedTaxonomy$ncbiID[
        preProcessedTaxonomy$fullName %in% firstup(nameList)
    ]
    taxStringList <- getHierarchy(idList, preProcessedTaxonomy)
    # return selected rank names
    outDfList <- lapply(
        seq_len(length(taxStringList)), 
        function (x) {
            tmp <- as.data.frame(taxStringList[[x]])
            colnames(tmp) <- c("ori")
            tmp_split <- tidyr::separate(
                data = tmp, col = ori, into = c("name", "rank"), sep = "#"
            )
            tmp_reduced <- tmp_split[tmp_split$rank %in% c("name", ranks),]
            outDf <- tidyr::spread(tmp_reduced, rank, name)
            return(outDf)
        }
    )
    finalDf <- data.table::rbindlist(outDfList, fill = TRUE)
    finalDf <- finalDf[!duplicated(finalDf), ]
    finalDf <- as.data.frame(finalDf)
    finalDf$id <- idList
    finalDf <- finalDf[, c("id", "name", ranks[ranks %in% colnames(finalDf)])]
    return(finalDf)
}
