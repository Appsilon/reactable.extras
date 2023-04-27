library(shiny)
library(reactable)
library(reactable.extras)

mtcars_ultra <- purrr::map(
  seq(1L, 2000L, by = 1L),
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
