# reactable.extras

> _TODO_

<!-- badges: start -->
![R-CMD-check](https://github.com/Appsilon/reactable.extras/workflows/R-CMD-check/badge.svg)
<!-- badges: end -->

## How to install?

Development version:

```r
remotes::install_github("Appsilon/reactable.extras")
```

## How to use it?

### Server-Side Processing

Rendering a `reactable` with a lot of data can be inefficient. The initial loading will take some time, and a lot of memory will be thrown to the browser.

A more efficient approach is to render only the data that is needed to be displayed.

`reactable_extras_ui()` and `reactalbe_extras_server()` is a wrapper for `reactable::reactableOutput()` and `reactable::renderReactable({reactable(...)})`.
It renders only a subset of a large data in the server memory. This almost instantly renders the desired page and keeps the amount of memory used in the browser minimal.

Consider this example data:

```r
library(shiny)
library(reactable)
library(reactable.extras)

mtcars_ultra <- purrr::map(
  seq(1L, 20000L, by = 1L),
  ~ {
    temp_df <- mtcars
    temp_df$make <- rownames(temp_df)
    rownames(temp_df) <- NULL
    temp_df <-
      dplyr::mutate(temp_df, id_row = paste0("id_", dplyr::row_number(), "_", .x))

    temp_df
  },
  .progress = TRUE
) |>
  purrr::list_rbind()
```

And compare the difference in initial load time and amount of memory used in the browser when loading all the data at once vs loading only the data needed for the page.

```r
# All of the data rendered all at once
shinyApp(
  reactableOutput("test"),
  function(input, output, server) {
    output$test <- renderReactable(
      reactable(
        data = mtcars_ultra,
        columns = list(
          mpg = colDef(name = "Miles per Gallon"),
          cyl = colDef(name = "Cylinders"),
          disp = colDef(name = "Displacement")
        ),
        defaultPageSize = 16
      )
    )
  }
)

# Only the subset of the data needed for the page is rendered
shinyApp(
  reactable_extras_ui("test"),
  function(input, output, server) {
    reactable_extras_server(
      "test",
      data = mtcars_ultra,
      columns = list(
        mpg = colDef(name = "Miles per Gallon"),
        cyl = colDef(name = "Cylinders"),
        disp = colDef(name = "Displacement")
      ),
      total_pages = 4e4
    )
  }
)

```

Server-Side Processing                  |  Rendering All Data At Once
:--------------------------------------:|:-----------------------------------:
![](./gifs/server-side-processing.gif)  |  ![](./gifs/full-data-rendered.gif)

### Custom inputs

You can use custom inputs inside your reactable column. 

Supported types for now: 

  - text input: `text_extra`
  - button: `button_extra`
  - dropdown: `dropdown_extra`
  - date: `date_extra`
  - checkbox: `checkbox_extra`

It's possible to apply additional styling to your inputs by passing `class` argument:

`checkbox_extra("check", class = "checkbox-extra")`

Also it's important to import javascript dependencies by adding to `ui`:

`reactable.extras::reactable_extras_dependency()`

All events of your inputs will be tracked and can be used in your shiny server.

Example application:

```r
library(shiny)
library(reactable)
library(reactable.extras)
string_list <- function(values) {
  paste0(
    "{", paste0(names(values), " : ", unlist(values), collapse = ", "), "}"
  )
}

shinyApp(
  ui = fluidPage(
    reactable.extras::reactable_extras_dependency(),
    reactableOutput("react"),
    hr(),
    textOutput("date_text"),
    textOutput("button_text"),
    textOutput("check_text"),
    textOutput("dropdown_text"),
    textOutput("text")
  ),
  server = function(input, output) {
    output$react <- renderReactable({
      # preparing the test data
      df <- MASS::Cars93[, 1:4]
      df$Date <- sample(seq(as.Date("2020/01/01"),
                            as.Date("2023/01/01"),
                            by = "day"),
                        nrow(df))
      df$Check <- sample(c(TRUE, FALSE), nrow(df), TRUE)
      reactable(
        df,
        columns = list(
          Manufacturer = colDef(
            cell = button_extra("button", class = "button-extra")
          ),
          Check = colDef(
            cell = checkbox_extra("check", class = "checkbox-extra"),
            align = "left"
          ),
          Date = colDef(
            cell = date_extra("date", class = "date-extra")
          ),
          Type = colDef(
            cell = dropdown_extra(
              "dropdown",
              unique(df$Type),
              class = "dropdown-extra"
            )
          ),
          Model = colDef(
            cell = text_extra(
              "text"
            )
          )
        )
      )
    })
    output$date_text <- renderText({
      req(input$date)
      values <- input$date
      paste0(
        "Date: ",
        string_list(values)
      )
    })
    output$check_text <- renderText({
      req(input$check)
      values <- input$check
      paste0(
        "Check: ",
        string_list(values)
      )
    })
    output$button_text <- renderText({
      req(input$button)
      values <- input$button
      paste0(
        "Button: ",
        string_list(values)
      )
    })

    output$dropdown_text <- renderText({
      req(input$dropdown)
      values <- input$dropdown
      paste0(
        "Dropdown: ",
        string_list(values)
      )
    })

    output$text <- renderText({
      req(input$text)
      values <- input$text
      paste0(
        "Dropdown: ",
        string_list(values)
      )
    })
  }
)

```

![](./gifs/custom-inputs.gif)

Example of saving the state when changing the page:

```R
# helper function
update_table <- function(data, id, column, value, key_column = NULL) {
  if (!is.null(key_column)) {
    data[data[[key_column]] == id, column] <- value
  } else {
    data[id, column] <- value
  }
  return(data)
}

# in server.R
values <- input$text
updateReactable(
  "react",
  data = update_table(
    df,
    values$row,
    values$column,
    values$value
  )
)
```

## How to contribute?

If you want to contribute to this project please submit a regular PR, once you're done with new feature or bug fix.

Reporting a bug is also helpful - please use [GitHub issues](https://github.com/Appsilon/reactable.extras/issues) and describe your problem as detailed as possible.

## Appsilon

<img src="https://avatars0.githubusercontent.com/u/6096772" align="right" alt="" width="6%" />

Appsilon is a **Posit (formerly RStudio) Full Service Certified Partner**. Learn more
at [appsilon.com](https://appsilon.com).

Get in touch [opensource@appsilon.com](mailto:opensource@appsilon.com)

Check the [Rhinoverse](https://rhinoverse.dev).

<a href = "https://appsilon.com/careers/" target="_blank"><img src="https://raw.githubusercontent.com/Appsilon/website-cdn/gh-pages/WeAreHiring1.png" alt="We are hiring!"/></a>
