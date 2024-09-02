#' Discovery Rate and Effort Proxy Data
#'
#' Aves, Isopoda, Mammalia, and Nematoda contain the number of discivories and unique authors per year between 1758 and 2019. Data taken from the Catalogue of Life website on August 2024. Note that the number of authors are not quite accurate as we cannot distuingish multiple authors with the same name (among other issues).
#'
#' @format Dataframes with the following columns:
#' \describe{
#'   \item{Effort_Proxy}{Number of unique authors per year (including authors of synonym discoveries).}
#'   \item{Discovery_Times}{Number of unique discoveries per year (not counting synonyms).}
#' }
#' @source The Catalogue of Life: https://www.checklistbank.org/dataset/9910/download
#'
#' @name Catalogue of Life Data
#' @aliases Aves Isopoda Mammalia Nematoda
#' @usage Aves
#' @usage Isopoda
#' @usage Mammalia
#' @usage Nematoda
#' @examples
#' data(Aves)
#' head(Aves)
#'
"Aves"
"Isopoda"
"Mammalia"
"Nematoda"



