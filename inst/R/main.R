library(tidyverse)
library(tricky)
library(rmarkdown)
library(knitr)
library(here)
auto_read_tsv <- function(file, ...) {
  .encoding <- guess_encoding(file = file) %>% slice(1) %>% pull(encoding)
  cat("Detected encoding is ... ", .encoding, "\n")
  read_tsv(file = file, locale = locale(encoding = .encoding))
}

table_depts <- auto_read_tsv(file = here("data-raw/depts2018.txt")) %>%
  set_standard_names()

table_depts %>%
  glimpse()

render_site(input = "inst/template/")

create_site_structure <- function(data, name, axis, output) {
  structure <-
    paste(
      glue("name: '{name}'\n"),
      "navbar:\n title: 'DataDown'\n left:\n  - text: 'Home'\n    href: index.html",
      "output:\n html_document:\n  theme: cosmo\n  highlight: textmate",
      sep = "\n"
    )
  cat(
    structure,
    file = paste0(output, "_site.yml")
    )
  cat(
    "---\ntitle: 'Home'\noutput: 'html_document'\n---\n\n\n##Home\n\n",
    file = paste0(output, "index.Rmd")
    )
}

create_site_structure(
  data = table_depts,
  name = "Code officiel géographique",
  axis = dep,
  output = here('inst/sandbox/')
  )
render_site(input = "inst/template/")
render_site(input = "inst/sandbox/")

build_site()

create_axis_template <- function(data, axis) {

  }
build_site()
build_axis()

# render_page <- function(index, template = "inst/template/example.Rmd") {
#   rmarkdown::render(
#     input = template,
#     params = list(axis = index),
#     output_file = paste0(here("inst/template/_site/departement_"), index, ".html")
#    )
#   }
# render_page(index = table_depts$dep[1], template = here("inst/template/template_departement.Rmd"))


# purrr::walk(.x = table_depts$dep, .f = render_page)
#
# rmarkdown::render(
#   input = "inst/template/example.Rmd",
#   params = list(axis = table_depts$dep[1]),
#   output_file = paste0("example", table_depts$dep[1], ".html")
#   )
#




