# Test getDistancesByMapping
test_that("getDistancesByMapping generates a data frame with correct format", {

  distMatrix <- generateDistanceMatrix(eColiEmbeddingMatrix)
  mapping <- eColiParalogMapping
  distancesByMapping <- getDistancesByMapping(distMatrix, mapping)

  # Check size of resulting data frame
  expect_equal(nrow(distancesByMapping), nrow(mapping),
               info = "Distances matrix should have same rows as mapping")
  expect_equal(ncol(distancesByMapping), 3,
               info = "Distances matrix should have 3 columns: Protein1,
               Protein2, Distance")

  # Check columns of resulting data frame
  expect_true(all(c("Protein1", "Protein2", "Distance") %in%
                    colnames(distancesByMapping)),
              info = "Data frame should contain Protein1, Protein2, and
              Distance columns")
})

# Test getRanksByMapping
test_that("getRanksByMapping generates a data frame with correct format", {

  distMatrix <- generateDistanceMatrix(eColiEmbeddingMatrix)
  rankMatrix <- generateRankMatrix(distMatrix)
  mapping <- eColiParalogMapping
  ranksByMapping <- getRanksByMapping(rankMatrix, mapping)

  # Check size of resulting data frame
  expect_equal(nrow(ranksByMapping), nrow(mapping),
               info = "Distances matrix should have same rows as mapping")
  expect_equal(ncol(ranksByMapping), 3,
               info = "Distances matrix should have 3 columns: Protein1,
               Protein2, Distance")

  # Check columns of resulting data frame
  expect_true(all(c("Protein1", "Protein2", "Rank") %in%
                    colnames(ranksByMapping)),
              info = "Data frame should contain Protein1, Protein2, and Rank
              columns")
})

