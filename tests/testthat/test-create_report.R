on.exit(file.remove("code_report.qmd"), add = TRUE, after = FALSE)
test_that("report is created", {
  create_report(
    input_files = system.file("example_script.R", package = "codereportr"),
    output_file = "code_report.qmd"
  )
  expect_true(file.exists("code_report.qmd"))
})
