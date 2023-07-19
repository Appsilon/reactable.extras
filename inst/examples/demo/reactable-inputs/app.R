library(shiny)
library(reactable)
library(reactable.extras)

string_list <- function(values) {
  paste0(
    "{", paste0(names(values), " : ", unlist(values), collapse = ", "), "}"
  )
}

update_table <- function(data, id, column, value, key_column = NULL) {
  if (!is.null(key_column)) {
    data[data[[key_column]] == id, column] <- value
  } else {
    data[id, column] <- value
  }
  return(data)
}

shinyApp(
  ui = fluidPage(
    reactable.extras::reactable_extras_dependency(),
    reactableOutput("react"),
    hr(),
    textOutput("date_text"),
    textOutput("button_text"),
    textOutput("check_text"),
    textOutput("dropdown_text"),
    textOutput("text"),
    textOutput("text_on_blur")
  ),
  server = function(input, output) {
    df <- MASS::Cars93[, 1:4] |>
      dplyr::mutate(dplyr::across(where(is.factor), as.character)) |>
      dplyr::mutate(id_row = paste0("id_", dplyr::row_number()))
    df$Date <- sample(seq(as.Date("2020/01/01"),
                          as.Date("2023/01/01"),
                          by = "day"),
                      nrow(df))
    df$Check <- sample(c(TRUE, FALSE), nrow(df), TRUE)
    df$Check[2] <- FALSE


    output$react <- renderReactable({
      # preparing the test data
      reactable(
        df,
        searchable = TRUE,
        onClick = JS("(row, column) => {
                     if (!['Manufacturer','Check','Type'].includes(column.id)) {
                        console.log(column.id)
                        row.toggleRowSelected()
                     }
        }"),
        selection = "multiple",
        columns = list(
          Manufacturer = colDef(
            cell = button_extra("button", class = "button-extra")
          ),
          Check = colDef(
            cell = checkbox_extra("check", class = "checkbox-extra"),
            align = "left"
          ),
          Date = colDef(
            cell = date_extra("date", class = "date-extra")
          ),
          Type = colDef(
            cell = dropdown_extra(
              "dropdown",
              unique(df$Type),
              class = "dropdown-extra"
            )
          ),
          Model = colDef(
            cell = text_extra(
              "text",
              key = "id_row",
              class = "text-extra"
            )
          )
        )
      )
    })
    output$date_text <- renderText({
      req(input$date)
      values <- input$date
      paste0(
        "Date: ",
        string_list(values)
      )
    })
    output$check_text <- renderText({
      req(input$check)
      values <- input$check
      paste0(
        "Check: ",
        string_list(values)
      )
    })
    output$button_text <- renderText({
      req(input$button)
      values <- input$button
      paste0(
        "Button: ",
        string_list(values)
      )
    })

    output$dropdown_text <- renderText({
      req(input$dropdown)
      values <- input$dropdown

      updateReactable(
        "react",
        data = update_table(
          df,
          values$row,
          values$column,
          values$value
        )
      )

      paste0(
        "Dropdown: ",
        string_list(values)
      )
    })

    output$text <- renderText({
      req(input$text)
      values <- input$text
      updateReactable(
        "react",
        data = update_table(
          df,
          values$row,
          values$column,
          values$value,
          key_column = "id_row"
        )
      )
      paste0(
        "Text: ",
        string_list(values)
      )
    })

    output$text_on_blur <- renderText({
      req(input$text_blur)
      values <- input$text_blur
      updateReactable(
        "react",
        data = update_table(
          df,
          values$row,
          values$column,
          values$value,
          key_column = "id_row"
        )
      )
      paste0(
        "Text OnBlur: ",
        string_list(values)
      ) 
    })
  }
)
