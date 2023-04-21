toggle_navigation_buttons <- function(disable, session = shiny::getDefaultReactiveDomain()) {
  ns <- session$ns

  purrr::walk(
    paste0(c("first", "previous", "next", "last"), "_page"),
    ~ session$sendCustomMessage(
      "toggleDisable",
      list(id = paste0("#", ns(.x)), disable = disable[[.x]])
    )
  )
}

#' Create reactable UI with server-side processing
#'
#' @param id element id
#' @param width,height CSS unit (`"100%"`, `"400px"`, or `"auto"`), numeric for number of pixels
#' @param data passed to [reactable::reactable()]
#' @param rows_per_page number of pages to show
#' @param sortable allow sorting by columns
#' @param ... other arguments to be passed to [reactable::reactable()]
#'
#' @name reactable-extras-server
#'
#' @return `reactableExtrasUi()` returns a custom UI for a server-side processed reactable
#' @export
reactableExtrasUi <- function(id, width = "auto", height = "auto") {
  ns <- shiny::NS(id)

  shiny::tagList(
    reactableExtrasDependency(),
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
    ),
    reactable::reactableOutput(
      outputId = ns("reactable"),
      width = width, height = height, inline = FALSE
    )
  )
}

#' @rdname reactable-extras-server
#' @export
reactableExtrasServer <- function(id, data, rows_per_page = 10, sortable = TRUE, ...) {
  moduleServer(id, function(input, output, session) {
    page_number <- reactiveVal(1)

    total_pages <- nrow(data) %/% rows_per_page + 1

    paged_data <-
      data |>
      dplyr::mutate(page = ceiling(dplyr::row_number() / rows_per_page))

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
      shiny::req(page_number() > min(paged_data$page))
      page_number(page_number() - 1)
    })

    output$reactable <- reactable::renderReactable({
      reactable::reactable(
        paged_data |>
          dplyr::filter(page == 1) |>
          dplyr::select(-page),
        pagination = FALSE,
        sortable = sortable,
        ...
      )
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

      column_sort <- shiny::reactive({
        reactable::getReactableState("reactable", "sorted")
      })

      selected_data <- paged_data |>
        dplyr::filter(page == page_number()) |>
        dplyr::select(-page)

      if (is.null(column_sort())) {
        sorted_data <- selected_data
      } else {
        if (column_sort()[[1]] == "asc") {
          sorted_data <- dplyr::arrange(data, dplyr::across(names(column_sort())))
        } else if (column_sort()[[1]] == "desc") {
          sorted_data <- dplyr::arrange(data, dplyr::across(names(column_sort()), dplyr::desc))
        }

        sorted_data <-
          sorted_data |>
          dplyr::mutate(page = ceiling(dplyr::row_number() / rows_per_page)) |>
          dplyr::filter(page == page_number()) |>
          dplyr::select(-page)
      }

      reactable::updateReactable("reactable", data = sorted_data)
    })
  })
}
