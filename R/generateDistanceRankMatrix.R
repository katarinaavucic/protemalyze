# Valid metrics for the parDist function.
validMetrics <- c("bhjattacharyya", "bray", "canberra", "chord",
                  "divergence", "dtw", "euclidean", "fJaccard",
                  "geodesic", "hellinger", "kullback", "mahalanobis",
                  "euclidean", "maximum", "minkowski", "podani",
                  "soergel", "wave", "whittaker", "binary",
                  "braun-blanquet", "dice", "fager", "faith",
                  "hamman", "kulczynski1", "kulczynski2",
                  "michael", "mountford", "mozley", "ochiai",
                  "phi", "russel", "simple matching", "simpson",
                  "stiles", "tanimoto", "yule", "yule2",
                  "cosine", "hamming")

#' Generate Distance Matrix
#'
#' A function that computes a distance matrix for an embedding matrix provided
#' user's choice of distance metric and an embedding matrix derived from a
#' protein Language Model.
#'
#' @param embeddingMatrix A data frame containing an embedding matrix with
#'     identifiers in the index and columns representing embedding dimensions.
#'     It is recommended that you utilize protemalyze::processData to clean the
#'     embedding matrix.
#'
#' @param metric The metric to use for the distance matrix calculation. The
#'     default is "euclidean", alternatives must be one of the ones listed in
#'     the parallelDist::parDist documentation.
#'
#' @param threads The number of cpu threads that will be used for the
#'     calculation. The default is the maximum amount of cpu threads available
#'     on the system.
#'
#' @return Returns a data frame representing the distance matrix calculated from
#'     the embedding matrix. Each value in the distance matrix is the distance
#'     calculated using the specified metric between the row and column
#'     embeddings. The distance matrix contains protein identifies in the row
#'     and columns indices, and the diagonal is all zeroes.
#'
#' @examples
#' # Generate distance matrix with default setings
#' embeddingMatrix <- SARSCoV2EmbeddingMatrix
#' distMatrix <- generateDistanceMatrix(embeddingMatrix)
#'
#' # Generate distance matrix with an alternative metric
#' distMatrix <- generateDistanceMatrix(embeddingMatrix,
#'                                           metric="fJaccard")
#' # Generate distance matrix with a set amount of threads
#' distMatrix <- generateDistanceMatrix(embeddingMatrix,
#'                                            threads=4)
#'
#' @references
#' Eckert A (2023). parallelDist: Parallel Distance Matrix Computation using
#' Multiple Threads. R package version 0.2.6.
#'
#' @export
#' @import parallelDist
generateDistanceMatrix <- function(embeddingMatrix, metric="euclidean",
                                   threads=NULL){

  # Error checking for embeddingMatrix.
  checkMatrix(embeddingMatrix, type="embeddingMatrix")

  # Error if metric is invalid.
  if (metric != "euclidean" && !(metric %in% validMetrics)) {
    stop(paste("Invalid metric:", metric, ". Valid options are:",
               paste(validMetrics, collapse = ", ")))
  }
  else {
    # Execute function code.
  }

  # Convert to matrix, perform optimized distance computation, convert back to
  # data frame for user. When parDist receives threads=NULL (default), it sets
  # the threads to the maximum amount of cpu threads on the system.
  asMatrix <- as.matrix(embeddingMatrix)
  distMatrix <- as.matrix(parallelDist::parDist(asMatrix, method=metric,
                                                threads=threads))

  return(as.data.frame(distMatrix))
}

#' Generate Rank Matrix
#'
#' A function that computes a rank matrix from a distance matrix derived from
#' an embedding matrix that has been generated from a protein Language Model.
#'
#' @param distanceMatrix A data frame representing the distance matrix from
#'     an embedding matrix that has been generated from a protein Language
#'     Model. Each value in the distance matrix is the distance calculated
#'     between the row and column embeddings. The distance matrix should contain
#'     protein identifies in the row and columns indices, with the diagonal all
#'     zeroes.
#'
#' @return Returns a data frame representing the rank matrix calculated from
#'     the distance matrix. Each value in the rank matrix is the rank of the
#'     distance of the column protein compared to all other distances computed
#'     with the row protein. These are not reciprocal values, and the diagonal
#'     (where the row and column protein are the same) is always rank 0. The
#'     rank matrix contains protein identifies in the row and columns indices.
#'
#' @examples
#' # Generate distance matrix with default setings
#' embeddingMatrix <- SARSCoV2EmbeddingMatrix
#' distMatrix <- generateDistanceMatrix(embeddingMatrix)
#'
#' # Generate rank matrix from distance matrix
#' rankMatrix <- generateRankMatrix(distMatrix)
#'
#' @references
#' Bengtsson H (2023). matrixStats: Functions that Apply to Rows and Columns of
#' Matrices (and to Vectors). R package version 1.0.0.
#'
#' @export
#' @importFrom matrixStats rowRanks
generateRankMatrix <- function(distanceMatrix){

  # Error checking for distMatrix.
  checkMatrix(distanceMatrix, type="distanceMatrix")

  # Error if the column names do not exist.
  if (is.null(colnames(distanceMatrix)) || all(colnames(distanceMatrix)
                                                    == "")) {
    stop("Error: The input 'distanceMatrix' must have column names that are not
         empty.")
  }
  else {
    # Execute function code.
  }

  # Convert to matrix, perform optimized ranking computation, convert back to
  # data frame for user.
  asMatrix <- as.matrix(distanceMatrix)
  rankMatrix <- matrixStats::rowRanks(asMatrix, ties.method = "min")

  # Subtract 1 so that the diagonal is rank 0 and closest (not the same) protein
  # has a rank of 1.
  rankMatrix <- as.data.frame(rankMatrix - 1)

  return(rankMatrix)
}

# [END]
