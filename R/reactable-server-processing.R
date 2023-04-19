reactable_output <- function(inputId, width, height, inline) {
  shiny::tagList(
    shiny::actionButton(
      inputId = paste0(inputId, "-first_page"),
      icon = shiny::icon("angles-left"), label = ""
    ),
    shiny::actionButton(
      inputId = paste0(inputId, "-previous_page"),
      icon = shiny::icon("angle-left"), label = ""
    ),
    shiny::actionButton(
      inputId = paste0(inputId, "-next_page"),
      icon = shiny::icon("angle-right"), label = ""
    ),
    shiny::actionButton(
      inputId = paste0(inputId, "-last_page"),
      icon = shiny::icon("angles-right"), label = ""
    ),
    shiny::textOutput(
      outputId = paste0(inputId, "-page_text")
    ),
    reactable::reactableOutput(
      outputId = inputId,
      width = width, height = height, inline = inline
    )
  )
}
