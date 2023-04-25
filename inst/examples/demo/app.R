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
    reactable.extras::reactable_extras_dependency(),
    reactableOutput("react"),
    hr(),
    textOutput("date_text"),
    textOutput("button_text"),
    textOutput("check_text"),
    textOutput("dropdown_text")
  ),
  server = function(input, output) {
    output$react <- renderReactable({
      # preparing the test data
      df <- MASS::Cars93[1:8, 1:4]
      df$Date <- sample(seq(as.Date("2020/01/01"),
                            as.Date("2023/01/01"),
                            by = "day"),
                        8)
      df$Check <- sample(c(TRUE, FALSE), 8, TRUE)

      reactable(
        df,
        searchable = TRUE,
        columns = list(
          Manufacturer = colDef(
            cell = button_extra("button", className = "extra-button")
          ),
          Check = colDef(
            cell = checkbox_extra("check"),
            align = "left"
          ),
          Date = colDef(
            cell = date_extra("date")
          ),
          Type = colDef(
            cell = dropdown_extra("dropdown", c("qwe", "rty", "yui"))
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
      paste0(
        "Dropdown: ",
        string_list(values)
      )
    })
  }
)
