#' Tool-tip for table headers
#'
#' @param content The content to be displayed in the tool-tip
#' @param theme The theme of the tool-tip, either "light", "light-border", "material" or
#'   "translucent"
#'
#' @examples
#' reactable::colDef(header = tooltip_extra("This is my tool-tip", theme = "material"))
#'
#' @export
tooltip_extra <- function(content, theme = "light") {
  reactable::JS(
    htmltools::doRenderTags(
      htmltools::htmlTemplate(
        text_ = "function(columnInfo) {
                 return React.createElement(TooltipExtras,
                 {column: columnInfo.name, tooltip: '{{content}}',
                 theme: '{{theme}}'})
        }",
        content = content,
        theme = theme
      )
    )
  )
}
