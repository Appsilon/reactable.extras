
#' htmlDependency of reactable server including script and styles
#'
#' @importFrom htmltools htmlDependency
#' @return An htmlDependency object
reactable_extras_dependency <- function() {
  htmltools::htmlDependency(
    "reactable-server", "0.0.1",
    src = list(file = "assets"), package = "reactable.extras",
    script = "js/reactable-server.js",
    stylesheet = "css/reactable-server.css"
  )
}
#' Shiny Fluent JS dependency
#'
#' @return HTML dependency object.
#'
#' @export
reactableExtrasDependency <- function() {
  htmltools::htmlDependency(
    name = "reactable.extras",
    version = "0.0.1",
    package = "reactable.extras",
    src = "www",
    script = "reactable-extras.js"
  )
}
