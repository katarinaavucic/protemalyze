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

  embeddingMatrix2 <- SARSCoV2EmbeddingMatrix

  # Check thread input produces correct matrix
  distMatrix2 <- generateDistanceMatrix(embeddingMatrix2, threads = 2)
  expect_s3_class(distMatrix, "data.frame")
  expect_equal(nrow(distMatrix2), nrow(embeddingMatrix2),
               info = "Distance matrix should have the same number of rows as
               the embedding matrix")
  expect_equal(ncol(distMatrix2), nrow(embeddingMatrix2),
               info = "Distance matrix should have the same number of columns
               as te embedding matrix")

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
  expect_equal(sum(diag(as.matrix(rankMatrix))), 0, info = "Each value in the
               diagonal of rank matrix should be 0, so sum should also be 0")

  # Check that all ranks are non-negative
  expect_true(all(rankMatrix >= 0), info = "Rank values should be non-negative")
})


# Test generateDistanceMatrix function
test_that("generateDistanceMatrix handles invalid embeddingMatrix correctly", {

  embeddingMatrix <- eColiEmbeddingMatrix

  # Add NULL (NA) values to 100 rows
  indices <- sample(nrow(embeddingMatrix), 100)
  embeddingMatrix[indices, ] <- NA

  # Check invalid metric response is correct
  expect_error(generateDistanceMatrix(embeddingMatrix),
               info = "This should throw an error for NAs in embeddingMatrix")
})


# Test generateDistanceMatrix function
test_that("generateRankMatrix handles invalid embeddingMatrix correctly", {

  embeddingMatrix <- eColiEmbeddingMatrix
  distanceMatrix <- generateDistanceMatrix(embeddingMatrix)

  # Add NULL (NA) values to 100 rows
  indices <- sample(nrow(distanceMatrix), 100)
  distanceMatrix[indices, ] <- NA

  # Check invalid metric response is correct
  expect_error(generateRankMatrix(distanceMatrix),
               info = "This should throw an error for NAs in distanceMatrix")
})
