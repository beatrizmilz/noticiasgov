## code to prepare `base_noticias_gov_sp` dataset goes here

library(magrittr)
devtools::load_all()

# # testando noticias que estao completas
# raspar_pagina_gov_sp(3) %>% View()
#
# # testando noticias incompletas
# raspar_pagina_gov_sp(9300) %>% View()
#
# # testando paginas sem noticias
# raspar_pagina_gov_sp(10000)



pagina_final <- 9350

base_noticias_gov_sp <-
  1:pagina_final %>%
  purrr::map_dfr(raspar_pagina_gov_sp) %>%
  janitor::remove_empty(which = "rows")




usethis::use_data(base_noticias_gov_sp, overwrite = TRUE)
