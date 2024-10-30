#' Loads Embedding Matrices From Different File Types
#'
#' A function that loads an embedding matrix given a path
#' from the root folder and file type that is either "csv",
#' tsv", or "h5".
#'
#' @param path A string containing the path to the
#'     embedding matrix from the root folder. The embedding
#'     matrix must have proteins in the rows with the
#'     identifier in the index and embedding dimensions in
#'     the columns.
#'
#' @param fileType A string specifying the file type of the
#'     embedding matrix, must be either "csv", "tsv", or "h5".
#'
#' @return Returns a DataFrame representing the embedding
#'     matrix with proteins in the rows and embedding
#'     dimensions in the columns.
#'
#' @export
#' @importFrom readr read_csv read_tsv
#' @importFrom rhdf5 h5read
#' @import dplyr
loadEmbeddings <- function(path, fileType){
  if (fileType == 'csv') {
    matrix <- readr::read_csv(path)
  }
  else if (fileType == 'tsv') {
    matrix <- readr::read_tsv(path)
  }
  else if (fileType == "h5") {
    data_list <- h5read(path, "/")
    matrix <- data_list %>%
      bind_rows() %>%
      t() %>%
      as.data.frame()
    colnames(matrix) <- paste0("V", seq_len(ncol(matrix)))
  }
  return(matrix)
}

# [END]
