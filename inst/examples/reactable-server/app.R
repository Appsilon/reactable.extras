library(shiny)
library(reactable.extras)

mtcars_ultra <- purrr::map_dfr(
  seq(1L, 20000L, by = 1L),
  ~ mtcars |>
    tibble::rownames_to_column("make") |>
    dplyr::mutate(id_row = paste0("id_", dplyr::row_number(), "_", .x))
)

shinyApp(
  reactable_extras_ui("test"),
  function(input, output, server) {
    reactable_extras_server(
      "test",
      data = mtcars_ultra,
      columns = list(
        mpg = reactable::colDef(name = "Miles per Gallon"),
        cyl = reactable::colDef(name = "Cylinders"),
        disp = reactable::colDef(name = "Displacement")
      ),
      rows_per_page = 17
    )
  }
)
