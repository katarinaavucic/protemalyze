# Test generateDistanceMatrix
test_that("generateDistanceMatrix handles valid and invalid metrics", {

  embeddingMatrix <- eColiEmbeddingMatrix

  # Check valid metrics
  validMetrics <- c("euclidean", "cosine", "hamming")
  for (metric in validMetrics) {
    distMatrix <- generateDistanceMatrix(embeddingMatrix, metric = metric)
    expect_s3_class(distMatrix, "data.frame")
    expect_equal(nrow(distMatrix), nrow(embeddingMatrix),
                 info = "Distance matrix should have the same number of rows as
                 the embedding matrix")
    expect_equal(ncol(distMatrix), nrow(embeddingMatrix),
                 info = "Distance matrix should have the same number of columns
                 as te embedding matrix")
  }

  # Check invalid metric response is correct
  expect_error(generateDistanceMatrix(embeddingMatrix, metric = "invalid"),
               "Invalid metric:",
               info = "This should throw an error for an invalid metric")
})

# Test generateRankMatrix
test_that("generateRankMatrix computes ranks correctly", {

  distanceMatrix <- generateDistanceMatrix(eColiEmbeddingMatrix)
  rankMatrix <- generateRankMatrix(distanceMatrix)

  # Check the structure of the rank matrix
  expect_s3_class(rankMatrix, "data.frame")
  expect_equal(nrow(rankMatrix), nrow(distanceMatrix),
               info = "Rank matrix should have the same number of rows as the
               distance matrix")
  expect_equal(ncol(rankMatrix), ncol(distanceMatrix),
               info = "Rank matrix should have the same number of columns as the
               distance matrix")

  # Check diagonal is all zeroes (since it's comparing the same protein)
  expect_equal(sum(diag(as.matrix(rankMatrix))), 0, info = "Each value in the diagonal of
               rank matrix should be 0, so sum should also be 0")

  # Check that all ranks are non-negative
  expect_true(all(rankMatrix >= 0), info = "Rank values should be non-negative")
})
