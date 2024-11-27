#' Check Errors in Different Types of Matrices
#'
#' A function that checks the validity of different matrix types
#' (`embeddingMatrix`, `distanceMatrix`, `rankMatrix`). It performs general
#' checks for all matrix types and specific checks based on the matrix type.
#'
#' @param matrix A data frame or matrix containing the matrix to be validated.
#'
#' @param type A string representing the type of the matrix. The deafault is
#'    NULL to perform general matrix checks. For additional checks, set type to
#'    \code{"embeddingMatrix"}, \code{"distanceMatrix"}, or \code{"rankMatrix"}.
#'    This determines which specific checks are applied.
#'
#' @return Returns `TRUE` if all checks pass. If any check fails, an error is
#'    thrown with a relevant error message indicating the issue (e.g., invalid
#'    matrix type, non-numeric values, etc.).
#'
#' @details This function performs the following checks:
#'
#' \itemize{
#'   \item \strong{General Checks} (for all matrices):
#'     \itemize{
#'        \item Verifies that the input is a data frame or matrix.
#'        \item Ensures that the matrix is not empty and contains numeric
#'        values.
#'        \item Checks that the row names of the matrix are non-empty.
#'     }
#'
#'   \item \strong{Checks for `embeddingMatrix`}:
#'     \itemize{
#'        \item Ensures the matrix has no NA values.
#'     }
#'
#'   \item \strong{Checks for `distanceMatrix`}:
#'     \itemize{
#'        \item Verifies the matrix is symmetric.
#'        \item Ensures the matrix has non-empty column names.
#'        \item Verifies that row names and column names are identical.
#'        \item Ensures there are no NA values.
#'.    }
#'
#'   \item \strong{Checks for `rankMatrix`}:
#'     \itemize{
#'        \item Verifies the matrix is symmetric.
#'        \item Ensures the matrix has non-empty column names.
#'        \item Verifies that row names and column names are identical.
#'        \item Ensures there are no NA values.
#'        \item Ensures all values are non-negative integers (valid ranks).
#'     }
#' }
#'
#' @examples
#' \dontrun{
#' # Example of valid embeddingMatrix
#' checkMatrix(embeddingMatrix, type = "embeddingMatrix")
#'
#' # Example of valid distanceMatrix
#' checkMatrix(distanceMatrix, type = "distanceMatrix")
#'
#' # Example of valid rankMatrix
#' try(checkMatrix(rankMatrix, type = "rankMatrix"))
#' }
#'
#' @export
checkMatrix <- function(matrix, type=NULL) {
  # Error if the input is not a data frame.
  if (!is.data.frame(matrix)) {
    stop("Error: The input matrix must be a data frame.")
  }

  # Error if the data frame is empty.
  if (nrow(matrix) == 0 || ncol(matrix) == 0) {
    stop("Error: The input matrix is empty. It must have at least one
         row and one column.")
  }

  # Error if the row names do not exist.
  if (is.null(rownames(matrix)) || all(rownames(matrix) == "")) {
    stop("Error: The input matrix must have row names that are not
         empty.")
  }


  # Specific checks based on matrix type.
  # If no type, only general checks are applied.
  if (is.null(type)){
    # Do nothing.
  }
  else if (type == "embeddingMatrix") {
    # Error if there are NA values in the embedding matrix.
    if (any(is.na(matrix))) {
      stop("Error: The 'embeddingMatrix' contains NA values. Please use
           processData before creating the distance matrix.")
    }
    # Error if any value in the data frame is not numeric.
    if (any(!sapply(matrix, is.numeric))) {
      stop("Error: All values in matrix must be numeric.")
    }
  }
  else if (type == "distanceMatrix") {
    # Error if the column names do not exist.
    if (is.null(colnames(matrix)) || all(colnames(matrix) == "")) {
      stop("Error: The input 'distanceMatrix' must have column names that are
           not empty.")
    }
    # Error if the row names and column names are not identical.
    if (!identical(rownames(matrix), colnames(matrix))) {
      stop("Error: For an 'distanceMatrix', row names must be identical to
           column names.")
    }
    # Error if there are NA values in the distance matrix.
    if (any(is.na(matrix))) {
      stop("Error: The 'distanceMatrix' contains NA values. Please use
           processData before creating the distance matrix.")
    }
    # Error if any value in the data frame is not numeric.
    if (any(!sapply(matrix, is.numeric))) {
      stop("Error: All values in matrix must be numeric.")
    }
  }
  else if (type == "rankMatrix") {
    # Error if the column names do not exist.
    if (is.null(colnames(matrix)) || all(colnames(matrix) == "")) {
      stop("Error: The input 'rankMatrix' must have column names that are
           not empty.")
    }
    # Error if the row names and column names are not identical.
    if (!identical(rownames(matrix), colnames(matrix))) {
      stop("Error: For an 'rankMatrix', row names must be identical to
           column names.")
    }
    # Error if NA values in the rank matrix.
    if (any(is.na(matrix))) {
      stop("Error: The 'rankMatrix' contains NA values. Please use
           processData before creating the distance matrix.")
    }
    # Error if there are negative values (ranks cannot be negative).
    if (any(matrix < 0 | matrix != floor(matrix))) {
      stop("Error: For a 'rankMatrix', all values must be non-negative
           integers.")
    }
    # Error if any value in the data frame is not numeric.
    if (any(!sapply(matrix, is.numeric))) {
      stop("Error: All values in matrix must be numeric.")
    }
  }
  else {
    # Do nothing.
  }

  # If all checks pass, return TRUE
  return(TRUE)
}

# [END]
