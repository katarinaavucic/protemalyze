#' Loads Embedding Matrices From Different File Types
#'
#' A function that loads an embedding matrix generated using a protein Language
#'     Model given a path from the root folder and file type that is either
#'     "csv", "tsv", or "h5".
#'
#' @param path A string containing the path to the embedding matrix generated
#'     from a protein Language Model from the root folder. The embedding matrix
#'     must have proteins in the rows with the identifier in the index and
#'     embedding dimensions in the columns. If stored in an h5 file, this
#'     function assumes each row is a dataset under the root path.
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
#' @references
#' Fischer B, Smith M, Pau G (2023). rhdf5: R Interface to HDF5. R package
#' version 2.44.0.
#'
#' Wickham H, Hester J, Bryan J (2023). readr: Read Rectangular Text Data. R
#' package version 2.1.4.
#'
#' @export
#' @importFrom readr read_csv read_tsv
#' @importFrom rhdf5 h5read
#' @import dplyr
loadEmbeddings <- function(path, fileType){

  # Error if the provided path is valid.
  if (!file.exists(path)) {
    stop("Error: file does not exist: ", path)
  }

  # Read from csv.
  if (fileType == 'csv') {
    matrix <- readr::read_csv(path)
    # Set rownames to the first column.
    matrix <- as.data.frame(matrix)
    rownames(matrix) <- matrix[[1]]
    matrix <- matrix[, -1]
  }
  # Read from tsv.
  else if (fileType == 'tsv') {
    matrix <- readr::read_tsv(path)
    # Set rownames to the first column.
    matrix <- as.data.frame(matrix)
    rownames(matrix) <- matrix[[1]]
    matrix <- matrix[, -1]
  }
  # Read from h5 file.
  else if (fileType == "h5") {
    # Load each dataset as a seperate row and transpose them to maintain shape.
    # Referenced https://www.bioconductor.org/packages/devel/bioc/vignettes/
    # rhdf5/inst/doc/rhdf5.html#high-level-r-hdf5-functions
    data_list <- h5read(path, "/")
    matrix <- data_list %>%
      bind_rows() %>%
      t() %>%
      as.data.frame()
    colnames(matrix) <- paste0("V", seq_len(ncol(matrix)))
  }
  # Error if fileType is not one of the options.
  else {
    stop("Error: The input 'fileType' specifies an invalid file type. Valid
         options are: csv, tsv, and h5.")
  }

  return(matrix)
}

# [END]
