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
#' A function that compute a distance matrix for an embedding matrix.
#'
#' @param embeddingMatrix A data frame containing an embedding matrix with
#'     identifiers in the index and columns representing embedding dimensions.
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
#' eColiDistMatrix <- generateDistanceMatrix(eColiEmbeddingMatrix)
#'
#' # Generate distance matrix with an alternative metric
#' eColiDistMatrix <- generateDistanceMatrix(eColiEmbeddingMatrix,
#'                                           metric="fJaccard")
#' \dontrun{
#' # Generate distance matrix with a set amount of threads
#' eColiDistMatrix <- generateDistanceMatrix(eColiEmbeddingMatrix,
#'                                            threads=4)
#' }
#'
#' @export
#' @import parallelDist
generateDistanceMatrix <- function(embeddingMatrix, metric="euclidean",
                                   threads=NULL){

  if (metric != "euclidean" && !(metric %in% validMetrics)) {
    stop(paste("Invalid metric:", metric, ". Valid options are:",
               paste(validMetrics, collapse = ", ")))
  } else {
    # do nothing
  }

  asMatrix <- as.matrix(embeddingMatrix)
  distMatrix <- as.matrix(parallelDist::parDist(asMatrix, method=metric,
                                                threads=threads))
  return(as.data.frame(distMatrix))
}


# [END]
