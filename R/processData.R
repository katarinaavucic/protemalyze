#' Process Embedding Matrix
#'
#' A function that removes NULL and duplicate values from a data frame
#' representing an embedding matrix.
#'
#' @param embeddingMatrix A data frame containing an embedding matrix with
#'     identifiers in the index and columns representing embedding dimensions.
#'
#' @return Returns a data frame representing the embedding matrix with no NULL
#'     or duplicate values. Protein identifiers are in the rows and embedding
#'     dimensions in the columns.
#' @examples
#' # Check the original matrix dimensions
#' embeddingMatrix <- eColiEmbeddingMatrix
#' print(dim(embeddingMatrix))
#'
#' # Add NULL values to 100 rows
#' set.seed(42)
#' indices_to_nullify <- sample(nrow(embeddingMatrix), 100)
#' embeddingMatrix[indices_to_nullify, ] <- NA
#'
#' # Process the data
#' processedEmbeddingMatrix <- processData(embeddingMatrix)
#' print(dim(processedEmbeddingMatrix))
#' @export
#' @import dplyr
#' @import tibble
processData <- function(embeddingMatrix){
  processedMatrix <- embeddingMatrix %>%
    removeDuplicates %>%
    stats::na.omit()
  return(processedMatrix)
}

# Remove duplicates from an embedding matrix data frame if there is an index.
removeDuplicates <- function(embeddingMatrix) {
  if (!is.null(rownames(embeddingMatrix))) {
    matrixNoDuplicates <- embeddingMatrix %>%
      tibble::rownames_to_column("rowIndex") %>%
      dplyr::distinct(rowIndex, .keep_all = TRUE) %>%
      tibble::column_to_rownames("rowIndex")
  } else {
    matrixNoDuplicates <- embeddingMatrix
  }
    return(matrixNoDuplicates)
}

# [END]
