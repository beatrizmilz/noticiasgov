test_that("raspar_pagina_gov_sp works", {
  # testando noticias que estao completas
  noticias_pagina_1 <- raspar_pagina_gov_sp(2)
  testthat::expect_gte(nrow(noticias_pagina_1), 10)
  testthat::expect_s3_class(noticias_pagina_1, "tbl_df")

  # testando noticias incompletas

  noticias_pagina_9300 <- raspar_pagina_gov_sp(9300)
  testthat::expect_gte(nrow(noticias_pagina_9300), 10)
  testthat::expect_s3_class(noticias_pagina_9300, "tbl_df")


  # testando paginas sem noticias
  noticias_pagina_10000 <- raspar_pagina_gov_sp(10000)
  testthat::expect_null(noticias_pagina_10000)


  # Problema com as aspas repetindo
  base_noticias_gov_sp <-
    readr::read_delim(
      "https://raw.githubusercontent.com/beatrizmilz/noticiasgov/master/inst/base_noticias_gov_sp.csv",
      delim = ";",
      escape_double = TRUE,
      col_types = readr::cols(data = readr::col_date(format = "%Y-%m-%d")),
      trim_ws = TRUE
    ) %>%
    dplyr::mutate(id = as.character(id))

  testthat::expect_snapshot(base_noticias_gov_sp[base_noticias_gov_sp$id == "5434704", "chamada"])

  testthat::expect_gte(nrow(base_noticias_gov_sp), 92900)
  testthat::expect_s3_class(base_noticias_gov_sp, "tbl_df")

})
