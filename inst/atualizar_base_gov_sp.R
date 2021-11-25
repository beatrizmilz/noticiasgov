# Carregar pacote
pkgload::load_all()

# atualizar a base de dados
base_noticias_gov_sp <-
  atualizar_dados_gov_sp(pag_inicial = 1, pag_final = 2)

# exportar csv
base_noticias_gov_sp %>%
  readr::write_csv2("inst/base_noticias_gov_sp.csv")



