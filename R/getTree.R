#' create taxonomy tree for a list of taxon names
#' @export
#' @param idList list of taxonomy IDs
#' @return A dataframe contains input taxon Ids, their full names and the 
#' corresponding ranks
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' idList <- c("9606", "5207", "40674", "4751")
#' tree <- getTree4Id(idList)
#' plot(tree)

getTree4Id <- function(idList = NULL) {
    if (is.null(idList)) stop("No list of taxon IDs given!")
    nameListDf <- id2name(idList)
    outTaxize <- taxize::classification(nameListDf$fullName, db = 'ncbi')
    tree <- taxize::class2tree(outTaxize)
    return(tree)
}

#' create taxonomy tree for a list of taxon names
#' @export
#' @param nameList list of taxonomy names
#' @return A dataframe contains input taxon Ids, their full names and the 
#' corresponding ranks
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' nameList <- c("Homo sapiens", "fungi", "mammalia", "Cryptococcus neoformans")
#' tree <- getTree4Name(nameList)
#' plot(tree)

getTree4Name <- function(nameList = NULL) {
    if (is.null(nameList)) stop("No list of taxon names given!")
    outTaxize <- taxize::classification(nameList, db = 'ncbi')
    tree <- taxize::class2tree(outTaxize)
    return(tree)
}