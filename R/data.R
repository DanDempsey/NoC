#' Discovery Rate and Effort Proxy Data
#'
#' Aves, Isopoda, Mammalia, and Nematoda contain the number of discivories and unique authors per year between 1758 and 2019. Note that the number of authors are not fully accurate as we cannot distuingish multiple authors with the same name (among other issues).
#'
#' @format Dataframes with the following columns:
#' \describe{
#'   \item{Author_Numbers}{Number of unique authors per year (including authors of synonym discoveries).}
#'   \item{Discovery_Numbers}{Number of unique discoveries per year (not counting synonyms).}
#'   The row names correspond to the years.
#' }
#' @source [The Catalogue of Life](https://www.checklistbank.org/dataset/9910/download) (Retrieved August 2024).
#'
#' @name Catalogue of Life Data
#' @aliases Aves Isopoda Mammalia Nematoda
#' @usage
#' Aves
#' Isopoda
#' Mammalia
#' Nematoda
#' @examples
#' data(Aves)
#' head(Aves)
"Aves"
"Isopoda"
"Mammalia"
"Nematoda"



