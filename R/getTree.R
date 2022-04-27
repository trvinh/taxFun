#' Create taxonomy tree for a list of taxa
#' @export
#' @importFrom ape root
#' @param taxonList list of taxonomy IDs
#' @param outgroup a taxon used for rooting
#' @return A taxonomy tree as a phylo object
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' taxonList <- c("Homo sapiens", "5207", "40674", "4751")
#' tree <- createTree(taxonList, "5207")
#' plot(tree)

createTree <- function(taxonList = NULL, outgroup = NULL) {
    if (is.null(taxonList)) stop("No list of taxon IDs given!")
    nameList <- convert2name(taxonList)
    outTaxize <- taxize::classification(nameList, db = 'ncbi')
    tree <- taxize::class2tree(outTaxize)
    if(!is.null(outgroup)) {
        # convert outgroup species from ID to name (if needed)
        outgroup <- convert2name(outgroup)
        # root the tree
        if (firstup(outgroup) %in% firstup(nameList)) {
            tree <- ape::root(tree$phylo, outgroup = firstup(outgroup))
            return(tree)
        } else {
            print(paste(outgroup, "not found in tree for rooting"))
        }
    } 
    return(tree$phylo)
}