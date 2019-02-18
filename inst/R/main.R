library(tidyverse)
library(tricky)
library(rmarkdown)
library(knitr)
render_site(input = "inst/template/")

#
# render_page <- function(index, template = "inst/template/example.Rmd") {
#   rmarkdown::render(
#     input = template,
#     params = list(axis = index),
#     output_file = paste0("example", index, ".html")
#   )
# }
# render_page(index = table_depts$dep[1])
# purrr::walk(.x = table_depts$dep, .f = render_page)
#
# rmarkdown::render(
#   input = "inst/template/example.Rmd",
#   params = list(axis = table_depts$dep[1]),
#   output_file = paste0("example", table_depts$dep[1], ".html")
#   )
#
