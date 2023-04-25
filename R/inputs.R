
#' @keywords internal
args_js <- function(...) {
  args <- rlang::list2(...)
  if (length(args) == 0){
    return("")
  }
  paste0(
    ", ",
    paste0(
      names(args), ": ", shQuote(as.character(args)), collapse = ", "
    )
  )
}


#' Button for reactable
#'
#' @param id id of the button input
#' @param ... parameters of button
#'
#' @export
button_extra <- function(id, ...) {
  htmlwidgets::JS(
    htmltools::doRenderTags(
      htmltools::htmlTemplate(
        text_ = "function(cellInfo) {
                 return React.createElement(ButtonExtras,
                 {id: '{{id}}', label: cellInfo.value {{args}}}, cellInfo.id)
      }",
      id = id,
      args = args_js(...)
      )
    )
  )
}

#' Checkbox for reactable
#'
#' @param id id of the checkbox input
#' @param ... parameters of checkbox
#'
#' @export
checkbox_extra <- function(id, ...) {
  htmlwidgets::JS(
    htmltools::doRenderTags(
      htmltools::htmlTemplate(
        text_ = "function(cellInfo) {
              return React.createElement(checkboxExtras,
              {id: '{{id}}', value: cellInfo.value {{args}}}, cellInfo.id)
      }",
      id = id,
      args = args_js(...)
      )
    )
  )
}

#' Date for reactable
#'
#' @param id id of the date input
#' @param ... parameters of date input
#'
#' @export
date_extra <- function(id, ...) {
  htmlwidgets::JS(
    htmltools::doRenderTags(
      htmltools::htmlTemplate(
        text_ = "function(cellInfo) {
              return React.createElement(dateExtras,
              {id: '{{id}}', value: cellInfo.value {{args}}}, cellInfo.id)
      }",
      id = id,
      args = args_js(...))
    )
  )
}

#' Select input for reactable
#'
#' @param id id of the select input
#' @param choices vector of choices
#'
#' @export
dropdown_extra <- function(id, choices) {
  if (length(choices) == 0) {
    choices_js <- ""
  } else {
    choices_js <- paste0(", choices: ", rjson::toJSON(choices))
  }
  htmlwidgets::JS(
    htmltools::doRenderTags(
      htmltools::htmlTemplate(
        text_ = "function(cellInfo) {
              return React.createElement(dropdownExtras,
              {id: '{{id}}', value: cellInfo.value, selectClass: 'selecting',
               optionClass: 'qwerty' {{choices}}}, cellInfo.id)
      }",
      id = id,
      choices = choices_js
    )
  ))
}
