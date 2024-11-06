# Test processData function
test_that("processData handles NA values correctly", {

  embeddingMatrix <- eColiEmbeddingMatrix

  # Add NULL (NA) values to 100 rows
  indices <- sample(nrow(embeddingMatrix), 100)
  embeddingMatrix[indices, ] <- NA

  processedEmbeddingMatrix <- processData(embeddingMatrix)

  # Check there are 100 fewer rows after processing
  expect_equal(nrow(processedEmbeddingMatrix) + 100, nrow(embeddingMatrix),
              info = "Number of rows in processed matrix should be 100 less than
              the original matrix")
})
