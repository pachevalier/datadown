library(tidyverse)
library(tricky)
library(rmarkdown)
library(knitr)
library(here)
library(glue)
library(stringr)
library(rlang)
render_site(input = "inst/template/")
auto_read_tsv <- function(file, ...) {
  .encoding <- guess_encoding(file = file) %>% slice(1) %>% pull(encoding)
  cat("Detected encoding is ... ", .encoding, "\n")
  read_tsv(file = file, locale = locale(encoding = .encoding))
}
table_depts <- auto_read_tsv(file = here("data-raw/depts2018.txt")) %>%
  set_standard_names()
table_depts %>%
  glimpse()

listify <- function(tbl, axis) {
  prefix <- quo_name(quo = enquo(axis))
  purrr::map(
    .x = distinct(.data = tbl, !!enquo(axis)) %>% pull(!!enquo(axis)),
    .f = function(x) {list(text = x, href = paste0(prefix, x, ".html"))}
    )
}
listify(tbl = table_depts, axis = dep) %>%
  yaml::as.yaml()

create_site_structure_yaml <- function(tbl, axis, name, output) {
  axe_slug <- quo_name(quo = enquo(axis))
  axe_title <- str_to_title(quo_name(quo = enquo(axis)))
  list(
    name = name,
    navbar = list(
      title = "DataDown",
      left = list(
        list(
          text = "Home",
          href = "index.html"),
        list(
          text = axe_title,
          href = paste0(axe_slug, ".html"),
          menu = listify(tbl = tbl, axis = !!enquo(axis))
      )
    ),
    output = list(
      html_document = list(
        theme = "cosmo",
        highlight = "textmate"
        )
      )
    )
  ) %>%
  yaml::write_yaml(file = file.path(output, "_site.yml"))
  }

create_site_structure_yaml(
  tbl = table_depts,
  axis = dep,
  name = "Datadown",
  output = here("inst/sandbox/")
  )

build_homepage <- function(tbl, output) {
  cat("---",
      yaml::as.yaml(list(title = 'Home', output = 'html_document')),
      "---",
      "\n\n## Glimpse\n\n",
      "```{r echo=FALSE, message=FALSE}\ntable_depts %>%\nglimpse()\n```",
      sep = "\n",
    file = paste0(output, "index.Rmd")
    )
}
build_homepage(tbl = table_depts, output = here("inst/sandbox/"))

#
# build_axis_template <- function(tbl, axis, output) {
# #  expression <- quo_name(table_depts %>% filter(!!enquo(axis) == enquo(params$axis)))
#   cat("---",
#       yaml::as.yaml(list(title = 'Home', output = 'html_document', params = list(axis = ""))),
#       "---",
#       "\n\n## Glimpse\n\n",
#       paste0("```{r echo=FALSE, message=FALSE}\n", expression, "\n\n```"),
#       sep = "\n",
#       file = paste0(output, "axis_template.Rmd")
#   )
# }
# build_axis_template(tbl = table_depts, output = here("inst/sandbox/"))

render_site(input = "inst/sandbox/")

# create_axis_template <- function(data, axis)
# build_site()
# build_axis()

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

