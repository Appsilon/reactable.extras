library(shiny)
library(reactable.extras)

shinyApp(
  reactableExtrasUi("test"),
  function(input, output, server) {
    reactableExtrasServer(
      "test",
      data = tibble::rownames_to_column(mtcars, var = "make"),
      columns = list(
        mpg = reactable::colDef(name = "Miles per Gallon"),
        cyl = reactable::colDef(name = "Cylinders"),
        disp = reactable::colDef(name = "Displacement")
      ),
      rows_per_page = 6
    )
  }
)
