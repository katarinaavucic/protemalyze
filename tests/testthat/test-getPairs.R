# Test getFarthestPairs
test_that("getFarthestPairs generates a matrix with the correct size", {

  embeddingMatrix <- eColiEmbeddingMatrix
  distMatrix <- generateDistanceMatrix(embeddingMatrix)
  rankMatrix <- generateRankMatrix(distMatrix)
  farthestPairsMatrix <- getFarthestPairs(rankMatrix)

  # Check the size of the farthest pairs matrix
  expect_equal(nrow(farthestPairsMatrix), nrow(embeddingMatrix),
               info = "Matrix should have the same rows as embedding matrix")
  expect_equal(nrow(farthestPairsMatrix), nrow(distMatrix),
               info = "Matrix should have the same rows as distance matrix")
  expect_equal(nrow(farthestPairsMatrix), nrow(rankMatrix),
               info = "Matrix should have the same rows as rank matrix")
  expect_equal(ncol(farthestPairsMatrix), 2,
               info = "Matrix should have 2 columns")
})

# Test getClosestPairs
test_that("getClosestPairs generates a matrix with the correct size", {

  embeddingMatrix <- SARSCoV2EmbeddingMatrix
  distMatrix <- generateDistanceMatrix(embeddingMatrix)
  rankMatrix <- generateRankMatrix(distMatrix)
  farthestPairsMatrix <- getFarthestPairs(rankMatrix)

  # Check the size of the farthest pairs matrix
  expect_equal(nrow(farthestPairsMatrix), nrow(embeddingMatrix),
               info = "Matrix should have the same rows as embedding matrix")
  expect_equal(nrow(farthestPairsMatrix), nrow(distMatrix),
               info = "Matrix should have the same rows as distance matrix")
  expect_equal(nrow(farthestPairsMatrix), nrow(rankMatrix),
               info = "Matrix should have the same rows as rank matrix")
  expect_equal(ncol(farthestPairsMatrix), 2,
               info = "Matrix should have 2 columns")
})


# Test getFarthestPairs function
test_that("getFarthestPairs handles invalid rankMatrix correctly", {

  embeddingMatrix <- eColiEmbeddingMatrix
  distanceMatrix <- generateDistanceMatrix(embeddingMatrix)
  rankMatrix <- generateRankMatrix(distanceMatrix)

  # Add negative values to 100 rows
  indices <- sample(nrow(rankMatrix), 100)
  rankMatrix[indices, ] <- -100

  # Check invalid metric response is correct
  expect_error(getFarthestPairs(rankMatrix),
               info = "This should throw an error for negatives in rankMatrix")
})


# Test getClosestPairs function
test_that("getClosestPairs handles invalid rankMatrix correctly", {

  embeddingMatrix <- eColiEmbeddingMatrix
  distanceMatrix <- generateDistanceMatrix(embeddingMatrix)
  rankMatrix <- generateRankMatrix(distanceMatrix)

  # Add NA values to 100 rows
  indices <- sample(nrow(rankMatrix), 100)
  rankMatrix[indices, ] <- NA

  # Check invalid metric response is correct
  expect_error(getClosestPairs(rankMatrix),
               info = "This should throw an error for NAs in rankMatrix")
})
