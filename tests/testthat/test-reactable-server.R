library(shiny)
library(reactable)
library(shinytest2)
library(mockery)
library(purrr)

motor_trend_cars <- mtcars
motor_trend_cars$make <- rownames(motor_trend_cars)
rownames(motor_trend_cars) <- NULL

test_that("get_data_on_page should return the correct subset of the data", {
  test_data <- data.frame(
    month_name = month.name,
    month_abbrev = month.abb
  )

  page_1 <- head(test_data, 4)
  page_3 <- tail(test_data, 4)

  expect_error(get_data_on_page("test", 1, 3))
  expect_error(get_data_on_page(2, 1, 3))
  expect_error(get_data_on_page(test_data, "a", 3))
  expect_error(get_data_on_page(test_data, "1", 3))
  expect_error(get_data_on_page(test_data, 1.618, 3))
  expect_error(get_data_on_page(test_data, 4, 3))
  expect_error(get_data_on_page(test_data, 1, "a"))
  expect_error(get_data_on_page(test_data, 1, "3"))
  expect_error(get_data_on_page(test_data, 1, 3.141593))
  expect_equal(
    get_data_on_page(test_data, 1, 3),
    page_1
  )
  expect_equal(
    get_data_on_page(test_data, 3, 3),
    page_3,
    # expected data returned with tail had rownames 9 to 12, but retrieved data had 1 to 4
    ignore_attr = TRUE
  )
})

test_that("toggle_navigation_buttons should send the correct message to JS", {
  mock_session <- MockShinySession$new()
  class(mock_session) <- c("ShinySession", class(mock_session))

  # Mock sendCustomMessage to test inputs are handled properly
  mock_session$sendCustomMessage <- function(type, message) {
    (
      assign(
        message$id,
        sprintf(
          "type: %s; id: %s; disable: %s",
          type,
          message$id,
          message$disable
        )
      )
    )
  }

  # Mock purrr::walk to return the message as a vector of strings
  stub(
    toggle_navigation_buttons,
    "purrr::walk",
    function(.x, .f) {
      map_chr(.x, .f)
    }
  )

  expect_error(toggle_navigation_buttons(1, session = mock_session))
  expect_error(toggle_navigation_buttons("test", session = mock_session))
  expect_error(
    toggle_navigation_buttons(
      c(
        first_page = FALSE,
        previous_page = FALSE,
        next_page = FALSE,
        last_page = FALSE
      ),
      session = data.frame()
    )
  )
  expect_error(
    toggle_navigation_buttons(
      c(
        first_page = FALSE,
        previous_page = FALSE,
        next_page = FALSE,
        last_page = FALSE
      ),
      session = "session"
    )
  )

  expect_equal(
    toggle_navigation_buttons(
      c(
        first_page = FALSE,
        previous_page = FALSE,
        next_page = FALSE,
        last_page = FALSE
      ),
      session = mock_session
    ),
    c(
      "type: toggleDisable; id: #mock-session-first_page; disable: FALSE",
      "type: toggleDisable; id: #mock-session-previous_page; disable: FALSE",
      "type: toggleDisable; id: #mock-session-next_page; disable: FALSE",
      "type: toggleDisable; id: #mock-session-last_page; disable: FALSE"
    )
  )
  expect_equal(
    toggle_navigation_buttons(
      c(
        first_page = FALSE,
        previous_page = FALSE,
        next_page = TRUE,
        last_page = TRUE
      ),
      session = mock_session
    ),
    c(
      "type: toggleDisable; id: #mock-session-first_page; disable: FALSE",
      "type: toggleDisable; id: #mock-session-previous_page; disable: FALSE",
      "type: toggleDisable; id: #mock-session-next_page; disable: TRUE",
      "type: toggleDisable; id: #mock-session-last_page; disable: TRUE"
    )
  )
  expect_equal(
    toggle_navigation_buttons(
      c(
        first_page = TRUE,
        previous_page = TRUE,
        next_page = FALSE,
        last_page = FALSE
      ),
      session = mock_session
    ),
    c(
      "type: toggleDisable; id: #mock-session-first_page; disable: TRUE",
      "type: toggleDisable; id: #mock-session-previous_page; disable: TRUE",
      "type: toggleDisable; id: #mock-session-next_page; disable: FALSE",
      "type: toggleDisable; id: #mock-session-last_page; disable: FALSE"
    )
  )
})

test_that("reactable_page_controls should return UI for page navigation and display", {
  expect_error(reactable_page_controls(1))
  expect_error(reactable_page_controls(c("test1", "test2")))
  expect_snapshot(reactable_page_controls("test"))
})

test_that("return_reactable_page should return a reactive page value", {
  expect_error(return_reactable_page(1, 10))
  expect_error(return_reactable_page(c("test1", "test2"), 10))
  expect_error(return_reactable_page("test", "10"))
  expect_error(return_reactable_page("test", c(10, 20)))
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

test_that("reactable_extras_ui should return a widget of reactableOutput", {
  expect_error(reactable_extras_ui(1))
  expect_error(reactable_extras_ui(c("test1", "test2")))
  expect_snapshot(reactable_extras_ui("test"))
})

test_that("reactable_extras_server should return the correct data subset", {
  # Function should throw errors with invalid inputs
  expect_error(reactable_extras_server(1, mtcars))
  expect_error(reactable_extras_server(c("test1", "test2"), mtcars))
  expect_error(reactable_extras_server("test", 1))
  expect_error(reactable_extras_server("test", mtcars, total_pages = "a"))
  expect_error(reactable_extras_server("test", mtcars, total_pages = 1.618))
  expect_error(reactable_extras_server("test", mtcars, sortable = "a"))
  expect_error(reactable_extras_server("test", mtcars, not_a_valid_argument = TRUE))
  testServer(
    reactable_extras_server,
    args = list(
      data = motor_trend_cars,
      columns = list(
        mpg = colDef(name = "Miles per Gallon"),
        cyl = colDef(name = "Cylinders"),
        disp = colDef(name = "Displacement"),
        hp = colDef(name = "Horsepower"),
        wt = colDef(name = "Weight"),
        gear = colDef(name = "Number of forward gears"),
        vs = colDef(name = "Engine"),
        am = colDef(name = "Transmission")
      ),
      striped = TRUE,
      compact = TRUE,
      total_pages = 4
    ), {
      # Pagination should return the correct data subsets
      session$setInputs("page_controls-first_page" = 0)
      expect_equal(reactable_data(), head(motor_trend_cars, 8))
      session$setInputs("page_controls-last_page" = 1)
      expect_equal(reactable_data(), tail(motor_trend_cars, 8), ignore_attr = TRUE)
      session$setInputs("page_controls-previous_page" = 1)
      expect_equal(reactable_data(), motor_trend_cars[seq(17, 24, by = 1), ], ignore_attr = TRUE)
      session$setInputs("page_controls-first_page" = 1)
      expect_equal(reactable_data(), head(motor_trend_cars, 8))
      session$setInputs("page_controls-next_page" = 1)
      expect_equal(reactable_data(), motor_trend_cars[seq(9, 16, by = 1), ], ignore_attr = TRUE)

      # Reactable should be returned without error
      output$reactable
  })
})

test_that("reactable_extras_server should display the correct reactable page", {
  skip_on_cran()
  skip_on_ci()

  test_app <- shinyApp(
    reactable_extras_ui("test"),
    function(input, output, server) {
      reactable_extras_server(
        "test",
        data = motor_trend_cars,
        columns = list(
          mpg = colDef(name = "Miles per Gallon"),
          cyl = colDef(name = "Cylinders"),
          disp = colDef(name = "Displacement"),
          hp = colDef(name = "Horsepower"),
          wt = colDef(name = "Weight"),
          gear = colDef(name = "Number of forward gears"),
          vs = colDef(name = "Engine"),
          am = colDef(name = "Transmission")
        ),
        striped = TRUE,
        compact = TRUE,
        total_pages = 4
      )
    }
  )

  app <- AppDriver$new(
    test_app,
    name = "test",
    screenshot_args = FALSE,
    expect_values_screenshot_args = FALSE
  )

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
  app$set_inputs(`test-reactable__reactable__sorted` = character(0), allow_no_input_binding_ = TRUE)
  app$expect_values()

})
