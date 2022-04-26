context("test converting names to ranks")

test_that("test names to ranks", {
    nameList <- c(
        "Homo sapiens", "fungiblabla", "mammalia", "Cryptococcus neoformans"
    )
    out <- name2rank(nameList)
    expect_true(nrow(out) == 3)
    expect_true(ncol(out) == 3)
    expect_false("fungi" %in% out$fullName)
})