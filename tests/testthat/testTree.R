context("test creating tree")

test_that("test get tree for a list of taxon names", {
    nameList <- c(
        "Homo sapiens", "fungiblabla", "mammalia", "Cryptococcus neoformans"
    )
    out <- getTree4Name(nameList)
    expect_true(length(out$tip.label) == 3)
    expect_false("fungi" %in% out$tip.label)
})

test_that("test get tree for a list of taxon IDs", {
    idList <- c("9606", "5207", "40674", "4751")
    outgroup <- 5207
    out <- getTree4Id(idList, outgroup)
    expect_true(length(out$tip.label) == 4)
})