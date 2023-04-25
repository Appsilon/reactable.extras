test_that("reactableExtrasUI should return a widget of reactableOutput", {
  # reactable_ui <- reactableExtrasUi("test")

  expect_snapshot(reactableExtrasUi("test"))
})
