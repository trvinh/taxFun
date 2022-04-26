context("test converting IDs to ranks")

test_that("test ids to ranks", {
    idList <- c("9606", "5207", "40674", "4751")
    out <- id2rank(idList)
    expect_true(nrow(out) == 4)
    expect_true(ncol(out) == 3)
})