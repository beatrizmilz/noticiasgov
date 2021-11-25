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
})
