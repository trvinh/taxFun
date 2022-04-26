#' Get taxon names for a list of taxon IDs
#' @export
#' @param idList list of taxonomy IDs
#' @return A dataframe contains input taxon Ids and their full names.
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' idList <- c("9606", "5207", "40674", "4751")
#' id2name(idList)

id2name <- function(idList = NULL) {
    if (is.null(idList)) stop("No list of taxon IDs given!")
    preProcessedTaxonomy <- getPreTaxonomyFile()
    # get taxon names
    nameList <- preProcessedTaxonomy[
        preProcessedTaxonomy$ncbiID %in% idList, c("ncbiID","fullName")
    ]
    return(nameList)
}

#' Get taxon IDs for a list of taxon names
#' @export
#' @param nameList list of taxonomy names
#' @return A dataframe contains input taxon names and their IDs.
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' nameList <- c("Homo sapiens", "fungi", "mammalia", "Cryptococcus neoformans")
#' name2id(nameList)

name2id <- function(nameList = NULL) {
    if (is.null(nameList)) stop("No list of taxon names given!")
    preProcessedTaxonomy <- getPreTaxonomyFile()
    # get taxon names
    idList <- preProcessedTaxonomy[
        preProcessedTaxonomy$fullName %in% firstup(nameList),
        c("fullName","ncbiID")
    ]
    return(idList)
}
