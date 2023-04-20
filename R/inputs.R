#' Button for reactable
#'
#' @param id id of the button input
#'
#' @export
button_extra <- function(id) {
  htmlwidgets::JS(
    glue::glue(
      "function(cellInfo) {
                 return React.createElement(ButtonExtras,
                 {id: '{{id}}', label: cellInfo.value}, cellInfo.id)
    }",
    .open = "{{",
    .close = "}}"
    )
  )
}

#' Checkbox for reactable
#'
#' @param id id of the checkbox input
#'
#' @export
checkbox_extra <- function(id) {
  htmlwidgets::JS(
    glue::glue(
      "function(cellInfo) {
              return React.createElement(checkboxExtras,
              {id: '{{id}}', value: cellInfo.value}, cellInfo.id)
  }",
  .open = "{{",
  .close = "}}"
    )
  )
}

#' Date for reactable
#'
#' @param id id of the date input
#'
#' @export
date_extra <- function(id) {
  htmlwidgets::JS(
    glue::glue(
      "function(cellInfo) {
              return React.createElement(dateExtras,
              {id: '{{id}}', value: cellInfo.value}, cellInfo.id)
  }",
  .open = "{{",
  .close = "}}"
    )
  )
}
