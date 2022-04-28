context("test sub-sampling taxa")

test_that("test getting representative taxa", {
    taxonList <- c(
        214684, 246409, 3055, 336722, 3702, 400682, 441375, 45351, 4558, 559292,
        6239, 7227, "Homo sapiens"
    )
    out <- getRepresentative(taxonList, rank = "phylum")
    expect_true(nrow(out) == 11)
    expect_true(ncol(out) == 4)
})

test_that("test getting taxa belong to a clade", {
    taxonList <- c(
        214684, 246409, 3055, 336722, 3702, 400682, 441375, 45351, 4558, 559292,
        6239, 7227, "Homo sapiens"
    )
    out <- getClade(taxonList, supertaxon = 33208)
    expect_true(nrow(out) == 5)
    expect_true(ncol(out) == 2)
})