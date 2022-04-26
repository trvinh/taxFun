context("test converting names to IDss")

test_that("test names to ids", {
    nameList <- c(
        "Homo sapiens", "fungiblabla", "mammalia", "Cryptococcus neoformans"
    )
    out <- name2id(nameList)
    expect_true(nrow(out) == 3)
    expect_false("fungi" %in% out$fullName)
})