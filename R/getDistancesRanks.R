#' Get Distances For Mapped Pairs in a Distance Matrix
#'
#' A function that generates a data frame containing the distances for specified
#'     pairs using a mapping.
#'
#' @param distanceMatrix A data frame representing the distance matrix from
#'     an embedding matrix. Each value in the distance matrix is the distance
#'     calculated between the row and column embeddings. The distance matrix
#'     should contain protein identifies in the row and columns indices, with
#'     the diagonal all zeroes.
#'
#' @param mapping A data frame with two columns of protein identifiers matching
#'     the identifiers used for the embedding matrix.
#'
#' @return Returns a data frame containing the proteins in the matching and
#'     their associated distances from the distance matrix.
#'
#' @examples
#' \dontrun{
#' # Generate distance matrix with default setings
#' embeddingMatrix <- eColiEmbeddingMatrix
#' eColiDistMatrix <- generateDistanceMatrix(embeddingMatrix)
#'
#' # Retrieve distances by mapping
#' mapping <- eColiParalogMapping
#' eColiParalogDistances <- getDistancesByMapping(eColiDistMatrix, mapping)
#' }
#'
#' @export
getDistancesByMapping <- function(distanceMatrix, mapping){

  # Error checking for distMatrix.
  checkMatrix(distanceMatrix, type="distanceMatrix")

  # Convert to matrix, perform computation, convert back to data frame for user.
  asMatrix <- as.matrix(distanceMatrix)

  # Convert mapping to character vectors for faster indexing.
  protein1 <- as.character(mapping[[1]])
  protein2 <- as.character(mapping[[2]])

  # Locate protein indexes.
  protein1Index <- match(protein1, rownames(distanceMatrix))
  protein2Index <- match(protein2, colnames(distanceMatrix))

  # Get distances for (protein1Index, protein2Index) pairs.
  distances <- distanceMatrix[cbind(protein1Index, protein2Index)]

  distancesByMapping <- data.frame(
    Protein1 = protein1,
    Protein2 = protein2,
    Distance = distances
  )

  # Remove NA results (pairs not found in distanceMatrix).
  distancesByMapping <-
    distancesByMapping[!is.na(distancesByMapping$Distance), ]

  return(distancesByMapping)
}


#' Get Ranks For Mapped Pairs in a Rank Matrix
#'
#' A function that generates a data frame containing the ranks for specified
#'     pairs using a mapping.
#'
#' @param rankMatrix A data frame representing the rank matrix calculated from
#'     an embedding matrix. Each value in the rank matrix is the rank of the
#'     distance of the column protein compared to all other distances computed
#'     with the row protein. These are not reciprocal values, and the diagonal
#'     (where the row and column protein are the same) is always rank 0. The
#'     rank matrix contains protein identifies in the row and columns indices.
#'
#' @param mapping A data frame with two columns of protein identifiers matching
#'     the identifiers used for the embedding matrix.
#'
#' @return Returns a data frame containing the proteins in the matching and
#'     their associated rank from the rank matrix.
#'
#' @examples
#' \dontrun{
#' # Generate distance matrix with default setings
#' embeddingMatrix <- eColiEmbeddingMatrix
#' eColiDistMatrix <- generateDistanceMatrix(embeddingMatrix)
#'
#' # Generate rank matrix from distance matrix
#' eColiRankMatrix <- generateRankMatrix(eColiDistMatrix)
#'
#' # Retrieve ranks by mapping
#' mapping <- eColiParalogMapping
#' eColiParalogRanks <- getRanksByMapping(eColiRankMatrix, mapping)
#' }
#'
#' @export
getRanksByMapping <- function(rankMatrix, mapping){

  # Error checking for rankMatrix.
  checkMatrix(rankMatrix, type="rankMatrix")

  # Convert to matrix, perform computation, convert back to data frame for user.
  asMatrix <- as.matrix(rankMatrix)

  # Convert mapping to character vectors for faster indexing.
  protein1 <- as.character(mapping[[1]])
  protein2 <- as.character(mapping[[2]])

  # Locate protein indexes.
  protein1Index <- match(protein1, rownames(rankMatrix))
  protein2Index <- match(protein2, colnames(rankMatrix))

  # Get ranks for (protein1Index, protein2Index) pairs.
  ranks <- rankMatrix[cbind(protein1Index, protein2Index)]

  ranksByMapping <- data.frame(
    Protein1 = protein1,
    Protein2 = protein2,
    Rank = ranks
  )

  # Remove NA results (pairs not found in rankMatrix).
  ranksByMapping <- ranksByMapping[!is.na(ranksByMapping$Rank), ]

  return(ranksByMapping)
}

# [END]
