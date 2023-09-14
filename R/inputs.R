
#' @keywords internal
args_js <- function(...) {
  args <- rlang::list2(...)

  if (!is.null(args$class))
    args$className <- args$class

  if (length(args) == 0) {
    return("")
  }
  paste0(
    ", ",
    paste0(
      names(args), ": ", "'", as.character(args), "'", collapse = ", "
    )
  )
}

#' Define the unique id to use when passing values to shiny
#'
#' @keywords internal
define_key <- function(key) {
  if (!is.null(key)) {
    key <- paste0("cellInfo.row.", key)
  } else {
    key <- paste(
      "cellInfo.row['.internal_uuid'] ?",
      "cellInfo.row['.internal_uuid'] :",
      "(Number(cellInfo.id) + 1)"
    )
  }

  return(key)
}


#' Button input for reactable column cell
#'
#' @param id id of the button input
#' @param key alternative unique id for server side processing
#' @param ... parameters of button, only `class` is supported for now
#'
#' @examples
#' reactable::colDef(cell = button_extra("click", class = "table-button"))
#'
#'
#' @export
button_extra <- function(id, key = NULL, ...) {
  key <- define_key(key)
  reactable::JS(
    htmltools::doRenderTags(
      htmltools::htmlTemplate(
        text_ = "function(cellInfo) {
                 return React.createElement(ButtonExtras,
                 {id: '{{id}}', label: cellInfo.value,
                  uuid: {{key}}, column: cellInfo.column.id {{args}}}, cellInfo.id)
        }",
        id = id,
        key = key,
        args = args_js(...)
      )
    )
  )
}

#' Checkbox input for reactable column cell
#'
#' @param id id of the checkbox input
#' @param key alternative unique id for server side processing
#' @param ... parameters of checkbox, only `class` is supported for now
#'
#' @examples
#' reactable::colDef(cell = checkbox_extra("check", class = "table-check"))
#'
#' @export
checkbox_extra <- function(id, key = NULL, ...) {
  key <- define_key(key)
  reactable::JS(
    htmltools::doRenderTags(
      htmltools::htmlTemplate(
        text_ = "function(cellInfo) {
              return React.createElement(checkboxExtras,
              {id: '{{id}}', value: cellInfo.value, uuid: {{key}},
               column: cellInfo.column.id {{args}}}, cellInfo.id)
        }",
        id = id,
        key = key,
        args = args_js(...)
      )
    )
  )
}

#' Date input for reactable column cell
#'
#' @param id id of the date input
#' @param key alternative unique id for server side processing
#' @param ... parameters of date input, only `class` is supported for now
#'
#' @examples
#' reactable::colDef(cell = date_extra("date", class = "table-date"))
#'
#' @export
date_extra <- function(id, key = NULL, ...) {
  key <- define_key(key)
  reactable::JS(
    htmltools::doRenderTags(
      htmltools::htmlTemplate(
        text_ = "function(cellInfo) {
              return React.createElement(dateExtras,
              {id: '{{id}}', value: cellInfo.value, uuid: {{key}},
               column: cellInfo.column.id {{args}}}, cellInfo.id)
        }",
        id = id,
        key = key,
        args = args_js(...)
      )
    )
  )
}

#' Numeric input for reactable column cell
#'
#' @param id id of the input
#' @param key alternative unique id for server side processing
#' @param ... parameters of numeric input, only `class` is supported for now
#'
#' @examples
#' reactable::colDef(cell = number_extra("date", class = "table-number"))
#'
#' @export
number_extra <- function(id, key = NULL, ...) {
  key <- define_key(key)
  reactable::JS(
    htmltools::doRenderTags(
      htmltools::htmlTemplate(
        text_ = "function(cellInfo) {
              return React.createElement(numberExtras,
              {id: '{{id}}', value: cellInfo.value, uuid: {{key}},
               column: cellInfo.column.id {{args}}}, cellInfo.id)
      }",
      id = id,
      key = key,
      args = args_js(...))
    )
  )
}

#' Select input for reactable column cell
#'
#' @param id id of the select input
#' @param choices vector of choices
#' @param key alternative unique id for server side processing
#' @param ... parameters of date input, only `class` is supported for now
#'
#' @examples
#' reactable::colDef(
#'   cell = dropdown_extra("dropdown",
#'   choices = letters[1:5],
#'   class = "table-dropdown"
#'   )
#'  )
#'
#' @export
dropdown_extra <- function(id, choices, key = NULL, ...) {
  if (length(choices) == 0) {
    choices_js <- ""
  } else {
    choices_js <- paste0(", choices: ", rjson::toJSON(choices))
  }

  key <- define_key(key)

  reactable::JS(
    htmltools::doRenderTags(
      htmltools::htmlTemplate(
        text_ = "function(cellInfo) {
              return React.createElement(dropdownExtras,
              {id: '{{id}}', value: cellInfo.value,
               uuid: {{key}}, column: cellInfo.column.id {{args}} {{choices}}}, cellInfo.id)
        }",
        id = id,
        key = key,
        choices = choices_js,
        args = args_js(...)
      )
    )
  )
}

#' Text input for reactable column cell
#'
#' @param id id of the text input
#' @param ... parameters of text input, only `class` is supported for now
#' @param key alternative unique id for server side processing
#'
#' @examples
#' reactable::colDef(cell = text_extra("text", class = "table-text"))
#'
#' @export
text_extra <- function(id, key = NULL, ...) {
  key <- define_key(key)

  reactable::JS(
    htmltools::doRenderTags(
      htmltools::htmlTemplate(
        text_ = "function(cellInfo) {
              return React.createElement(textExtras,
              {id: '{{id}}', value: cellInfo.value, uuid: {{key}},
               column: cellInfo.column.id {{args}}}, cellInfo.id)
        }",
        id = id,
        key = key,
        args = args_js(...)
      )
    )
  )
}
