on.exit(file.remove("code_report.qmd"), add = TRUE, after = FALSE)
test_that("report is created", {
  create_report(
    input_files = system.file("example_script.R", package = "codereportr"),
    output_file = "code_report.qmd",
    check_installed_dependencies = FALSE
  )
  expect_true(file.exists("code_report.qmd"))
})

test_that("multi-line strings are handled correctly", {
  temp_file <- tempfile(fileext = ".R")
  temp_output <- tempfile(fileext = ".qmd")
  on.exit(file.remove(c(temp_file, temp_output)), add = TRUE)

  code <- 'multiline <- "
  multi-
  line
  statement
  "'

  writeLines(code, temp_file)

  create_report(
    input_files = temp_file,
    output_file = temp_output,
    check_installed_dependencies = FALSE
  )
  output_lines <- readChar(temp_output, nchars = file.size(temp_output))
  expect_true(grepl(code, output_lines, fixed = TRUE))
})
