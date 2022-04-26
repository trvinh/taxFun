context("test creating sorted taxonomy matrix")

test_that("test create taxnomy matrix for a list of taxon names", {
    nameList <- c(
        "Homo sapiens", "fungiblabla", "mammalia", "Cryptococcus neoformans"
    )
    out <- sortTaxonomyMatrix4Name(nameList, refspec = "mammalia")
    expect_true(nrow(out) == 3)
})

test_that("test create taxnomy matrix for a list of taxon IDs", {
    idList <- c("9606", "5207", "40674", "4751")
    refspec <- 5207
    out <- sortTaxonomyMatrix4Id(idList, refspec)
    expect_true(nrow(out) == 4)
})