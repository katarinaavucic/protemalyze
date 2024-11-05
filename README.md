
<!-- README.md is generated from README.Rmd. Please edit that file -->

# protemalyze

<!-- badges: start -->
<!-- badges: end -->

## Description

*protemalyze* is an R package designed to analyze protein embeddings
derived from protein Language Models (pLMs). Protein embeddings are
numerical representations of protein sequences, where each protein is
mapped to a fixed-length vector in a high-dimensional space (Chandra et
al., 2023). pLMs have been shown to capture essential information about
protein sequences, and predictive models trained with protein embeddings
often perform comparably to other encoding methods, despite having fewer
dimensions (Yang et al., 2018). These embeddings are particularly useful
for downstream tasks, such as identifying structurally or functionally
similar proteins (Elnaggar et al., 2021). Despite their potential, these
tools remain underutilized in the scientific community, primarily due to
a knowledge barrier. protemalyze aims to lower this barrier, providing a
more accessible entry point for researchers to explore data from pLMs
without having to engage with the technical details of the underlying
methods.

## Installation

You can install the development version of protemalyze like so:

``` r
install.packages("devtools")
library("devtools")
devtools::install_github("katarinaavucic/protemalyze", build_vignettes = TRUE)
library("protemalyze")
```

## Overview

To list all the functions available in the package:

``` r
ls("package:protemalyze")
```

To list the datasets in the package:

``` r
data(package = "protemalyze") 
```

To access tutorials for the package:

``` r
browseVignettes("protemalyze")
```

`protemalyze` contains 11 functions.

1.  ***loadEmbeddings*** for loading an embedding matrix from a “csv”,
    tsv”, or “h5” file.

2.  ***processData*** for removing NULL and duplicate values from an
    embedding matrix.

3.  ***generateDistanceMatrix*** for computing a distance matrix from an
    embedding matrix.

4.  ***generateRankMatrix*** for computing a rank matrix from an
    embedding matrix.

5.  ***getClosestPair*** for retrieving the closest pair for each
    protein in a ranked matrix.

6.  ***getFarthestPair*** for retrieving the farthest pair for each
    protein in a ranked matrix.

7.  ***getDistanceByMapping*** for retrieving the embedding distances
    from a distance matrix for protein pairs in a mapping.

8.  ***getRankByMapping*** for retrieving the embedding ranks from a
    rank matrix for protein pairs in a mapping.

9.  ***visualizeEmbeddingUMAP*** for visualizing the embedding matrix
    with an interactive plot of the UMAP created from the embedding
    matrix.

10. ***visualizeDistanceDistribution*** for visualizing the distribution
    of embedding distances from a distance matrix according to a
    mapping.

11. ***visualizeRankDistribution*** for visualizing the distribution of
    embedding ranks from a rank matrix according to a mapping.

The package also contains an embedding matrix from Escherichia coli,
called eColiEmbeddingMatrix and a mapping of the paralogs in Escherichia
coli, called eColiParalogMapping. Refer to package vignettes for more
details. An overview of the package is illustrated below.

## Contributions

The creator and maintainer of this package is Katarina Vucic, an
undergraduate student at the University of Toronto.

Raw per-protein embeddings for Escherichia coli were generated by
Uniprot. The one-to-many paralog mapping for Escherichia coli generated
from the Orthologous Matrix (OMA) Browser.

## References

- [Chandra, A. A., Tünnermann, L., Löfstedt, T., & Grätz, R. (2023).
  Transformer-based deep learning for predicting protein properties in
  the life sciences. ELife, 12.](https://doi.org/10.7554/elife.82819)
- [Elnaggar, A., Heinzinger, M., Dallago, C., Rehawi, G., Wang, Y.,
  Jones, L., Gibbs, T., Feher, T., Angerer, C., Steinegger, M., Bhowmik,
  D., & Rost, B. (2021). ProtTrans: Towards Cracking the Language of
  Lifes Code Through Self-Supervised Deep Learning and High Performance
  Computing. IEEE Transactions on Pattern Analysis and Machine
  Intelligence, 44(10), 1–1.](ttps://doi.org/10.1109/tpami.2021.3095381)
- [Yang, K. K., Wu, Z., Bedbrook, C. N., & Arnold, F. H. (2018). Learned
  protein embeddings for machine learning. Bioinformatics, 34(15),
  2642–2648.](https://doi.org/10.1093/bioinformatics/bty178)

## Acknowledgements

This package was developed as part of an assessment for 2024 BCB410H:
Applied Bioinformatics course at the University of Toronto, Toronto,
CANADA. protemalyze welcomes issues, enhancement requests, and other
contributions. To submit an issue, use the GitHub issues.
