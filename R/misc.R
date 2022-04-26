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
        print("Loading NCBI taxonomy file...")
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
#' \dontrun{
#' ll <- c("one", "tWO", "Three")
#' firstup(ll)
#' }

firstup <- function(x) {
    substr(x, 1, 1) <- toupper(substr(x, 1, 1))
    x
}

