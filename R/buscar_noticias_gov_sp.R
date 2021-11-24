parse_item_gov_sp <- function(item_lista) {
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
      tidyr::separate(
        col = value,
        into = c("data", "horario"),
        sep = "-"
      ) %>%
      dplyr::mutate(dplyr::across(tidyselect::everything(), stringr::str_trim),
        data = lubridate::dmy(data)
      )


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
      tidyr::separate(
        col = value,
        into = c("data", "horario"),
        sep = "-"
      ) %>%
      dplyr::mutate(dplyr::across(tidyselect::everything(), stringr::str_trim),
        data = lubridate::dmy(data)
      )


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
    data,
    url_noticia,
    titulo,
    chamada,
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
      xml2::xml_find_all(xpath = '//*[@class="col-md-8 category-post-list"]')


    lista %>%
      purrr::map_dfr(parse_item_gov_sp)

    #  item_lista <- lista[[1]]
  } else {
    usethis::ui_info("A página {url_pagina} não contém notícias")
  }
}
