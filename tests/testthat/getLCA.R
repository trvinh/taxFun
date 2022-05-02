context("test getting LCA for a list of taxa")

test_that("test get LCA for a list of taxa", {
    taxa <- c(
        9606, "fungiblabla", "Mus musculus", "Bos taurus"
    )
    out <- getLCA(taxa)
    expect_true(nrow(out) == 1)
    expect_true(ncol(out) == 2)
})
