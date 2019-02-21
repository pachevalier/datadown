
#' listify()
#'
#' @param tbl a tibble
#' @param axis a column
#'
#' @return a list
#' @export
#'
#' @examples
#' listify(tbl = table_depts, axis = dep) %>%
#' yaml::as.yaml()

listify <- function(tbl, axis) {
  prefix <- rlang::quo_name(quo = rlang::enquo(axis))
  purrr::map(
    .x = dplyr::distinct(.data = tbl, !!rlang::enquo(axis)) %>% dplyr::pull(!!rlang::enquo(axis)),
    .f = function(x) {list(text = x, href = paste0(prefix, x, ".html"))}
  )
}
