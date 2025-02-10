#' Utility function to disable or re-enable navigation buttons
#'
#' @param disable a named logical vector
#' @param session Shiny session object; default to current Shiny session
#'
#' @details `disable` should a logical vector with these exact names: `first_page`, `previous_page`,
#'   `next_page`, and `last_page`. The logical vectors indicate if the corresponding button will be
#'   enabled or disabled.
#' @keywords internal
#'
toggle_navigation_buttons <- function(disable, session = shiny::getDefaultReactiveDomain()) {
  button_ids <- paste0(c("first", "previous", "next", "last"), "_page")

  checkmate::assert(
    checkmate::check_logical(
      disable,
      any.missing = FALSE,
      all.missing = FALSE,
      len = 4L
    ),
    checkmate::check_subset(
      names(disable),
      choices = button_ids,
      empty.ok = FALSE
    )
  )

  checkmate::assert(
    checkmate::check_r6(session, "ShinySession"),
    checkmate::check_class(session, "session_proxy"),
    .combine = "or"
  )

  ns <- session$ns # nolint: object_usage_linter

  purrr::walk(
    button_ids,
    ~ session$sendCustomMessage(
      "toggleDisable",
      list(id = paste0("#", ns(.x)), disable = disable[[.x]])
    )
  )
}

#' Module for reactable page navigation
#'
#' @param id element id
#' @param total_pages total number of pages
#'
#' @name reactable-page-controls
#'
#' @return `reactable_page_controls()` returns a UI for page navigation of a server-side processed
#'   [reactable::reactable()] data
#' @keywords internal
reactable_page_controls <- function(id) {
  checkmate::assert_character(id, len = 1)

  ns <- shiny::NS(id)

  shiny::div(
    class = "pagination-controls",
    purrr::map2(
      c("first_page", "previous_page", "next_page", "last_page"),
      c("angles-left", "angle-left", "angle-right", "angles-right"),
      ~ shiny::tagAppendAttributes(
        class = "pagination-button",
        shiny::actionButton(
          inputId = ns(.x),
          icon = shiny::icon(.y), label = ""
        )
      )
    ),
    shiny::div(
      class = "pagination-text",
      shiny::textOutput(
        outputId = ns("page_text"),
        inline = TRUE
      )
    )
  )
}

#' @rdname reactable-page-controls
return_reactable_page <- function(id, total_pages) {
  checkmate::assert(
    checkmate::check_character(id, len = 1),
    checkmate::check_integerish(total_pages, len = 1),
    combine = "and"
  )

  shiny::moduleServer(id, function(input, output, session) {
    page_number <- shiny::reactiveVal(1)

    shiny::observeEvent(input$first_page, {
      page_number(1)
    })

    shiny::observeEvent(input$last_page, {
      page_number(total_pages)
    })

    shiny::observeEvent(input$next_page, {
      shiny::req(page_number() < total_pages)
      page_number(page_number() + 1)
    })

    shiny::observeEvent(input$previous_page, {
      shiny::req(page_number() > 1)
      page_number(page_number() - 1)
    })

    shiny::observe({
      output$page_text <- shiny::renderText({
        if (page_number() == 1) {
          toggle_navigation_buttons(
            c(
              first_page = TRUE,
              previous_page = TRUE,
              next_page = FALSE,
              last_page = FALSE
            )
          )
        } else if (page_number() > 1 && page_number() < total_pages) {
          toggle_navigation_buttons(
            c(
              first_page = FALSE,
              previous_page = FALSE,
              next_page = FALSE,
              last_page = FALSE
            )
          )
        } else if (page_number() == total_pages) {
          toggle_navigation_buttons(
            c(
              first_page = FALSE,
              previous_page = FALSE,
              next_page = TRUE,
              last_page = TRUE
            )
          )
        }

        paste0(page_number(), " of ", total_pages)
      })
    })

    return(page_number)
  })
}

#' Get the data on the page
#'
#' @param data data.frame without pages; pagination will be inferred
#' @param page_number page of data to retrieve
#' @param total_pages number of pages in `data`; determines pagination when the data has no pages
#'
#' @return a data.frame
#' @keywords internal
get_data_on_page <- function(data, page_number, total_pages) {
  checkmate::assert(
    checkmate::check_data_frame(data),
    checkmate::check_integerish(page_number, len = 1),
    checkmate::check_integerish(total_pages, len = 1),
    combine = "and"
  )

  if (page_number > total_pages)
    stop("page_number must be less than or equal to total_pages")

  rows_per_page <- ceiling(nrow(data) / total_pages)

  data |>
    dplyr::mutate(reactable_data_page = ceiling(dplyr::row_number() / rows_per_page)) |>
    # Using page here will trigger a fail in R CMD CHECK
    # because there is no global variable binding
    # for page. This is a common problem using dplyr.
    dplyr::filter(dplyr::if_any("reactable_data_page", ~ .x == page_number)) |>
    dplyr::select(!dplyr::any_of("reactable_data_page"))
}

#' [Deprecated] Create reactable UI with server-side processing
#'
#' @param id element id
#' @param width,height CSS unit (`"100%"`, `"400px"`, or `"auto"`), numeric for number of pixels
#' @param data passed to [reactable::reactable()]
#' @param total_pages number of pages
#' @param sortable allow sorting by columns
#' @param ... other arguments to be passed to [reactable::reactable()]
#'
#' @details
#' Arguments passed to [reactable::reactable()] must not contain `pagination` or `showPagination`.
#' These are set to `FALSE`. Pagination will be handled on the server-side.
#'
#'
#' @name reactable-extras-server
#'
#' @return `reactable_extras_ui()` returns a custom UI for a server-side processed reactable
#' @export
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(reactable)
#'   library(reactable.extras)
#'
#'   shinyApp(
#'     reactable_extras_ui("big_data"),
#'     function(input, output, server) {
#'       reactable_extras_server(
#'         "big_data",
#'         data = mtcars,
#'         columns = list(
#'           mpg = reactable::colDef(name = "Miles per Gallon"),
#'           cyl = reactable::colDef(name = "Cylinders"),
#'           disp = reactable::colDef(name = "Displacement")
#'         )
#'       )
#'     }
#'   )
#' }
reactable_extras_ui <- function(id, width = "auto", height = "auto") {
  .Deprecated(
    new = "reactable::reactable",
    msg = "`reactable::reactable` now has a `server = TRUE` argument. Please use 'reactable' directly instead of this module."
  )

  checkmate::assert_character(id, len = 1)

  ns <- shiny::NS(id)

  shiny::tagList(
    reactable_extras_dependency(),
    reactable_page_controls(ns("page_controls")),
    reactable::reactableOutput(
      outputId = ns("reactable"),
      width = width, height = height, inline = FALSE
    )
  )
}

hide_internal_uuid <- function(args) {
  if (is.null(args$columns)) {
    args$columns <- list()
  }
  args$columns[[".internal_uuid"]] <- reactable::colDef(show = FALSE)
  return(args)
}

sort_table <- function(data, column_name, direction) {
  column_name <- rlang::sym(column_name)
  if (direction == "asc") {
    data |>
      dplyr::arrange(!!column_name)
  } else if (direction == "desc") {
    data |>
      dplyr::arrange(dplyr::desc(!!column_name))
  }
}

#' @rdname reactable-extras-server
#' @export
reactable_extras_server <- function(id, data, total_pages = 4, sortable = TRUE, ...) {

  data <- as.data.frame(data, stringsAsFactors = TRUE) |>
    dplyr::mutate(.internal_uuid = dplyr::row_number())

  # Create and clean-up reactable arguments
  reactable_args <- hide_internal_uuid(list(...))

  checkmate::assert(
    checkmate::check_character(id, len = 1),
    checkmate::check_data_frame(data),
    checkmate::check_integerish(total_pages, len = 1),
    # Check if arguments can be passed to reactable
    checkmate::check_subset(
      names(reactable_args),
      names(formals(reactable::reactable)),
      empty.ok = TRUE
    ),
    combine = "and"
  )

  # Server-side processing handles pagination, so reactable should not show it
  reactable_args$pagination <- FALSE
  reactable_args$showPagination <- FALSE
  reactable_args$sortable <- sortable

  reactable_data <- shiny::reactiveVal(NULL)

  shiny::moduleServer(id, function(input, output, session) {
    reactable_args$data <-
      get_data_on_page(data, 1, total_pages = total_pages)

    output$reactable <- reactable::renderReactable({
      do.call(reactable::reactable, args = reactable_args)
    })

    column_sort <- shiny::reactive({
      reactable::getReactableState("reactable", "sorted")
    })

    page_number <- # nolint: object_usage_linter
      return_reactable_page(id = "page_controls", total_pages = total_pages)

    shiny::observe({
      if (is.null(column_sort())) {
        data |>
          get_data_on_page(page_number = page_number(), total_pages = total_pages) |>
          reactable_data()
      } else {
        column_name <- rlang::sym(names(column_sort()))
        data |>
          get_data_on_page(page_number = page_number(), total_pages = total_pages) |>
          sort_table(column_name = column_name, direction = column_sort()[[1]]) |>
          reactable_data()
      }

      reactable::updateReactable("reactable", data = reactable_data())
    })
  })
}
