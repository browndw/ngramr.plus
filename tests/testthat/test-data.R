test_that("data objects have correct structure", {
  # Load the data objects
  data("googlebooks_eng_all_totalcounts_20120701", package = "ngramr.plus")
  data("googlebooks_eng_gb_all_totalcounts_20120701", package = "ngramr.plus")
  data("googlebooks_eng_us_all_totalcounts_20120701", package = "ngramr.plus")
  
  # Test that they are data frames
  expect_is(googlebooks_eng_all_totalcounts_20120701, "data.frame")
  expect_is(googlebooks_eng_gb_all_totalcounts_20120701, "data.frame")
  expect_is(googlebooks_eng_us_all_totalcounts_20120701, "data.frame")
  
  # Test that they have the expected columns
  expect_true("Year" %in% colnames(googlebooks_eng_all_totalcounts_20120701))
  expect_true("Total" %in% colnames(googlebooks_eng_all_totalcounts_20120701))
  
  expect_true("Year" %in% colnames(googlebooks_eng_gb_all_totalcounts_20120701))
  expect_true("Total" %in% colnames(googlebooks_eng_gb_all_totalcounts_20120701))
  
  expect_true("Year" %in% colnames(googlebooks_eng_us_all_totalcounts_20120701))
  expect_true("Total" %in% colnames(googlebooks_eng_us_all_totalcounts_20120701))
  
  # Test that they have reasonable data
  expect_true(nrow(googlebooks_eng_all_totalcounts_20120701) > 0)
  expect_true(nrow(googlebooks_eng_gb_all_totalcounts_20120701) > 0)
  expect_true(nrow(googlebooks_eng_us_all_totalcounts_20120701) > 0)
  
  # Test year ranges are reasonable
  expect_true(all(googlebooks_eng_all_totalcounts_20120701$Year >= 1500))
  expect_true(all(googlebooks_eng_all_totalcounts_20120701$Year <= 2020))
})
