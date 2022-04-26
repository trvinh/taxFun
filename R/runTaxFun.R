#' Run taxFun
#' @export
#' @importFrom utils read.csv
#' @importFrom ape write.tree
#' @param fnName Function name, either "id2name", "name2id", "id2rank", 
#' "name2rank", "getRanks4Id", "getRanks4Name", "sortTaxonomyMatrix4Id", 
#' "sortTaxonomyMatrix4Name", "getTree4Id", "getTree4Name" or
#' "getAllTaxonomyRanks"
#' @param ranks List of taxonomy ranks of interest (OPTIONAL)
#' @param refspec Reference species (REQUIRED for some functions)
#' @param outgroup Output species used for rooting the tree (OPTIONAL for tree
#' functions)
#' @param inputListFile Location of input file (list of taxon names or ids)
#' @param outputFile Location of output file. If not given, it will be saved as
#' <inputFile.out>
#' @examples
#' \dontrun{
#' inputListId <- system.file(
#'     "extdata", "ids.txt", package = "taxFun", mustWork = TRUE
#' )
#' inputListName <- system.file(
#'     "extdata", "names.txt", package = "taxFun", mustWork = TRUE
#' )
#' taxFun("id2name", inputListId)
#' taxFun("name2rank", inputListName)
#' taxFun("getRanks4Name", inputListName, ranks = c("class", "phylum"))
#' }

taxFun <- function(
    fnName = NULL, inputListFile = NULL, 
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
    } else if (fnName == "id2rank") {
        outDf <- id2rank(inputList)
        if (is.null(outputFile)) outputFile <- paste0(inputListFile, ".2rank")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "name2rank") {
        outDf <- name2rank(inputList)
        if (is.null(outputFile)) outputFile <- paste0(inputListFile, ".2rank")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getRanks4Id") {
        outDf <- getRanks4Id(inputList, ranks)
        if (is.null(outputFile)) outputFile <- paste0(inputListFile, ".ranks")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getRanks4Name") {
        outDf <- getRanks4Name(inputList, ranks)
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
    } else if (fnName == "sortTaxonomyMatrix4Id") {
        outDf <- sortTaxonomyMatrix4Id(inputList, refspec)
        if (is.null(outputFile)) 
            outputFile <- paste0(inputListFile, ".sortedTaxonomyMatrix")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "sortTaxonomyMatrix4Name") {
        outDf <- sortTaxonomyMatrix4Name(inputList, refspec)
        if (is.null(outputFile)) 
            outputFile <- paste0(inputListFile, ".sortedTaxonomyMatrix")
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getTree4Id") {
        outTree <- getTree4Id(inputList, outgroup)
        if (is.null(outputFile)) outputFile <- paste0(inputListFile, ".tree")
        ape::write.tree(outTree, file = outputFile)
    } else if (fnName == "getTree4Name") {
        outTree <- getTree4Name(inputList, outgroup)
        if (is.null(outputFile)) outputFile <- paste0(inputListFile, ".tree")
        ape::write.tree(outTree, file = outputFile)
    } else {
        stop("Wrong function name")
    }
    print(paste("Done! Find output at:", outputFile))
    return(1)
}