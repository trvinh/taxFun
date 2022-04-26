context("test overhead scrip")

test_that("test converting ids to names", {
    out <- taxFun("id2name", "ids.txt")
    expect_true(out == 1)
})

test_that("test get rank names for a list of taxon names", {
    ranks <- c("family", "class", "phylum", "kingdom")
    out <- taxFun("getRanks4Name", "names.txt", ranks = ranks)
    expect_true(out == 1)
})
