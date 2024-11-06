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
