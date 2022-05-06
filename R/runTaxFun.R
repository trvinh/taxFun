#' Run taxFun
#' @export
#' @importFrom utils read.csv
#' @importFrom ape write.tree
#' @usage taxFun(fnName, inputTaxaFile, rank, ranks, refspec, supertaxon, 
#' outgroup, outputFile)
#' @param fnName Function name, either "id2name", "name2id", "getRank", 
#' "getRanks", "sortTaxonomyMatrix", "createTree", "createTreeSlow",
#' "getRepresentative", "getClade", "getLCA" or "getAllTaxonomyRanks"
#' @param rank A selected taonomy rank (REQUIRED for some functions)
#' @param ranks List of taxonomy ranks of interest (OPTIONAL)
#' @param refspec Reference species (REQUIRED for some functions)
#' @param supertaxon Supertaxon name or ID (REQUIRED for some functions)
#' @param outgroup Output species used for rooting the tree (OPTIONAL for tree
#' functions)
#' @param inputTaxaFile Location of input taxa file (taxon names or/and ids)
#' @param outputFile Location of output file. If not given, it will be saved as
#' <inputFile.out>
#' @return Output file
#' @examples
#' inputTaxonIDs <- system.file(
#'     "extdata", "ids.txt", package = "taxFun", mustWork = TRUE
#' )
#' inputTaxonNames <- system.file(
#'     "extdata", "names.txt", package = "taxFun", mustWork = TRUE
#' )
#' taxFun("id2name", inputTaxonIDs)
#' taxFun("getRank", inputTaxonNames)
#' taxFun("getRanks", inputTaxonNames, ranks = c("class", "phylum"))
#' taxFun("createTree", inputTaxonNames, outgroup = 9606)
#' taxFun("sortTaxonomyMatrix", inputTaxonIDs, refspec = "Homo sapiens")
#' taxFun("getRepresentative", inputTaxonIDs, rank = "phylum")
#' taxFun("getClade", inputTaxonIDs, supertaxon = "metazoa")
#' taxFun("getLCA", inputTaxonNames)

taxFun <- function(
    fnName = NULL, inputTaxaFile = NULL, 
    rank = NULL, ranks = NULL, refspec = NULL, supertaxon = NULL, 
    outgroup = NULL, outputFile = NULL
) {
    if (is.null(inputTaxaFile)) stop("No input file given!")
    ### load input
    inputListDf <- read.csv(
        inputTaxaFile, stringsAsFactors = FALSE, header = FALSE
    )
    inputList <- inputListDf$V1

    ### perform function
    if (fnName == "id2name") {
        outDf <- id2name(inputList)
        if (is.null(outputFile)) outputFile <- paste0(inputTaxaFile, ".2name")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "name2id") {
        outDf <- name2id(inputList)
        if (is.null(outputFile)) outputFile <- paste0(inputTaxaFile, ".2id")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getRank") {
        outDf <- getRank(inputList)
        if (is.null(outputFile)) outputFile <- paste0(inputTaxaFile, ".2rank")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getRanks") {
        outDf <- getRanks(inputList, ranks)
        if (is.null(outputFile)) outputFile <- paste0(inputTaxaFile, ".ranks")
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
            outputFile <- paste0(inputTaxaFile, ".sortedTaxonomyMatrix")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "createTree") {
        outTree <- createTree(inputList, outgroup)
        if (is.null(outputFile)) outputFile <- paste0(inputTaxaFile, ".tree")
        ape::write.tree(outTree, file = outputFile)
    } else if (fnName == "createTreeSlow") {
        outTree <- createTreeSlow(inputList, outgroup)
        if (is.null(outputFile)) outputFile <- paste0(inputTaxaFile, ".tree")
        ape::write.tree(outTree, file = outputFile)
    } else if (fnName == "getRepresentative") {
        outDf <- getRepresentative(inputList, rank)
        if (is.null(outputFile))
            outputFile <- paste0(inputTaxaFile, ".representative")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getClade") {
        outDf <- getClade(inputList, supertaxon)
        if (is.null(outputFile))
            outputFile <- paste0(inputTaxaFile, ".subselected")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getLCA") {
        outDf <- getLCA(inputList)
        print(outDf)
        if (is.null(outputFile))
            outputFile <- paste0(inputTaxaFile, ".lca")
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
