#' This function extracts frequency data from Google Books' Ngram data:
#' http://storage.googleapis.com/books/ngrams/books/datasetsv2.html
#' The function is set up to facilitate the counting of lemmas
#' and ignore differences in capitalization.
#' The user has control over what to combine into counts with
#' the word_forms argument.
#'
#' NOTE!!! Google's data tables are HUGE. Sometime running into
#' multiple gigabytes for simple text files. Thus, depending
#' on the table being accessed, the return time can be slow.
#' For example, accessing the 1-gram Q file should take only a few seconds,
#' but the 1-gram T file might take 10 minutes to process.
#' The 2-gram, 3-gram, etc. files are even larger and slower to process.
#'
#' @param word_forms A vector of words or phrases to be searched
#' @param variety The variety of English to be searched
#' @param by Whether the counts should be summed by year or by decade
#' @return A data.frame of counts from Google Books
#' @export
google_ngram <- function(word_forms, variety=c("eng", "gb", "us", "fiction"), by=c("year", "decade")){
  n <- lapply(word_forms, function(x) stringr::str_count(x, "\\w+"))
  n <- unique(n)
  if (length(n) > 1)  stop ("Check spelling. Word forms should be lemmas of the same word (e.g. 'teenager' and 'teenagers' or 'walk' , 'walks' and 'walked'")
  gram <- lapply(word_forms, function(x) substring(x, 1, n))
  gram <- tolower(unique(gram))
  if (length(gram) > 1)  stop ("Check spelling. Word forms should be lemmas of the same word (e.g. 'teenager' and 'teenagers' or 'walk' , 'walks' and 'walked'")

  if(variety == "eng") repo <- paste0("http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-", n, "gram-20120701-", gram, ".gz")
  if(variety != "eng") repo <- paste0("http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-", variety, "-all-", n, "gram-20120701-", gram, ".gz")

  grep_words <- paste0("^", word_forms, "$", collapse = "|")
  all_grams <- suppressWarnings(readr::read_tsv_chunked(repo, col_names = FALSE, col_types = list(X1 = readr::col_character(), X2 = readr::col_double(), X3 = readr::col_double(), X4 = readr::col_double()), quote = "", callback = DataFrameCallback$new(function(x, pos) subset(x, grepl(grep_words, x$X1, ignore.case=TRUE))), progress = T))
  colnames(all_grams) <- c("token", "year", "token_count", "pages")

  if(variety == "eng") repo_total <-("http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-totalcounts-20120701.txt")
  if(variety != "eng") repo_total <-paste0("http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-", variety, "-all-totalcounts-20120701.txt")
  total_counts <- suppressWarnings(read.csv(repo_total, header = FALSE, sep = "\t", quote = ""))

  total_counts <- as.data.frame(t(total_counts))
  total_counts <- data.frame(V1 = (total_counts[!is.na(total_counts),]))
  total_counts <- data.frame(do.call("rbind", strsplit(as.character(total_counts$V1), "," ,fixed = TRUE)))
  colnames(total_counts) <- c("year", "total_count", "page_count", "volume_count")
  total_counts$total_count <- as.numeric(as.character(total_counts$total_count))
  total_counts$decade <- gsub("\\d$", "0", total_counts$year)
  if (by == "year") total_counts <- aggregate(total_count ~ year, total_counts, sum)
  if (by == "decade") total_counts <- aggregate(total_count ~ decade, total_counts, sum)

  all_tokens <- subset(all_grams, grepl(grep_words, all_grams$token, ignore.case=TRUE))
  all_tokens$token <- tolower(all_tokens$token)
  sum_tokens <- aggregate(token_count ~ year, all_tokens, sum)
  sum_tokens$decade <- gsub("\\d$", "0", sum_tokens$year)
  if (by == "decade") sum_tokens <- aggregate(token_count ~ decade, sum_tokens, sum)
  if (by == "year") sum_tokens <- merge(sum_tokens, y = total_counts[,c(1:2)], by = "year")
  if (by == "decade") sum_tokens <- merge(sum_tokens, y = total_counts[,c(1:2)], by = "decade")
  counts_norm <- mapply(function(x,y) (x/y)*1000000, sum_tokens$token_count, sum_tokens$total_count)
  sum_tokens$counts_permil <- counts_norm
  return(sum_tokens)
}
