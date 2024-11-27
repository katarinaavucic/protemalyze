#' Get Closest Pairs in a Rank Matrix
#'
#' A function that generates a data frame containing the closest pairs for each
#'     protein in a rank matrix that has been derived from embeddings from
#'     a protein Language Model.
#'
#' @param rankMatrix A data frame representing the rank matrix calculated from
#'     a distance matrix. The distance matrix is a data frame computed from
#'     an embedding matrix that has been generated from a protein Language
#'     Model. Each value in the rank matrix is the rank of the
#'     distance of the column protein compared to all other distances computed
#'     with the row protein. These are not reciprocal values, and the diagonal
#'     (where the row and column protein are the same) is always rank 0. The
#'     rank matrix contains protein identifies in the row and columns indices.
#'
#' @return Returns a data frame containing the protein with the closest rank for
#'     each protein.
#'
#' @examples
#' # Generate distance matrix with default setings
#' embeddingMatrix <- SARSCoV2EmbeddingMatrix
#' distMatrix <- generateDistanceMatrix(embeddingMatrix)
#'
#' # Generate rank matrix from distance matrix
#' rankMatrix <- generateRankMatrix(distMatrix)
#'
#' # Generate closest pairs matrix
#' closestPairsMatrix <- getClosestPairs(rankMatrix)
#'
#' @export
getClosestPairs <- function(rankMatrix){

  # Error checking for rankMatrix.
  checkMatrix(rankMatrix, type="rankMatrix")

  # Convert to matrix, perform computation, convert back to data frame for user.
  asMatrix <- as.matrix(rankMatrix)

  # The closest protein is at rank 1, since rank 0 is itself.
  closestPairs <- which(asMatrix == 1, arr.ind = TRUE)

  # Combine into 1 data frame, using the protein identifiers specified by the
  # closest pair indices.
  closestPairsMatrix <- data.frame(
    Protein = rownames(asMatrix)[closestPairs[ , 1]],
    ClosestProtein = colnames(asMatrix)[closestPairs[ , 2]]
  )

  return(closestPairsMatrix)
}

#' Get Farthest Pairs in a Rank Matrix
#'
#' A function that generates a data frame containing the farthest pairs for each
#'     protein in a rank matrix that has been derived from embeddings from
#'     a protein Language Model.
#'
#' @param rankMatrix A data frame representing the rank matrix calculated from
#'     a distance matrix. The distance matrix is a data frame computed from
#'     an embedding matrix that has been generated from a protein Language
#'     Model. Each value in the rank matrix is the rank of the
#'     distance of the column protein compared to all other distances computed
#'     with the row protein. These are not reciprocal values, and the diagonal
#'     (where the row and column protein are the same) is always rank 0. The
#'     rank matrix contains protein identifies in the row and columns indices.
#'
#' @return Returns a data frame containing the protein with the farthest rank
#'     for each protein.
#'
#' @examples
#' # Generate distance matrix with default setings
#' embeddingMatrix <- SARSCoV2EmbeddingMatrix
#' distMatrix <- generateDistanceMatrix(embeddingMatrix)
#'
#' # Generate rank matrix from distance matrix
#' rankMatrix <- generateRankMatrix(distMatrix)
#'
#' # Generate farthest pairs matrix
#' farthestPairsMatrix <- getFarthestPairs(rankMatrix)
#'
#' @export
getFarthestPairs <- function(rankMatrix){

  # Error checking for rankMatrix.
  checkMatrix(rankMatrix, type="rankMatrix")

  # Convert to matrix, perform computation, convert back to data frame for user.
  asMatrix <- as.matrix(rankMatrix)

  # The farthest protein is at the number of rows minus one, since we subtract
  # one to zero out the diagonal.
  farthestPairs <- which(asMatrix == (nrow(asMatrix) - 1), arr.ind = TRUE)

  # Combine into 1 data frame, using the protein identifiers specified by the
  # closest pair indices
  farthestPairsMatrix <- data.frame(
    Protein = rownames(asMatrix)[farthestPairs[ , 1]],
    FarthestProtein = colnames(asMatrix)[farthestPairs[ , 2]]
  )

  return(farthestPairsMatrix)
}
# [END]
