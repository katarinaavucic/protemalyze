#' Loads Embedding Matrices From Different File Types
#'
#' A function that loads an embedding matrix given a path from the root folder
#' and file type that is either "csv", tsv", or "h5".
#'
#' @param path A string containing the path to the embedding matrix from the
#'     root folder. The embedding matrix must have proteins in the rows with the
#'     identifier in the index and embedding dimensions in the columns. If
#'     stored in an h5 file, this function assumes each row is a dataset under
#'     the root path.
#'
#' @param fileType A string specifying the file type of the embedding matrix,
#'     must be either "csv", "tsv", or "h5".
#'
#' @return Returns a data frame representing the embedding matrix with proteins
#'     in the rows and embedding dimensions in the columns.
#' @examples
#' \dontrun{
#'  loadEmbeddings("path/to/file.csv", "csv")
#'  loadEmbeddings("path/to/file.tsv", "tsv")
#'  loadEmbeddings("path/to/file.h5", "h5")
#' }
#'
#' @export
#' @importFrom readr read_csv read_tsv
#' @importFrom rhdf5 h5read
#' @import dplyr
loadEmbeddings <- function(path, fileType){

  # Read from csv.
  if (fileType == 'csv') {
    matrix <- readr::read_csv(path)
  }
  # Read from tsv.
  else if (fileType == 'tsv') {
    matrix <- readr::read_tsv(path)
  }
  # Read from h5 file.
  else if (fileType == "h5") {
    # Load each dataset as a seperate row and transpose them to maintain shape.
    data_list <- h5read(path, "/")
    matrix <- data_list %>%
      bind_rows() %>%
      t() %>%
      as.data.frame()
    colnames(matrix) <- paste0("V", seq_len(ncol(matrix)))
  }
  # Otherwise, send an error.
  else {
    stop("Invalid file type: Valid options are: csv, tsv, and h5.")
  }
  return(matrix)
}

# [END]
