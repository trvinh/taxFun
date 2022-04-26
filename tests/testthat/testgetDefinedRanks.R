context("test getting names for a list of defined ranks")

test_that("test get rank names for a list of taxon names", {
    nameList <- c(
        "Homo sapiens", "fungiblabla", "mammalia", "Cryptococcus neoformans"
    )
    ranks <- c("family", "class", "phylum", "kingdom")
    out <- getRanks4Name(nameList, ranks)
    expect_true(nrow(out) == 3)
    expect_true(ncol(out) == 6)
    expect_false("fungi" %in% out$name)
})

test_that("test get rank names for a list of taxon IDs", {
    idList <- c("9606", "5207", "40674", "4751")
    ranks <- c("family", "class", "phylum", "kingdom")
    out <- getRanks4Id(idList, ranks)
    expect_true(nrow(out) == 4)
    expect_true(ncol(out) == 6)
})

test_that("test get all rank names for a list of taxon IDs", {
    idList <- c("9606", "5207", "40674", "4751")
    allRanks <- PhyloProfile::mainTaxonomyRank()
    out <- getRanks4Id(idList)
    expect_true(nrow(out) == 4)
    expect_true(ncol(out) == 20)
})