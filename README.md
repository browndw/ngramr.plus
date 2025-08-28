# ngramr.plus

<!-- badges: start -->
[![R-CMD-check](https://github.com/browndw/ngramr.plus/workflows/R-CMD-check/badge.svg)](https://github.com/browndw/ngramr.plus/actions)
[![Tests](https://github.com/browndw/ngramr.plus/workflows/Tests/badge.svg)](https://github.com/browndw/ngramr.plus/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/ngramr.plus)](https://CRAN.R-project.org/package=ngramr.plus)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/ngramr.plus)](https://cran.r-project.org/package=ngramr.plus)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

## Overview

**ngramr.plus** provides functions for extracting frequency data from [Google Books Ngram datasets](http://storage.googleapis.com/books/ngrams/books/datasetsv2.html) without requiring local downloads. The package enables researchers to analyze word usage patterns across centuries of published texts in multiple varieties of English.

### Key Features

- **Direct access** to Google Books Ngram data (no local downloads required)
- **Multiple English varieties**: All English, British English, American English
- **Flexible time aggregation**: by year or decade
- **Support for 1-5 grams**: single words to 5-word phrases
- **Memory efficient**: uses chunked reading for large datasets
- **Robust error handling**: comprehensive network and data validation
- **Normalized frequencies**: returns both raw counts and per-million-word rates

### Why ngramr.plus?

While the excellent [**ngramr**](https://github.com/seancarmody/ngramr) package excels at plotting trends, **ngramr.plus** returns the underlying frequency data, enabling:

- Precise identification of peaks and troughs in word usage
- Advanced statistical analysis of linguistic trends
- Integration with other text analysis workflows
- Custom visualization and modeling approaches
- Variability-based neighbor clustering for periodization (see [vnc package](https://github.com/browndw/vnc))

## Installation

Install from CRAN:

```r
install.packages("ngramr.plus")
```

Or install the development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("browndw/ngramr.plus")
```

## Quick Start

```r
library(ngramr.plus)

# Get yearly frequency data for "zinger" in US English
zinger_data <- google_ngram("zinger", variety = "us", by = "year")
head(zinger_data)
#>   Year  AF    Total Per_10.6
#> 1 1950   5  1234567     4.05
#> 2 1955  12  1456789     8.23
#> 3 1960  45  1678901    26.81

# Search for multiple word forms (lemmas) in British English by decade
walk_data <- google_ngram(c("walk", "walks", "walked"), 
                          variety = "gb", by = "decade")

# Search for phrases (up to 5 words)
ml_data <- google_ngram("machine learning", variety = "eng", by = "year")
```

## Main Function

### `google_ngram()`

Extracts frequency data from Google Books Ngram corpus with the following parameters:

- **`word_forms`**: Character vector of words/phrases to search (max 5 tokens per ngram)
- **`variety`**: English variety - `"eng"` (all), `"gb"` (British), or `"us"` (American)  
- **`by`**: Time aggregation - `"year"` or `"decade"`

**Returns**: Data frame with columns:

- `Year`/`Decade`: Time period
- `AF`: Absolute frequency (total occurrences)
- `Total`: Total words in corpus for that period
- `Per_10.6`: Normalized frequency per million words

## Data Processing Notes

### Performance Considerations

- **File sizes vary greatly**: Simple queries (Q, X, Z files) process in seconds, while common letters/bigrams may take several minutes
- **Memory efficient**: Uses chunked reading to handle multi-gigabyte Google datasets
- **Internet required**: Functions access live Google Books repositories
- **Progress tracking**: Shows progress bar for longer operations

### Word Form Guidelines

- Use **lemmas** of the same word (e.g., `c("teenager", "teenagers")`)
- **Case insensitive**: Automatically handles capitalization differences  
- **Hyphenated words**: Count as multiple tokens (e.g., "x-ray" = 3 tokens)
- **Special characters**: Properly escaped for pattern matching
- **Unicode support**: Handles international characters

## Error Handling

The package includes comprehensive error handling for:

- **Network issues**: Timeout, connectivity problems
- **Missing data**: Files not found, empty results
- **Input validation**: Token limits, mixed ngram lengths
- **Server errors**: HTTP errors, temporary unavailability

## Example Analysis

```r
library(ngramr.plus)
library(ggplot2)

# Analyze the rise of technology terminology starting with 'c'
tech_data <- google_ngram(c("computer", "computing", "cyber"), 
                          variety = "eng", by = "year")

# Plot the trend
ggplot(tech_data, aes(x = Year, y = Per_10.6)) +
  geom_line() +
  geom_point() +
  labs(title = "Rise of Computing Terminology",
       x = "Year", 
       y = "Frequency (per million words)") +
  theme_minimal()
```

## Documentation

- **Function help**: `?google_ngram`
- **Package vignette**: `browseVignettes("ngramr.plus")`
- **Full documentation**: [ReadTheDocs](https://cmu-textstat-docs.readthedocs.io/en/latest/ngramr.plus/ngramr.plus.html)

## Citation

If you use ngramr.plus in research, please cite:

```r
citation("ngramr.plus")
```

## Related Packages

- [**ngramr**](https://github.com/seancarmody/ngramr): Efficient ngram visualization
- [**vnc**](https://github.com/browndw/vnc): Variability-based neighbor clustering
- [**tidytext**](https://github.com/juliasilge/tidytext): Text mining with tidy principles

## Contributing

Bug reports and feature requests are welcome on [GitHub Issues](https://github.com/browndw/ngramr.plus/issues).

## License

MIT License. See [LICENSE](LICENSE) file for details.
