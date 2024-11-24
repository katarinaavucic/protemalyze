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

  # Error if the input is not a data frame.
  if (!is.data.frame(embeddingMatrix)) {
    stop("Error: The input 'embeddingMatrix' must be a data frame.")
  }
  # Error if the data frame is empty.
  else if (nrow(embeddingMatrix) == 0 || ncol(embeddingMatrix) == 0) {
    stop("Error: The input 'embeddingMatrix' is empty. It must have at least one
         row and one column.")
  }
  # Error if the row names do not exist.
  else if (is.null(rownames(embeddingMatrix)) || all(rownames(embeddingMatrix)
                                                     == "")) {
    stop("Error: The input 'embeddingMatrix' must have row names that are not
         empty.")
  }
  # Error if any value in the data frame is not numeric.
  else if (any(!sapply(embeddingMatrix, is.numeric))) {
    stop("Error: All values in 'embeddingMatrix' must be numeric.")
  }
  else {
    # Execute function code.
  }

  # Remove duplicate rownames and NULLs.
  processedMatrix <- embeddingMatrix %>%
    removeDuplicates %>%
    stats::na.omit()

  return(processedMatrix)
}

#' Remove Duplicates From An Embedding Matrix
#'
#' A function that removes duplicate values from a data frame
#' representing an embedding matrix if there are row names and column names
#' present.
#'
#' @param embeddingMatrix A data frame containing an embedding matrix with
#'     identifiers in the index and columns representing embedding dimensions.
#'
#' @return Returns a data frame representing the embedding matrix with no
#'     duplicate values. Protein identifiers are in the rows and embedding
#'     dimensions in the columns.
#'
#' @noRd
#' @import dplyr
#' @import tibble
removeDuplicates <- function(embeddingMatrix) {

    # Remove duplicates from the rows.
    matrixNoDuplicates <- embeddingMatrix %>%
      tibble::rownames_to_column("rowIndex") %>%
      dplyr::distinct(rowIndex, .keep_all = TRUE) %>%
      tibble::column_to_rownames("rowIndex")

  return(matrixNoDuplicates)
}

# [END]
