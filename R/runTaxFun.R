#' Run taxFun
#' @export
#' @importFrom utils read.csv
#' @param fnName Function name, either "id2name", "name2id", "id2rank", 
#' "name2rank", "getRanks4Name", "getRanks4Id", or "getAllTaxonomyRanks"
#' @param ranks List of taxonomy ranks of interest (OPTIONAL)
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
    fnName = NULL, inputListFile = NULL, ranks = NULL, outputFile = NULL
) {
    if (is.null(inputListFile)) stop("No input file given!")
    ### load input
    inputListDf <- read.csv(
        inputListFile, stringsAsFactors = FALSE, header = FALSE
    )
    inputList <- inputListDf$V1
    ### output file
    if (is.null(outputFile)) outputFile <- paste0(inputListFile, ".out")
    
    ### perform function
    if (fnName == "id2name") {
        outDf <- id2name(inputList)
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "name2id") {
        outDf <- name2id(inputList)
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "id2rank") {
        outDf <- id2rank(inputList)
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "name2rank") {
        outDf <- name2rank(inputList)
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getRanks4Id") {
        outDf <- getRanks4Id(inputList, ranks)
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getRanks4Name") {
        outDf <- getRanks4Name(inputList, ranks)
        write.table(
            outDf, file = outputFile,
            col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else if (fnName == "getAllTaxonomyRanks") {
        outDf <- getAllTaxonomyRanks()
        write.table(
            outDf, file = outputFile,
            col.names = FALSE, row.names = FALSE, quote = FALSE, sep = "\t"
        )
    } else {
        stop("Wrong function name")
    }
    print(paste("Done! Find output at:", outputFile))
    return(1)
}