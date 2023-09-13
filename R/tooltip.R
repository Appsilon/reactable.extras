#' Tooltip for table headers
#'
#' @param content The content to be displayed in the tooltip
#' @param theme The theme of the tooltip, either "light", "light-border", "material" or
#'   "translucent"
#'
#' @examples
#' reactable::colDef(header = tooltip_extra("This is my tooltip", theme = "material"))
#'
#' @export
tooltip_extra <- function(content, theme = "light") {
  reactable::JS(
    htmltools::doRenderTags(
      htmltools::htmlTemplate(
        text_ = "function(columnInfo) {
                 return React.createElement(TooltipExtras,
                 {column: columnInfo.name, tooltip: '{{content}}',
                 theme: '{{theme}}', {{args}}})
        }",
        content = content,
        theme = theme
      )
    )
  )
}
