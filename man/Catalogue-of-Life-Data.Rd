\docType{data}
\name{Catalogue of Life Data}
\alias{Catalogue of Life Data}
\alias{Aves}
\alias{Isopoda}
\alias{Mammalia}
\alias{Nematoda}
\title{Discovery Rate and Effort Proxy Data}
\format{
Dataframes with the following columns:
\describe{
\item{Author_Numbers}{Number of unique authors per year (including authors of synonym discoveries).}
\item{Discovery_Numbers}{Number of unique discoveries per year (not counting synonyms).}
The row names correspond to the years.
}
}
\source{
\href{https://www.checklistbank.org/dataset/9910/download}{The Catalogue of Life} (Retrieved August 2024).
}
\usage{
Aves
Isopoda
Mammalia
Nematoda
}
\description{
Aves, Isopoda, Mammalia, and Nematoda contain the number of discivories and unique authors per year between 1758 and 2019. Note that the number of authors are not fully accurate as we cannot distuingish multiple authors with the same name (among other issues).
}
\examples{
data(Aves)
head(Aves)
}
\keyword{datasets}
