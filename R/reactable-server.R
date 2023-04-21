reactableExtrasUi <- function(inputId, width = "auto", height = "auto", inline = FALSE) {
  ns <- shiny::NS(id)

  shiny::tagList(
    reactableExtrasDependency(),
    shiny::div(
      class = "pagination-controls",
      purrr::map2(
        c("first_page", "previous_page", "next_page", "last_page"),
        c("angles-left", "angle-left", "angle-right", "angles-right"),
        ~ tagAppendAttributes(
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
      width = width, height = height, inline = inline
    )
  )
}

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

    output$page_text <- shiny::renderText({
      if (page_number() == 1) {
        session$sendCustomMessage(
          "toggleDisable",
          list(id = "#test-first_page", disable = TRUE)
        )

        session$sendCustomMessage(
          "toggleDisable",
          list(id = "#test-previous_page", disable = TRUE)
        )

        session$sendCustomMessage(
          "toggleDisable",
          list(id = "#test-next_page", disable = FALSE)
        )

        session$sendCustomMessage(
          "toggleDisable",
          list(id = "#test-last_page", disable = FALSE)
        )
      } else if (page_number() > 1 && page_number() < total_pages) {
        session$sendCustomMessage(
          "toggleDisable",
          list(id = "#test-first_page", disable = FALSE)
        )

        session$sendCustomMessage(
          "toggleDisable",
          list(id = "#test-previous_page", disable = FALSE)
        )

        session$sendCustomMessage(
          "toggleDisable",
          list(id = "#test-next_page", disable = FALSE)
        )

        session$sendCustomMessage(
          "toggleDisable",
          list(id = "#test-last_page", disable = FALSE)
        )
      } else if (page_number() == total_pages) {
        session$sendCustomMessage(
          "toggleDisable",
          list(id = "#test-first_page", disable = FALSE)
        )

        session$sendCustomMessage(
          "toggleDisable",
          list(id = "#test-previous_page", disable = FALSE)
        )

        session$sendCustomMessage(
          "toggleDisable",
          list(id = "#test-next_page", disable = TRUE)
        )

        session$sendCustomMessage(
          "toggleDisable",
          list(id = "#test-last_page", disable = TRUE)
        )
      }

      paste0(page_number(), " of ", total_pages)
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

    column_sort <- shiny::reactive({
      reactable::getReactableState("reactable", "sorted")
    })

    shiny::observe({

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

      updateReactable("reactable", data = sorted_data)
    })
  })
}
