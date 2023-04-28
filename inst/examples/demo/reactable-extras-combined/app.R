library(shiny)
library(reactable)
library(reactable.extras)

string_list <- function(values) {
  paste0(
    "{", paste0(names(values), " : ", unlist(values), collapse = ", "), "}"
  )
}

shinyApp(
  ui = fluidPage(
    reactable_extras_ui("react"),
    hr(),
    textOutput("date_text"),
    textOutput("button_text"),
    textOutput("check_text"),
    textOutput("dropdown_text"),
    textOutput("text")
  ),
  server = function(input, output) {
    # preparing the test data
    df <- MASS::Cars93[, 1:4]
    df$Date <- sample(seq(as.Date("2020/01/01"),
                          as.Date("2023/01/01"),
                          by = "day"),
                      nrow(df))
    df$Check <- sample(c(TRUE, FALSE), nrow(df), TRUE)
    df$Check[2] <- FALSE
    df$row_id <- seq(1, nrow(df), by = 1)

    reactable_extras_server(
      "react",
      df,
      total_pages = 12,
      sortable = TRUE,
      onClick = JS("(row, column) => {
                     if (!['Manufacturer','Check','Type'].includes(column.id)) {
                        console.log(column.id)
                        row.toggleRowSelected()
                     }
        }"),
      selection = "multiple",
      columns = list(
        Manufacturer = colDef(
          cell = button_extra("button", key = "row_id", class = "button-extra")
        ),
        Check = colDef(
          cell = checkbox_extra("check", key = "row_id", class = "checkbox-extra"),
          align = "left"
        ),
        Date = colDef(
          cell = date_extra("date", key = "row_id", class = "date-extra")
        ),
        Type = colDef(
          cell = dropdown_extra(
            "dropdown",
            unique(df$Type),
            key = "row_id",
            class = "dropdown-extra"
          )
        ),
        Model = colDef(
          cell = text_extra(
            "text", key = "row_id"
          )
        )
      )
    )

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
      paste0(
        "Dropdown: ",
        string_list(values)
      )
    })

    output$text <- renderText({
      req(input$text)
      values <- input$text
      paste0(
        "Dropdown: ",
        string_list(values)
      )
    })
  }
)
