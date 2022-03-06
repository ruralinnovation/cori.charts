test_that("Colors have expected length", {
  expect_equal(length(cori_colors), 13)
})

test_that("Can generate palette", {
  pal1 <- cori_pal("ctg7")
  pal2 <- cori_pal("ctg7", reverse = TRUE)
  expect_equal(pal1(3), unname(cori_colors[c(1, 5, 13)]))
  expect_equal(pal2(3), pal1(3)[3:1])
})
