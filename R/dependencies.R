
#' Reactable.extras JS and CSS dependencies
#'
#' @return HTML dependency object.
#'
#' @export
reactable_extras_dependency <- function() {
  htmltools::htmlDependency(
    name = "reactable.extras",
    version = "0.0.1",
    src = list(file = "assets"),
    package = "reactable.extras",
    script = c("js/reactable-extras.js", "js/reactable-server.js"),
    stylesheet = "css/reactable-server.css"
  )
}
