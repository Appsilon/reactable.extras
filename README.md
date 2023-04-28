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
