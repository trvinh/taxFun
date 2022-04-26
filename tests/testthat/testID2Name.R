context("test converting IDs to names")

test_that("test ids to names", {
    idList <- c("9606", "5207", "40674", "4751")
    out <- id2name(idList)
    expect_true(nrow(out) == 4)
})