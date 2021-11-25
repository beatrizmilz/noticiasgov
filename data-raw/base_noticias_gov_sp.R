# DEPRECATED

# ## code to prepare `base_noticias_gov_sp` dataset goes here
# library(magrittr)
#
# devtools::load_all()
#
#
# # library(furrr)
# #
# # future::plan(multisession, workers = 6)
# #
# # pagina_final <- 9350
# #
# # quebras <- seq(1, pagina_final, by = 100)
# #
# # for (posicao in 1:length(quebras)) {
# #
# #   tictoc::tic()
# #   base_parcial <-
# #     quebras[posicao]:quebras[posicao+1] %>%
# #     furrr::future_map_dfr(raspar_pagina_gov_sp) %>%
# #     janitor::remove_empty(which = "rows") %>%
# #     readr::write_rds(glue::glue("data-raw/base_parcial_{quebras[posicao]}-{quebras[posicao+1]}.Rds"))
# #   tictoc::toc()
# #   beepr::beep()
# # }
# # base_parcial_unida <- fs::dir_ls("data-raw/", regexp = ".Rds") %>%
# #   purrr::map_dfr(readr::read_rds)
# #
# #
# # base_noticias_gov_sp <- base_parcial_unida %>% dplyr::distinct()
# #
#
# usethis::use_data(base_noticias_gov_sp, overwrite = TRUE)
