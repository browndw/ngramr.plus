## ngramr.plus

This package has functions for processing [Google's Ngram repositories](http://storage.googleapis.com/books/ngrams/books/datasetsv2.html) without having to download them locally. These repositories vary in their size, but the larger ones (like th one for the letter *s* or common bigrams) contain multiple gigabytes.

The main function uses [chunking from the **readr** ](https://readr.tidyverse.org/reference/read_delim_chunked.html)package to reduce memory load. Still, depending on the specific word forms being searched, loading and processing the data tables can take up to a couple of minutes.

If you only want to plot and analyze trends, I would highly recommend the [**ngramr**](https://github.com/seancarmody/ngramr) package, which is extremely efficient.

The advantage of **ngramr.plus** is that it returns the underlying data, enabling more precise identification of peaks and troughs, the use of variability-based neighbor clustering for ground-up periodization (see the [vnc package](https://github.com/browndw/vnc)), etc.

## Installing ngramr.plus

Use devtools to install the package.

```r
devtools::install_github("browndw/ngramr.plus")
```
## Running vnc

The package contains
