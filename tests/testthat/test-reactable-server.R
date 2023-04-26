library(shiny)

test_that("reactable_page_controls should return UI for page navigation and display", {
  expect_snapshot(reactable_page_controls("test"))
})

test_that("return_reactable_page should return a reactive page value", {
  testServer(
    return_reactable_page, args = list(total_pages = 10), {
      expect_equal(page_number(), 1)

      session$setInputs(next_page = 2)
      expect_equal(page_number(), 2)
      expect_equal(output$page_text, "2 of 10")

      session$setInputs(last_page = 2)
      expect_equal(page_number(), 10)
      expect_equal(output$page_text, "10 of 10")

      session$setInputs(previous_page = 2)
      expect_equal(page_number(), 9)
      expect_equal(output$page_text, "9 of 10")

      session$setInputs(first_page = 2)
      expect_equal(page_number(), 1)
      expect_equal(output$page_text, "1 of 10")
    }
  )
})

test_that("reactableExtrasUI should return a widget of reactableOutput", {
  expect_snapshot(reactableExtrasUi("test"))
})
