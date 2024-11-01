#' Get Closest Pairs in a Rank Matrix
#'
#' A function that generates a data frame containing the closest pairs for each
#'     protein in a ranked matrix.
#'
#' @param rankMatrix A data frame representing the rank matrix calculated from
#'     an embedding matrix. Each value in the rank matrix is the rank of the
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
#' eColiDistMatrix <- generateDistanceMatrix(eColiEmbeddingMatrix)
#'
#' # Generate rank matrix from distance matrix
#' eColiRankMatrix <- generateRankMatrix(eColiDistMatrix)
#'
#' # Generate closest pairs matrix
#' eColiClosestPairsMatrix <- getClosestPairs(eColiRankMatrix)
#'
#' @export
getClosestPairs <- function(rankMatrix){
  asMatrix <- as.matrix(rankMatrix)

  # The closest protein is at rank 1, since rank 0 is itself.
  closestPairs <- which(rankMatrix == 1, arr.ind = TRUE)

  # Combine into 1 data frame, using the protein identifiers specified by the
  # closest pair indices.
  closestPairsMatrix <- data.frame(
    Protein = rownames(rankMatrix)[closestPairs[, 1]],
    ClosestProtein = colnames(rankMatrix)[closestPairs[, 2]]
  )

  return(closestPairsMatrix)
}

#' Get Farthest Pairs in a Rank Matrix
#'
#' A function that generates a data frame containing the farthest pairs for each
#'     protein in a ranked matrix.
#'
#' @param rankMatrix A data frame representing the rank matrix calculated from
#'     an embedding matrix. Each value in the rank matrix is the rank of the
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
#' eColiDistMatrix <- generateDistanceMatrix(eColiEmbeddingMatrix)
#'
#' # Generate rank matrix from distance matrix
#' eColiRankMatrix <- generateRankMatrix(eColiDistMatrix)
#'
#' # Generate farthest pairs matrix
#' eColiFarthestPairsMatrix <- getFarthestPairs(eColiRankMatrix)
#'
#' @export
getFarthestPairs <- function(rankMatrix){
  asMatrix <- as.matrix(rankMatrix)

  # The farthest protein is at the number of rows minus one, since we subtract
  # one to zero out the diagonal.
  farthestPairs <- which(rankMatrix == (nrow(rankMatrix) - 1), arr.ind = TRUE)

  # Combine into 1 data frame, using the protein identifiers specified by the
  # closest pair indices
  farthestPairsMatrix <- data.frame(
    Protein = rownames(rankMatrix)[farthestPairs[, 1]],
    FarthestProtein = colnames(rankMatrix)[farthestPairs[, 2]]
  )

  return(farthestPairsMatrix)
}
# [END]
