#' htmlDependency of reactable server including script and styles
#'
#' @importFrom htmltools htmlDependency
#' @return An htmlDependency object
reactableExtrasDependency <- function() {
  htmltools::htmlDependency(
    "reactable-server", "0.0.1",
    src = list(file = "assets/reactable-server"), package = "reactable.extras",
    # NOTE: Updated version (v1.6.4) of bootstrap-datepicker currently not
    #   used by base shiny. This version includes content and tooltip support
    #   for the beforeShowDay function family. for more information on this
    #   see https://bootstrap-datepicker.readthedocs.io/en/latest/options.html#beforeshowday
    script = "js/reactable-server.js",
    stylesheet = "css/reactable-server.css"
  )
}
