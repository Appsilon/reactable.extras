#' htmlDependency of reactable server including script and styles
#'
#' @importFrom htmltools htmlDependency
#' @return An htmlDependency object
reactableExtrasDependency <- function() {
  htmltools::htmlDependency(
    "reactable-server", "0.0.1",
    src = list(file = "assets/reactable-server"), package = "reactable.extras",
    script = "js/reactable-server.js",
    stylesheet = "css/reactable-server.css"
  )
}
