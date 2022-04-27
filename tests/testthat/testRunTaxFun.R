context("test overhead scrip")

test_that("test converting ids to names", {
    out <- taxFun("id2name", "ids.txt")
    expect_true(out == 1)
})

test_that("test get rank names for a list of taxon names", {
    ranks <- c("family", "class", "phylum", "kingdom")
    out <- taxFun("getRanks", "names.txt", ranks = ranks)
    expect_true(out == 1)
})

test_that("test create tree for a list of taxon names", {
    outgroup <- "Mammalia"
    out <- taxFun("createTree", "names.txt", outgroup = outgroup)
    expect_true(out == 1)
})

test_that("test get sorted taxonomy matrix for a list of taxon names", {
    refspec <- "Mammalia"
    out <- taxFun("sortTaxonomyMatrix", "names.txt", refspec = refspec)
    expect_true(out == 1)
})