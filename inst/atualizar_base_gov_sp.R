# Carregar pacote
pkgload::load_all()

# Buscar a base atual (para comparar depois)
base_noticias_gov_sp <-
  readr::read_delim(
    "https://raw.githubusercontent.com/beatrizmilz/noticiasgov/master/inst/base_noticias_gov_sp.csv",
    delim = ";",
    escape_double = TRUE,
    col_types = readr::cols(data = readr::col_date(format = "%Y-%m-%d")),
    trim_ws = TRUE
  ) %>%
  dplyr::mutate(id = as.character(id))


# atualizar a base de dados
base_noticias_gov_sp_atualizada <-
  atualizar_dados_gov_sp(pag_inicial = 1, pag_final = 1)

# Comparar para escrever a mensagem de commit
linhas_diferenca <-
  dplyr::anti_join(base_noticias_gov_sp_atualizada,
                   base_noticias_gov_sp) %>% nrow()

# escrever a mensagem de commit
commit_message <-
  paste0(
    "[GitHub Actions] Atualizando noticias. ",
    linhas_diferenca,
    " novas linhas adicionadas na base."
  )

# salvar a mensagem de commit
writeLines(commit_message, "mensagem-comit.txt")

# exportar csv
base_noticias_gov_sp_atualizada %>%
  readr::write_csv2("inst/base_noticias_gov_sp.csv")
