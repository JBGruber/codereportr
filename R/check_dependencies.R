#' Check and Install Package Dependencies
#'
#' Extracts package dependencies from R, Rmd, or Qmd files and checks if they
#' are installed. If any dependencies are missing, prompts the user to install them.
#'
#' @param file Character string. Path to an R script (.R), R Markdown (.Rmd),
#'   or Quarto (.qmd) file from which to extract dependencies.
#' @param ... additional arguments passed on to [rlang::check_installed]
#'
#' @return Invisibly returns a character vector of package dependencies found
#'   in the file.
#'
#' @details
#' The function uses the \code{attachment} package to extract dependencies:
#' \itemize{
#'   \item For .qmd files: uses \code{attachment::att_from_qmd()}
#'   \item For .rmd files: uses \code{attachment::att_from_rmd()}
#'   \item For .r files: uses \code{attachment::att_from_rscript()}
#' }
#' After extraction, it uses \code{rlang::check_installed()} to verify all
#' dependencies are installed, which will prompt the user to install any
#' missing packages.
#'
#' @examples
#' \dontrun{
#' # Check dependencies in an R script
#' check_dependencies("analysis.R")
#'
#' # Check dependencies in a Quarto document
#' check_dependencies("report.qmd")
#'
#' # Check dependencies in an R Markdown document
#' check_dependencies("report.Rmd")
#' }
#'
#' @export
check_dependencies <- function(file, ...) {
  deps <- switch(
    tolower(tools::file_ext(file)),
    "qmd" = attachment::att_from_qmd(file),
    "rmd" = attachment::att_from_rmd(file),
    "r" = attachment::att_from_rscript(file)
  )
  rlang::check_installed(deps, ...)
  invisible(deps)
}
