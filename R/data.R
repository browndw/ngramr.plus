#' Google Books Ngram Total Counts - All English
#'
#' This dataset contains the total word counts per year for all English books
#' in the Google Books corpus, as provided by Google Books Ngram Viewer project.
#' This data is used by the google_ngram() function to normalize frequency counts.
#'
#' @format A data frame with 425 rows and 4 variables:
#' \describe{
#'   \item{Year}{Numeric. The year of publication (1505-2008)}
#'   \item{Total}{Numeric. Total number of words published in that year}
#'   \item{Pages}{Numeric. Total number of pages published in that year}
#'   \item{Volumes}{Numeric. Total number of volumes (books) published in that year}
#' }
#' @source Google Books Ngram Datasets, Version 2 (July 2012)
#'   \url{http://storage.googleapis.com/books/ngrams/books/datasetsv2.html}
#' @references
#'   Michel, J. B., Shen, Y. K., Aiden, A. P., Veres, A., Gray, M. K., 
#'   Pickett, J. P., ... & Orwant, J. (2011). Quantitative analysis of culture 
#'   using millions of digitized books. Science, 331(6014), 176-182.
#' @examples
#' data(googlebooks_eng_all_totalcounts_20120701)
#' head(googlebooks_eng_all_totalcounts_20120701)
#' # Total words published in 2000
#' subset(googlebooks_eng_all_totalcounts_20120701, Year == 2000)$Total
"googlebooks_eng_all_totalcounts_20120701"

#' Google Books Ngram Total Counts - British English
#'
#' This dataset contains the total word counts per year for British English books
#' in the Google Books corpus, as provided by Google Books Ngram Viewer project.
#' This data is used by the google_ngram() function to normalize frequency counts
#' when variety="gb" is specified.
#'
#' @format A data frame with 447 rows and 4 variables:
#' \describe{
#'   \item{Year}{Numeric. The year of publication (1524-2008)}
#'   \item{Total}{Numeric. Total number of words published in that year}
#'   \item{Pages}{Numeric. Total number of pages published in that year}
#'   \item{Volumes}{Numeric. Total number of volumes (books) published in that year}
#' }
#' @source Google Books Ngram Datasets, Version 2 (July 2012)
#'   \url{http://storage.googleapis.com/books/ngrams/books/datasetsv2.html}
#' @references
#'   Michel, J. B., Shen, Y. K., Aiden, A. P., Veres, A., Gray, M. K., 
#'   Pickett, J. P., ... & Orwant, J. (2011). Quantitative analysis of culture 
#'   using millions of digitized books. Science, 331(6014), 176-182.
#' @examples
#' data(googlebooks_eng_gb_all_totalcounts_20120701)
#' head(googlebooks_eng_gb_all_totalcounts_20120701)
#' # Total words published in British English in 2000
#' subset(googlebooks_eng_gb_all_totalcounts_20120701, Year == 2000)$Total
"googlebooks_eng_gb_all_totalcounts_20120701"

#' Google Books Ngram Total Counts - American English
#'
#' This dataset contains the total word counts per year for American English books
#' in the Google Books corpus, as provided by Google Books Ngram Viewer project.
#' This data is used by the google_ngram() function to normalize frequency counts
#' when variety="us" is specified.
#'
#' @format A data frame with 410 rows and 4 variables:
#' \describe{
#'   \item{Year}{Numeric. The year of publication (1500-2008)}
#'   \item{Total}{Numeric. Total number of words published in that year}
#'   \item{Pages}{Numeric. Total number of pages published in that year}
#'   \item{Volumes}{Numeric. Total number of volumes (books) published in that year}
#' }
#' @source Google Books Ngram Datasets, Version 2 (July 2012)
#'   \url{http://storage.googleapis.com/books/ngrams/books/datasetsv2.html}
#' @references
#'   Michel, J. B., Shen, Y. K., Aiden, A. P., Veres, A., Gray, M. K., 
#'   Pickett, J. P., ... & Orwant, J. (2011). Quantitative analysis of culture 
#'   using millions of digitized books. Science, 331(6014), 176-182.
#' @examples
#' data(googlebooks_eng_us_all_totalcounts_20120701)
#' head(googlebooks_eng_us_all_totalcounts_20120701)
#' # Total words published in American English in 2000
#' subset(googlebooks_eng_us_all_totalcounts_20120701, Year == 2000)$Total
"googlebooks_eng_us_all_totalcounts_20120701"
