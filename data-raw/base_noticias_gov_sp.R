## code to prepare `base_noticias_gov_sp` dataset goes here

library(magrittr)
devtools::load_all()

pagina_final <- 3 #9400

base_noticias_gov_sp <-
  1:pagina_final %>%
  # 9300:9400 %>%
  purrr::map_dfr(raspar_pagina_gov_sp) %>%
  janitor::remove_empty(which = "rows")

# raspar_pagina_gov_sp(3)
# 1:9400



usethis::use_data(base_noticias_gov_sp, overwrite = TRUE)
