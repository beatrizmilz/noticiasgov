parse_item_gov_sp <- function(item_lista) {
  # id -----------------------------------

  classes_div <- item_lista %>%
    rvest::html_attr("class") %>%
    stringr::str_split(pattern = " ") %>%
    purrr::pluck(1)

  id <- classes_div[1] %>% stringr::str_remove("post-")

  categorias <- classes_div %>%
    tibble::as_tibble() %>%
    dplyr::filter(stringr::str_starts(value, "category-")) %>%
    dplyr::mutate(
      categorias = stringr::str_remove(value, "category-"),
      categorias = stringr::str_replace_all(categorias, "-", " ")
    ) %>%
    dplyr::pull(categorias) %>%
    knitr::combine_words(sep = ", ", and = "") %>%
    as.character()

  tags <- classes_div %>%
    tibble::as_tibble() %>%
    dplyr::filter(stringr::str_starts(value, "tag-")) %>%
    dplyr::mutate(
      tags = stringr::str_remove(value, "tag-"),
      tags = stringr::str_replace_all(tags, "-", " ")
    ) %>%
    dplyr::pull(tags) %>%
    knitr::combine_words(sep = ", ", and = "") %>%
    as.character()

  if (length(tags) == 0) {
    tags <- NA
  }




  # infos ---------------------------------

  classe_infos <- item_lista %>%
    rvest::html_element(xpath = './/*[@class="col-md-5 category-infos"]')

  if (is.na(classe_infos[1])) {
    classe_infos_antigas <- item_lista %>%
      rvest::html_element(xpath = './/*[@class="no-thumbnail category-infos"]')


    data_bruta <- classe_infos_antigas %>%
      rvest::html_element("span") %>%
      rvest::html_text()

    data <- data_bruta %>%
      tibble::as_tibble() %>%
      tidyr::separate(col = value,
                      into = c("data", "horario"),
                      sep = "-") %>%
      dplyr::mutate(dplyr::across(tidyselect::everything(), stringr::str_trim),
                    data = lubridate::dmy(data))


    classe_titulo <- classe_infos_antigas %>%
      rvest::html_element("h3")


    url_noticia <- classe_infos_antigas %>%
      rvest::html_element("a") %>%
      rvest::html_attr("href")


    titulo <- classe_infos_antigas %>%
      rvest::html_element("h3") %>%
      rvest::html_text()

    chamada <- classe_infos_antigas %>%
      rvest::html_element("p") %>%
      rvest::html_text()
  } else {
    data_bruta <- classe_infos %>%
      rvest::html_element("span") %>%
      #      rvest::html_element(xpath = './/*[@class="date"]') %>%
      rvest::html_text()

    data <- data_bruta %>%
      tibble::as_tibble() %>%
      tidyr::separate(col = value,
                      into = c("data", "horario"),
                      sep = "-") %>%
      dplyr::mutate(dplyr::across(tidyselect::everything(), stringr::str_trim),
                    data = lubridate::dmy(data))


    classe_titulo <- classe_infos %>%
      rvest::html_element("h3")


    url_noticia <- classe_titulo %>%
      rvest::html_element("a") %>%
      rvest::html_attr("href")


    titulo <- classe_titulo %>%
      rvest::html_text()

    chamada <- classe_infos %>%
      rvest::html_element("p") %>%
      rvest::html_text()
  }




  # thumbnail -----------------------
  classe_thumbnail <- item_lista %>%
    rvest::html_element(xpath = './/*[@class="col-md-3 category-thumbnail"]')

  if (is.na(classe_thumbnail[1])) {
    img_url <- NA
    img_alt <- NA
    url_noticia_img <- NA
  } else {
    url_noticia_img <- classe_thumbnail %>%
      rvest::html_element("a") %>%
      rvest::html_attr("href")

    img_url <- classe_thumbnail %>%
      rvest::html_element("img") %>%
      rvest::html_attr("src")

    img_alt <- classe_thumbnail %>%
      rvest::html_element("img") %>%
      rvest::html_attr("alt")
  }

  # retornar tibble ---------------

  tibble::tibble(
    id,
    data,
    url_noticia,
    titulo,
    chamada,
    categorias,
    tags,
    img_url,
    img_alt,
    url_noticia_img
  )
}


raspar_pagina_gov_sp <- function(num_pagina = 1) {
  url_pagina <-
    glue::glue("https://www.saopaulo.sp.gov.br/ultimas-noticias/page/{num_pagina}/")


  safe_rvest_read_html <-
    purrr::possibly(rvest::read_html, "pagina_nao_existe")

  html <- safe_rvest_read_html(url_pagina)

  if (html[1] != "pagina_nao_existe") {
    lista <- html %>%
      xml2::xml_find_all(xpath = '//div[contains(@class,"type-post")]')


    #  item_lista <- lista[[1]]


    usethis::ui_info("Obtendo notícias da página  {url_pagina} ...")
    lista %>%
      purrr::map_dfr(parse_item_gov_sp)
  } else {
    usethis::ui_info("A página {url_pagina} não contém notícias")
  }
}

atualizar_dados_gov_sp <- function(pag_inicial = 1,
                                   pag_final = 3) {
  base_noticias_gov_sp <-
    readr::read_delim(
      "https://raw.githubusercontent.com/beatrizmilz/noticiasgov/master/inst/base_noticias_gov_sp.csv",
      delim = ";",
      escape_double = TRUE,
      col_types = readr::cols(data = readr::col_date(format = "%Y-%m-%d")),
      trim_ws = TRUE
    ) %>%
    dplyr::mutate(id = as.character(id))


  pag_inicial:pag_final %>%
    purrr::map_dfr(raspar_pagina_gov_sp) %>%
    janitor::remove_empty(which = "rows") %>%
    dplyr::bind_rows(base_noticias_gov_sp) %>%
    dplyr::mutate(dplyr::across(
      .cols = c(titulo, chamada, categorias, img_alt),
      .fns = stringr::str_replace_all,
      ";",
      "."
    )) %>%
    dplyr::mutate(hora = lubridate::hm(horario)) %>%
    dplyr::arrange(desc(data), desc(hora)) %>%
    dplyr::select(-hora) %>%
    dplyr::distinct(id, data, horario, .keep_all = TRUE)
}


# remover_aspas_duplicadas <- function(dataset) {
#   dataset %>%
#     dplyr::mutate(
#       dplyr::across(
#         .cols = tidyselect:::where(is.character),
#         .fns = stringr::str_replace_all,
#         '""',
#         '"'
#       )
#     ) %>%
#     dplyr::mutate(
#       dplyr::across(
#         .cols = tidyselect:::where(is.character),
#         .fns = stringr::str_replace_all,
#         '\"\"',
#         '\"'
#       )
#     )
# }
