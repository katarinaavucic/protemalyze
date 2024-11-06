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
#' \dontrun{
#' # Process the embedding matrix
#' embeddingMatrix <- eColiEmbeddingMatrix
#' processedEmbeddingMatrix <- processData(embeddingMatrix)
#' }
#'
#' @export
#' @import dplyr
#' @import tibble
processData <- function(embeddingMatrix){

  # Remove duplicate rownames and NULL.
  processedMatrix <- embeddingMatrix %>%
    removeDuplicates %>%
    stats::na.omit()

  return(processedMatrix)
}

# Remove duplicates from an embedding matrix data frame if there is an index.
removeDuplicates <- function(embeddingMatrix) {

  # If the matrix has rownames, remove duplicates.
  if (!is.null(rownames(embeddingMatrix))) {
    # Remove duplicates from the rows.
    matrixNoDuplicates <- embeddingMatrix %>%
      tibble::rownames_to_column("rowIndex") %>%
      dplyr::distinct(rowIndex, .keep_all = TRUE) %>%
      tibble::column_to_rownames("rowIndex")
  }
  # Otherwise, send an error.
  else {
    stop("Invalid matrix format: Rownames required for the embedding matrix.")
  }

  return(matrixNoDuplicates)
}

# [END]
