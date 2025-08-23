## ngramr.plus

[![R-CMD-check](https://github.com/browndw/ngramr.plus/workflows/R-CMD-check/badge.svg)](https://github.com/browndw/ngramr.plus/actions)
[![Tests](https://github.com/browndw/ngramr.plus/workflows/Tests/badge.svg)](https://github.com/browndw/ngramr.plus/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/ngramr.plus)](https://CRAN.R-project.org/package=ngramr.plus)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/ngramr.plus)](https://cran.r-project.org/package=ngramr.plus)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This package has functions for processing [Google's Ngram repositories](http://storage.googleapis.com/books/ngrams/books/datasetsv2.html) without having to download them locally. These repositories vary in their size, but the larger ones (like th one for the letter *s* or common bigrams) contain multiple gigabytes.

The main function uses [chunking from the **readr** ](https://readr.tidyverse.org/reference/read_delim_chunked.html)package to reduce memory load. Still, depending on the specific word forms being searched, loading and processing the data tables can take up to a couple of minutes.

If you only want to plot and analyze trends, I would highly recommend the [**ngramr**](https://github.com/seancarmody/ngramr) package, which is extremely efficient.

The advantage of **ngramr.plus** is that it returns the underlying data, enabling more precise identification of peaks and troughs, the use of variability-based neighbor clustering for ground-up periodization (see the [vnc package](https://github.com/browndw/vnc)), etc.

## Installing ngramr.plus

Install from CRAN:

```r
install.packages("ngramr.plus")
```

Or install the development version from GitHub:

```r
devtools::install_github("browndw/ngramr.plus")
```

The package documentation is available on [readthedocs](https://cmu-textstat-docs.readthedocs.io/en/latest/ngramr.plus/ngramr.plus.html)
