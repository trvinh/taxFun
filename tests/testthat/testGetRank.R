context("test converting taxon IDs or names to ranks")

test_that("test ids to ranks", {
    taxa <- c("Homo sapiens", "5207blabla", "40674", "4751")
    out <- getRank(taxa)
    expect_true(nrow(out) == 3)
    expect_true(ncol(out) == 3)
})
