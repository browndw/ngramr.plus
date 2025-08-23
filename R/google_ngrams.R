#' Extract frequency data from Google Books Ngram corpus
#'
#' This function extracts frequency data from Google Books' Ngram data:
#' \url{http://storage.googleapis.com/books/ngrams/books/datasetsv2.html}.
#' The function is set up to facilitate the counting of lemmas
#' and ignore differences in capitalization.
#' The user has control over what to combine into counts with
#' the word_forms argument.
#'
#' @details
#' NOTE!!! Google's data tables are HUGE. Sometimes running into
#' multiple gigabytes for simple text files. Thus, depending
#' on the table being accessed, the return time can be slow.
#' For example, accessing the 1-gram Q file should take only a few seconds,
#' but the 1-gram T file might take 10 minutes to process.
#' The 2-gram, 3-gram, etc. files are even larger and slower to process.
#'
#' The function includes error handling for network issues, missing files,
#' and connectivity problems. If no data is found for the specified word forms,
#' a warning is issued and an empty data frame is returned.
#'
#' @param word_forms A character vector of words or phrases to be searched.
#'   All forms should be lemmas of the same word (e.g., c("teenager",
#'   "teenagers") or c("walk", "walks", "walked")). Maximum of 5 tokens per
#'   ngram.
#' @param variety Character string specifying the variety of English to search.
#'   Options are "eng" (all English), "gb" (British English), or "us"
#'   (American English).
#' @param by Character string specifying whether counts should be aggregated by
#'   "year" or by "decade".
#' @return A data.frame with the following columns:
#'   \describe{
#'     \item{Year or Decade}{Numeric year or decade}
#'     \item{AF}{Absolute frequency (total occurrences)}
#'     \item{Total}{Total words in corpus for that time period}
#'     \item{Per_10.6}{Normalized frequency per million words}
#'   }
#' @importFrom stats aggregate
#' @export
#' @examples
#' \dontrun{
#' # Get yearly counts for "zinger" in US English
#' zinger_data <- google_ngram("zinger", variety = "us", by = "year")
#' head(zinger_data)
#'
#' # Get decade counts for multiple word forms in British English
#' walk_data <- google_ngram(c("walk", "walks", "walked"), variety = "gb",
#'                           by = "decade")
#' head(walk_data)
#'
#' # Search for a phrase in all English
#' phrase_data <- google_ngram("machine learning", variety = "eng", by = "year")
#' head(phrase_data)
#' }
google_ngram <- function(word_forms, variety = c("eng", "gb", "us"),
                         by = c("year", "decade")) {
  variety <- match.arg(variety)
  by <- match.arg(by)

  word_forms <- stringr::str_replace_all(word_forms,
                                         "([a-zA-z0-9])-([a-zA-z0-9])",
                                         "\\1 - \\2")
  word_forms <- stringr::str_squish(word_forms)
  n <- lapply(word_forms, function(x) stringr::str_count(x, "\\S+"))
  n <- unique(unlist(n))
  if (length(n) > 1) {
    stop("Check spelling. Word forms should be lemmas of the same word ",
         "(e.g. 'teenager' and 'teenagers' or 'walk' , 'walks' and 'walked'")
  }
  if (n > 5) {
    stop("Ngrams can be a maximum of 5 tokens. Hyphenated words are split ",
         "and include the hyphen, so 'x-ray' would count as 3 tokens.")
  }
  if (n > 1) {
    gram <- lapply(word_forms, function(x) substring(x, 1, 2))
  } else {
    gram <- lapply(word_forms, function(x) substring(x, 1, 1))
  }
  gram <- tolower(unique(unlist(gram)))
  if (length(gram) > 1) {
    stop("Check spelling. Word forms should be lemmas of the same word ",
         "(e.g. 'teenager' and 'teenagers' or 'walk' , 'walks' and 'walked'")
  }
  if (stringr::str_detect(gram, "^[a-z][^a-z]")) {
    gram <- stringr::str_replace(gram, "[^a-z]", "_")
  }
  if (stringr::str_detect(gram, "^[0-9]")) gram <- substring(gram, 1, 1)
  if (stringr::str_detect(gram, "^[[:punct:]]")) gram <- "punctuation"
  # Define the special Unicode characters for "other" category
  special_chars <- c("\u00df", "\u00e6", "\u00f0", "\u00f8", "\u0142",
                     "\u0153", "\u0131", "\u0192", "\u00fe", "\u0225",
                     "\u0259", "\u0127", "\u014b", "\u00aa", "\u00ba",
                     "\u0263", "\u0111", "\u0133", "\u0254", "\u021d",
                     "\u2170", "\u028a", "\u028c", "\u0294", "\u025b",
                     "\u0261", "\u024b", "\u2171", "\u0283", "\u0207",
                     "\u0251", "\u2172")
  if (any(stringr::str_detect(substring(gram, 1, 1), special_chars))) {
    gram <- "other"
  }
  gram <- stringi::stri_trans_general(gram, "Latin-ASCII")

  if (variety == "eng") {
    repo <- paste0("http://storage.googleapis.com/books/ngrams/books/",
                   "googlebooks-eng-all-", n, "gram-20120701-", gram, ".gz")
  }
  if (variety != "eng") {
    repo <- paste0("http://storage.googleapis.com/books/ngrams/books/",
                   "googlebooks-eng-", variety, "-all-", n,
                   "gram-20120701-", gram, ".gz")
  }

  message("Accessing repository. For larger ones (e.g., ngrams containing 2 ",
          "or more words) this may take a few minutes. A progress bar should ",
          "appear shortly...")

  # Check internet connectivity first
  if (!curl::has_internet()) {
    stop("No internet connection detected. Please check your network ",
         "connection and try again.")
  }

  word_forms <- stringr::str_replace_all(
    word_forms,
    "(\\.|\\?|\\$|\\^|\\)|\\(|\\}|\\{|\\]|\\[|\\*)",
    "\\\\\\1"
  )
  grep_words <- paste0("^", word_forms, "$", collapse = "|")

  # Attempt to download data with error handling
  all_grams <- tryCatch({
    suppressWarnings(readr::read_tsv_chunked(
      repo,
      col_names = FALSE,
      col_types = list(X1 = readr::col_character(),
                       X2 = readr::col_double(),
                       X3 = readr::col_double(),
                       X4 = readr::col_double()),
      quote = "",
      callback = readr::DataFrameCallback$new(
        function(x, pos) {
          subset(x, grepl(grep_words, x$X1, ignore.case = TRUE))
        }
      ),
      progress = TRUE
    ))
  }, error = function(e) {
    if (grepl("HTTP error 404|Not Found", e$message, ignore.case = TRUE)) {
      stop("The requested Google Books ngram file was not found. This may ",
           "occur if:\n",
           "  - The word contains unsupported characters\n",
           "  - The ngram length is invalid\n",
           "  - Google's data structure has changed\n",
           "  Original error: ", e$message, call. = FALSE)
    } else if (grepl("timeout|connection|network", e$message,
                     ignore.case = TRUE)) {
      stop("Network timeout or connection error. This may be due to:\n",
           "  - Slow internet connection\n",
           "  - Google's servers being temporarily unavailable\n",
           "  - Large file size (try a less common word)\n",
           "  Please try again later.\n",
           "  Original error: ", e$message, call. = FALSE)
    } else if (grepl("HTTP error", e$message, ignore.case = TRUE)) {
      stop("HTTP error while accessing Google Books data:\n",
           "  ", e$message, "\n",
           "  This may be a temporary server issue. Please try again later.",
           call. = FALSE)
    } else {
      stop("Error downloading Google Books ngram data:\n",
           "  ", e$message, "\n",
           "  Please check your internet connection and try again.",
           call. = FALSE)
    }
  })

  # Check if we got any data
  if (is.null(all_grams) || nrow(all_grams) == 0) {
    warning("No data found for the specified word form(s): ",
            paste(word_forms, collapse = ", "),
            ". This could mean:\n",
            "  - The word(s) do not appear in Google Books corpus\n",
            "  - The word(s) are too recent or too rare\n",
            "  - There was an issue with data processing")
    return(data.frame(Year = integer(0), AF = numeric(0),
                      Total = numeric(0), Per_10.6 = numeric(0)))
  }

  colnames(all_grams) <- c("token", "Year", "AF", "pages")

  if (variety == "eng") {
    total_counts <- ngramr.plus::googlebooks_eng_all_totalcounts_20120701
  }
  if (variety == "gb") {
    total_counts <- ngramr.plus::googlebooks_eng_gb_all_totalcounts_20120701
  }
  if (variety == "us") {
    total_counts <- ngramr.plus::googlebooks_eng_us_all_totalcounts_20120701
  }

  if (by == "year") total_counts <- aggregate(Total ~ Year, total_counts, sum)
  if (by == "decade") {
    total_counts$Decade <- gsub("\\d$", "0", total_counts$Year)
  }
  if (by == "decade") {
    total_counts <- aggregate(Total ~ Decade, total_counts, sum)
  }

  all_grams$token <- tolower(all_grams$token)
  sum_tokens <- aggregate(AF ~ Year, all_grams, sum)

  if (by == "decade") sum_tokens$Decade <- gsub("\\d$", "0", sum_tokens$Year)
  if (by == "decade") sum_tokens <- aggregate(AF ~ Decade, sum_tokens, sum)
  if (by == "decade") {
    sum_tokens <- merge(sum_tokens, y = total_counts[, c(1:2)],
                        by = "Decade")
  }
  if (by == "decade") sum_tokens$Decade <- as.numeric(sum_tokens$Decade)
  if (by == "year") {
    sum_tokens <- merge(sum_tokens, y = total_counts[, c(1:2)], by = "Year")
  }

  counts_norm <- mapply(function(x, y) (x / y) * 1000000, sum_tokens$AF,
                        sum_tokens$Total)
  sum_tokens$Per_10.6 <- counts_norm
  return(sum_tokens)
}
