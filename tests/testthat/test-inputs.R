library(testthat)

test_that("`args_js` returns correct output", {
  args <- args_js(a = "one", b = "two")

  expect_equal(args, ", a: 'one', b: 'two'")
})
