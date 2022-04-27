context("test creating tree")

test_that("test create tree for a list of taxa", {
    nameList <- c(
        "Homo sapiens", "fungiblabla", "mammalia", "Cryptococcus neoformans"
    )
    out <- createTree(nameList)
    expect_true(length(out$tip.label) == 3)
    expect_false("fungi" %in% out$tip.label)
})