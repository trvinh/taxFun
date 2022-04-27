#' Run taxFun
#' @export
#' @importFrom utils read.csv
#' @importFrom ape write.tree
#' @usage taxFun(fnName, inputListFile, rank, ranks, refspec, outgroup,
#' outputFile)
#' @param fnName Function name, either "id2name", "name2id", "getRank", 
#' "getRanks", "sortTaxonomyMatrix", "createTree", "getRepresentative", 
#' or "getAllTaxonomyRanks"
#' @param rank A selected taonomy rank (REQUIRED for some functions)
#' @param ranks List of taxonomy ranks of interest (OPTIONAL)
#' @param refspec Reference species (REQUIRED for some functions)
#' @param outgroup Output species used for rooting the tree (OPTIONAL for tree
#' functions)
#' @param inputListFile Location of input file (list of taxon names or ids)
#' @param outputFile Location of output file. If not given, it will be saved as
#' <inputFile.out>
#' @return Output file
#' @examples
#' inputListId <- system.file(
#'     "extdata", "ids.txt", package = "taxFun", mustWork = TRUE
#' )
#' inputListName <- system.file(
#'     "extdata", "names.txt", package = "taxFun", mustWork = TRUE
#' )
#' taxFun("id2name", inputListId)
#' taxFun("getRank", inputListName)
#' taxFun("getRanks", inputListName, ranks = c("class", "phylum"))
#' taxFun("createTree", inputListName, outgroup = 9606)
#' taxFun("sortTaxonomyMatrix", inputListId, refspec = "Homo sapiens")
#' taxFun("getRepresentative", inputListId, rank = "phylum")

taxFun <- function(
    fnName = NULL, inputListFile = NULL, rank = NULL,
    ranks = NULL, refspec = NULL, outgroup = NULL,
    outputFile = NULL
) {
    if (is.null(inputListFile)) stop("No input file given!")
    ### load input
    inputListDf <- read.csv(
        inputListFile, stringsAsFactors = FALSE, header = FALSE
    )
    inputList <- inputListDf$V1

    ### perform function
    if (fnName == "id2name") {
        outDf <- id2name(inputList)
        if (is.null(outputFile)) outputFile <- paste0(inputListFile, ".2name")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "name2id") {
        outDf <- name2id(inputList)
        if (is.null(outputFile)) outputFile <- paste0(inputListFile, ".2id")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getRank") {
        outDf <- getRank(inputList)
        if (is.null(outputFile)) outputFile <- paste0(inputListFile, ".2rank")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getRanks") {
        outDf <- getRanks(inputList, ranks)
        if (is.null(outputFile)) outputFile <- paste0(inputListFile, ".ranks")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getAllTaxonomyRanks") {
        outDf <- getAllTaxonomyRanks()
        if (is.null(outputFile)) outputFile <- "allTaxonomyRanks.txt"
        write.table(
            outDf, file = outputFile,
            col.names = FALSE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "sortTaxonomyMatrix") {
        outDf <- sortTaxonomyMatrix(inputList, refspec)
        if (is.null(outputFile))
            outputFile <- paste0(inputListFile, ".sortedTaxonomyMatrix")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "createTree") {
        outTree <- createTree(inputList, outgroup)
        if (is.null(outputFile)) outputFile <- paste0(inputListFile, ".tree")
        ape::write.tree(outTree, file = outputFile)
    } else if (fnName == "getRepresentative") {
        outDf <- getRepresentative(inputList, rank)
        if (is.null(outputFile))
            outputFile <- paste0(inputListFile, ".subSelected")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else {
        stop("Wrong function name")
    }
    print(paste("Done! Find output at:", outputFile))
    return(1)
}
