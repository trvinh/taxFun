context("test creating sorted taxonomy matrix")

test_that("test create taxnomy matrix for a list of taxon names", {
    nameList <- c(
        9606, "fungiblabla", "mammalia", "Cryptococcus neoformans"
    )
    out <- sortTaxonomyMatrix(nameList, refspec = "mammalia")
    expect_true(nrow(out) == 3)
})