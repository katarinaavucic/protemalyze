#' Process Embedding Matrix
#'
#' A function that removes NULL and duplicate values from a data frame
#' representing an embedding matrix generated from a protein Language Model.
#'
#' @param embeddingMatrix A data frame containing an embedding matrix generated
#'     from a protein Lanugage Model with identifiers in the index and columns
#'     representing embedding dimensions.
#'
#' @return Returns a data frame representing the embedding matrix with no NULL
#'     or duplicate values. Protein identifiers are in the rows and embedding
#'     dimensions in the columns.
#' @examples
#' # Process the embedding matrix
#' embeddingMatrix <- SARSCoV2EmbeddingMatrix
#' processedEmbeddingMatrix <- processData(embeddingMatrix)
#'
#' @references
#' Müller K, Wickham H (2023). tibble: Simple Data Frames. R package version
#' 3.2.1.
#'
#' Wickham H, François R, Henry L, Müller K, Vaughan D (2023). dplyr: A Grammar
#' of Data Manipulation. R package version 1.1.3.
#'
#' @export
#' @import dplyr
#' @import tibble
processData <- function(embeddingMatrix){

  # Error checking for embeddingMatrix. Only general checks are read, since the
  # embedding matrix has not been cleaned yet.
  checkMatrix(embeddingMatrix)

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
