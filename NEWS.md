# ngramr.plus 1.0.1

## New Features

* Initial CRAN release of ngramr.plus
* `google_ngram()` function for extracting frequency data from Google Books Ngram corpus
* Support for multiple English varieties: all English ("eng"), British English ("gb"), and American English ("us")
* Flexible aggregation by year or decade
* Support for 1-5 gram searches with automatic file detection
* Comprehensive error handling for network issues and data availability

## Data

* Included total count datasets for normalization:
  * `googlebooks_eng_all_totalcounts_20120701`: All English books
  * `googlebooks_eng_gb_all_totalcounts_20120701`: British English books  
  * `googlebooks_eng_us_all_totalcounts_20120701`: American English books

## Documentation

* Complete function documentation with examples
* Comprehensive vignette with usage examples and plotting demonstrations
* Full documentation for all data objects

## Technical Features

* Robust network error handling with informative error messages
* Internet connectivity checking before data requests
* Memory-efficient chunked reading for large Google Books files
* Proper handling of special characters and Unicode in search terms
* Comprehensive test suite with 39 unit tests covering input validation, data processing, and error conditions

## Dependencies

* `readr` for efficient data reading
* `stringr` and `stringi` for text processing
* `curl` for network connectivity checking
