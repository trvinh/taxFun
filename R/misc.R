#' Get all NCBI taxonomy rank names
#' @export
#' @return A list of all available NCBI taxonomy rank names.
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' getAllTaxonomyRanks()

getAllTaxonomyRanks <- function() {
    return(PhyloProfile::mainTaxonomyRank())
}

#' Get PhyloProfile taxonomy file if available or create one if missing
#' @export
#' @importFrom utils write.table
#' @return A data table contains the NCBI taxonomy DB from PhyloProfile
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' preProcessedTaxonomy <- getPreTaxonomyFile()

getPreTaxonomyFile <- function() {
    ncbiFilein <- paste0(
        find.package("PhyloProfile"),
        "/PhyloProfile/data/preProcessedTaxonomy.txt"
    )
    if (file.exists(ncbiFilein)) {
        # print("Loading NCBI taxonomy file...")
        preProcessedTaxonomy <- data.table::fread(ncbiFilein)
    } else {
        print("Download and process NCBI taxonomy files...")
        preProcessedTaxonomy <- PhyloProfile::processNcbiTaxonomy()
        # save to text (tab-delimited) file
        packgePath <- find.package("PhyloProfile")
        print(paste("Save NCBI taxonomy DB into PhyloProfile at", packgePath))
        write.table(
            preProcessedTaxonomy,
            file = ncbiFilein,
            col.names = TRUE,
            row.names = FALSE,
            quote = FALSE,
            sep = "\t"
        )
    }
    return(preProcessedTaxonomy)
}

#' Capitalize the first character of string(s)
#' @param x list of strings
#' @return List of strings with the first character capitalized
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' ll <- c("one", "tWO", "Three")
#' taxFun:::firstup(ll)

firstup <- function(x) {
    substr(x, 1, 1) <- toupper(substr(x, 1, 1))
    x
}

#' Predict type (ID or NAME) for a list of input taxa
#' @param inputList list of taxa
#' @return ID or NAME
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' ids <- c("123", 456, 789)
#' taxFun:::predictType(ids)

predictType <- function(inputList) {
    tmp <- suppressWarnings(unlist(lapply(inputList, as.numeric)))
    tmp <- tmp[!(is.na(tmp))]
    if (length(tmp) == 0) return("NAME")
    if (length(tmp) < length(inputList)) {
        idList <- tmp
        nameList <- inputList[!(inputList %in% idList)]
        return(list(idList, nameList))
    }
    if (all(lapply(tmp, `%%`, 1) == 0)) return("ID")
}


#' Convert a list of input taxa into taxon IDs
#' @param taxonList list of taxa
#' @return A list of taxon IDs
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' taxonList <- c("Homo sapiens", "5207", "40674", "4751")
#' taxFun:::convert2id(taxonList)

convert2id <- function(taxonList) {
    type <- predictType(taxonList)
    if (type[1] == "ID") {
        idList <- taxonList
    } else if (type[1] == "NAME") {
        idDf <- name2id(taxonList)
        idList <- idDf$ncbiID
    } else {
        warning("Input contains probably both taxon IDs and NAMEs!")
        idDf <- name2id(type[[2]])
        idList <- c(type[[1]], idDf$ncbiID)
    }
    return(idList)
}


#' Convert a list of input taxa into taxon names
#' @param taxonList list of taxa
#' @return A list of taxon names
#' @author Vinh Tran {tran@bio.uni-frankfurt.de}
#' @examples
#' taxonList <- c("Homo sapiens", "5207", "40674", "4751")
#' taxFun:::convert2name(taxonList)

convert2name <- function(taxonList) {
    type <- predictType(taxonList)
    if (type[1] == "ID") {
        nameDf <- id2name(taxonList)
        nameList <- nameDf$fullName
    } else if (type[1] == "NAME") {
        nameList <- taxonList
    } else {
        warning("Input contains probably both taxon IDs and NAMEs!")
        nameDf <- id2name(type[[1]])
        nameList <- c(type[[2]], nameDf$fullName)
    }
    return(nameList)
}