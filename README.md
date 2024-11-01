# reactable.extras <a href="https://appsilon.github.io/reactable.extras/"><img src="man/figures/logo.png" align="right" alt="reactable.extras logo" style="height: 140px;"></a>

> _Extra features for reactable package_

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/reactable.extras)](https://cran.r-project.org/package=reactable.extras)
[![R-CMD-check](https://github.com/Appsilon/reactable.extras/workflows/R-CMD-check/badge.svg)](https://github.com/Appsilon/reactable.extras/actions/workflows/main.yml)
![Codecov test coverage](https://codecov.io/gh/Appsilon/reactable.extras/branch/main/graph/badge.svg)
<!-- badges: end -->

`reactable.extras` is an R package that enhances the functionality of the [reactable](https://glin.github.io/reactable/) package in Shiny applications. Reactable tables are interactive customizable, and `reactable.extras` extend their capabilities, allowing you to create dynamic and interactive data tables with ease.

In the context of web apps, you often need to provide users with additional tools and interactivity for data exploration. `reactable.extras` address this need by offering a set of functions and components that can be seamlessly integrated into your Shiny apps.

## How to install?

Stable version:

```r
install.packages("reactable.extras")
```

Development version:

```r
remotes::install_github("Appsilon/reactable.extras")
```

## How to use it?

Getting started with `reactable.extras` is straightforward:

1. Make sure you have latest version of `{reactable}`. It's required to be at least on version 0.4.0
2. Include the necessary functions and components in your Shiny UI definition.
3. Use the provided functions to enhance your reactable tables. You can add custom buttons, checkboxes, date pickers, dropdowns, and text inputs to your table cells.
4. Customize the behavior and appearance of these input components based on your application's requirements.
5. Implement server-side processing and pagination controls for large datasets.

```r
library(shiny)
library(reactable)
library(reactable.extras)

data <- data.frame(
  ID = 1:1000,
  SKU_Number = paste0("SKU ", 1:1000),
  Actions = rep(c("Updated", "Initialized"), times = 20),
  Registered = as.Date("2023/1/1")
)

ui <- fluidPage(
  # Include reactable.extras in your UI
  reactable_extras_dependency(),
  reactableOutput("my_table")
)

server <- function(input, output, session) {
  output$my_table <- renderReactable({
    # Create a reactable table with enhanced features
    reactable(
      data,
      columns = list(
        ID = colDef(name = "ID"),
        SKU_Number = colDef(name = "SKU_Number"),
        Actions = colDef(
          name = "Actions",
          cell = button_extra("button", class = "btn btn-primary")
        ),
        Registered = colDef(
          cell = date_extra("Registered", class = "date-extra")
        )
      )
    )
  })

  observeEvent(input$button, {
    showModal(modalDialog(
      title = "Selected row data",
      reactable(data[input$button$row, ])
    ))
  })

}

shinyApp(ui, server)

```

## How to contribute?

If you want to contribute to this project please submit a regular PR, once you're done with new feature or bug fix.

Reporting a bug is also helpful - please use [GitHub issues](https://github.com/Appsilon/reactable.extras/issues) and describe your problem as detailed as possible.

## Appsilon

<img src="https://avatars0.githubusercontent.com/u/6096772" align="right" alt="" width="6%" />

Appsilon is a **Posit (formerly RStudio) Full Service Certified Partner**.<br/>
Learn more at [appsilon.com](https://www.appsilon.com/).

Get in touch [opensource@appsilon.com](mailto:opensource@appsilon.com)

Explore the [Rhinoverse](https://www.appsilon.com/rhinoverse) - a family of R packages built around [Rhino](https://appsilon.github.io/rhino/)!

<a href = "https://appsilon.us16.list-manage.com/subscribe?u=c042d7c0dbf57c5c6f8b54598&id=870d5bfc05" target="_blank">
  <img src="https://raw.githubusercontent.com/Appsilon/website-cdn/gh-pages/shiny_weekly_light.jpg" alt="Subscribe for Shiny tutorials, exclusive articles, R/Shiny community events, and more."/>
</a>
