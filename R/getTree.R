#' create taxonomy tree for a list of taxon names
#' @export
#' @importFrom ape root
#' @param idList list of taxonomy IDs
#' @param outgroup a taxon used for rooting
#' @return A taxonomy tree as phylo object
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' idList <- c("9606", "5207", "40674", "4751")
#' tree <- getTree4Id(idList, 40674)
#' plot(tree)

getTree4Id <- function(idList = NULL, outgroup = NULL) {
    if (is.null(idList)) stop("No list of taxon IDs given!")
    nameListDf <- id2name(idList)
    outTaxize <- taxize::classification(nameListDf$fullName, db = 'ncbi')
    tree <- taxize::class2tree(outTaxize)
    if(!is.null(outgroup)) {
        # convert outgroup species from ID to name (if needed)
        outgroupTmp <- suppressWarnings(as.numeric(outgroup))
        if (!is.na(outgroupTmp)) {
            outgroupDf <- id2name(outgroupTmp)
            outgroup <- outgroupDf$fullName
        }
        # root the tree
        if (firstup(outgroup) %in% firstup(nameListDf$fullName)) {
            tree <- ape::root(tree$phylo, outgroup = firstup(outgroup))
            return(tree)
        } else {
            print(paste(outgroup, "not found in tree for rooting"))
        }
    } 
    return(tree$phylo)
}

#' create taxonomy tree for a list of taxon names
#' @export
#' @importFrom ape root
#' @param nameList list of taxonomy names
#' @param outgroup a taxon used for rooting
#' @return A taxonomy tree as phylo object
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' nameList <- c("Homo sapiens", "fungi", "mammalia", "Cryptococcus neoformans")
#' tree <- getTree4Name(nameList, "Fungi")
#' plot(tree)

getTree4Name <- function(nameList = NULL, outgroup = NULL) {
    if (is.null(nameList)) stop("No list of taxon names given!")
    outTaxize <- taxize::classification(nameList, db = 'ncbi')
    tree <- taxize::class2tree(outTaxize)
    if (!is.null(outgroup)) {
        if (firstup(outgroup) %in% firstup(nameList)) {
            tree <- ape::root(tree$phylo, outgroup = firstup(outgroup))
            return(tree)
        } else {
            print(paste(outgroup, "not found in tree for rooting"))
        }
    }
    return(tree$phylo)
}