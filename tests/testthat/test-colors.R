test_that("Colors have expected length", {
  expect_equal(length(cori_colors), 26)
})

test_that("Can generate palette", {
  pal1 <- cori_pal("ctg7")
  pal2 <- cori_pal("ctg7", reverse = TRUE)
  pal3 <- cori_pal("ctg2or")

  # Interpolated palette
  expect_equal(pal3(2), unname(cori_colors[c(7, 9)]))
  # Reverse test
  expect_equal(pal2(3), pal1(3)[3:1])
})
