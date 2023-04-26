library(shiny)
library(shinytest2)

test_that("reactable_page_controls should return UI for page navigation and display", {
  expect_snapshot(reactable_page_controls("test"))
})

test_that("return_reactable_page should return a reactive page value", {
  testServer(
    return_reactable_page, args = list(total_pages = 10), {
      session$setInputs(first_page = 0)
      expect_equal(page_number(), 1)
      expect_equal(output$page_text, "1 of 10")
      expect_equal(session$returned(), 1)

      session$setInputs(next_page = 1)
      expect_equal(page_number(), 2)
      expect_equal(output$page_text, "2 of 10")
      expect_equal(session$returned(), 2)

      session$setInputs(last_page = 1)
      expect_equal(page_number(), 10)
      expect_equal(output$page_text, "10 of 10")
      expect_equal(session$returned(), 10)

      session$setInputs(previous_page = 1)
      expect_equal(page_number(), 9)
      expect_equal(output$page_text, "9 of 10")
      expect_equal(session$returned(), 9)

      session$setInputs(first_page = 1)
      expect_equal(page_number(), 1)
      expect_equal(output$page_text, "1 of 10")
      expect_equal(session$returned(), 1)
    }
  )
})

test_that("reactableExtrasUI should return a widget of reactableOutput", {
  expect_snapshot(reactableExtrasUi("test"))
})

test_that("reactablExtrasServer should display the correct reactable page", {
  skip_on_cran()

  motor_trend_cars <- mtcars
  motor_trend_cars$make <- rownames(motor_trend_cars)
  rownames(motor_trend_cars) <- NULL

  test_app <- shinyApp(
    reactableExtrasUi("test"),
    function(input, output, server) {
      reactableExtrasServer(
        "test",
        data = motor_trend_cars,
        columns = list(
          mpg = reactable::colDef(name = "Miles per Gallon"),
          cyl = reactable::colDef(name = "Cylinders"),
          disp = reactable::colDef(name = "Displacement")
        ),
        rows_per_page = 17
      )
    }
  )

  app <- AppDriver$new(test_app, name = "test", screenshot_args = FALSE)

  app$set_window_size(width = 1619, height = 1049)
  app$expect_values()
  app$click("test-page_controls-next_page")
  app$expect_values()
  app$click("test-page_controls-last_page")
  app$expect_values()
  app$click("test-page_controls-previous_page")
  app$expect_values()
  app$click("test-page_controls-first_page")
  app$expect_values()
  app$set_inputs(`test-reactable__reactable__sorted` = "asc", allow_no_input_binding_ = TRUE)
  app$expect_values()
  app$set_inputs(`test-reactable__reactable__sorted` = "desc", allow_no_input_binding_ = TRUE)
  app$expect_values()
  app$set_inputs(`test-reactable__reactable__sorted` = character(0), allow_no_input_binding_ = TRUE)
  app$expect_values()
  app$set_inputs(`test-reactable__reactable__sorted` = "asc", allow_no_input_binding_ = TRUE)
  app$expect_values()
  app$set_inputs(`test-reactable__reactable__sorted` = "desc", allow_no_input_binding_ = TRUE)
  app$expect_values()
  app$set_inputs(`test-reactable__reactable__sorted` = "asc", allow_no_input_binding_ = TRUE)
  app$expect_values()

})
