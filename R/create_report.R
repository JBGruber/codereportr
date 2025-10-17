#' Convert R Script(s) to Quarto Document
#'
#' Extracts runnable code chunks from one or multiple R scripts and writes them to a Quarto file.
#' A runnable chunk is defined as a complete expression that RStudio would execute
#' when running line-by-line (e.g., complete function calls, assignments, or statements).
#'
#' @param input_files path to the input R script
#' @param output_file path to the output Quarto file (default: input file with .qmd extension)
#' @param title Title for the Quarto document (default: filename)
#' @param template a qmd template containing placeholeders for  title, input_files, and code
#'
#' @return Invisible NULL; writes Quarto file as side effect
#' @export
#'
#' @examples
#' \dontrun{
#'   create_report("my_script.R", "output.qmd")
#' }
create_report <- function(
  input_files,
  output_file = "code_report.qmd",
  title = "Code Report",
  template = system.file("template.qmd", package = "codereportr")
) {
  if (!all(file.exists(input_files))) {
    cli::cli_abort("Input file {.path {input_files}} does not exist.")
  }
  if (!is.character(output_file) || length(output_file) != 1L) {
    cli::cli_abort("{.code output_file} needs to be a file name of length 1.")
  }
  if (!dir.exists(dirname(output_file))) {
    cli::cli_abort(
      "Output folder {.path {dirname(output_file)}} does not exist."
    )
  }

  # Read the R script
  script_lines <- lapply(input_files, function(f) readLines(f, warn = FALSE)) |>
    unlist()

  # Extract runnable chunks
  chunks <- extract_runnable_chunks(script_lines)

  # Write to Quarto file
  write_quarto_file(chunks, input_files, output_file, title, template)

  cli::cli_alert_success(
    "Successfully converted {input_files} to {output_file}"
  )
  invisible(output_file)
}


extract_runnable_chunks <- function(lines) {
  if (length(lines) == 0) {
    return(list())
  }

  chunks <- list()
  current_chunk <- character(0)

  for (i in seq_along(lines)) {
    line <- lines[i]
    if (nchar(trimws(line)) == 0 && length(current_chunk) == 0) {
      next
    }
    current_chunk <- c(current_chunk, line)
    # Check if we have a complete expression
    statement_len <- tryCatch(
      expr = {
        paste(current_chunk, collapse = "\n") |>
          parse(text = _, keep.source = FALSE) |>
          length()
      },
      warning = function(w) {},
      error = function(e) {
        !grepl("unexpected end of input", e$message, ignore.case = TRUE)
      }
    )

    # If complete, save chunk and start new one
    if (statement_len > 0) {
      chunks[[length(chunks) + 1]] <- current_chunk
      current_chunk <- character(0)
    }
  }
  return(chunks)
}


write_quarto_file <- function(
  chunks,
  input_files,
  output_file,
  title,
  template
) {
  code <- lapply(chunks, function(x) {
    paste(c("```{r}", x, "```"), collapse = "\n")
  }) |>
    paste(collapse = "\n\n")

  input_files <- paste0("- ", input_files, collapse = "\n")

  out_lines <- readLines(template) |>
    sub(
      pattern = "{{TITLE}}",
      replacement = title,
      x = _,
      fixed = TRUE
    ) |>
    sub(
      pattern = "{{INPUT_FILES}}",
      replacement = input_files,
      x = _,
      fixed = TRUE
    ) |>
    sub(
      pattern = "{{CODE}}",
      replacement = code,
      x = _,
      fixed = TRUE
    )
  writeLines(out_lines, output_file)

  invisible(NULL)
}