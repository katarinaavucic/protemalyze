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

# Test getDistancesByMapping function
test_that("getDistancesByMapping handles invalid distanceMatrix correctly", {

  distMatrix <- generateDistanceMatrix(SARSCoV2EmbeddingMatrix)
  mapping <- SARSCoV2Mapping

  # Add NULL (NA) values to 10 rows
  indices <- sample(nrow(distMatrix), 10)
  distMatrix[indices, ] <- NA

  # Check invalid metric response is correct
  expect_error(getDistancesByMapping(distMatrix, mapping),
               info = "This should throw an error for NAs in embeddingMatrix")
})


# Test generateRankMatrix function
test_that("generateRankMatrix handles invalid embeddingMatrix correctly", {

  distMatrix <- generateDistanceMatrix(SARSCoV2EmbeddingMatrix)
  rankMatrix <- generateRankMatrix(distMatrix)
  mapping <- SARSCoV2Mapping

  # Add NULL (NA) values to 10 rows
  indices <- sample(nrow(rankMatrix), 10)
  rankMatrix[indices, ] <- -10

  # Check invalid metric response is correct
  expect_error(generateRankMatrix(rankMatrix, mapping),
               info = "This should throw an error for negatives in rankMatrix")
})
