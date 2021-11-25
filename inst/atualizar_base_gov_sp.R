# Carregar pacote
pkgload::load_all()

base_noticias_gov_sp <-
  readr::read_delim(
    "https://raw.githubusercontent.com/beatrizmilz/noticiasgov/master/inst/base_noticias_gov_sp.csv",
    delim = ";",
    escape_double = TRUE,
    col_types = readr::cols(data = readr::col_date(format = "%Y-%m-%d")),
    trim_ws = TRUE
  ) %>%
  dplyr::mutate(id = as.character(id))

# verificar como ta
base_noticias_gov_sp[base_noticias_gov_sp$id == "5434704", "chamada"]

# atualizar a base de dados
base_noticias_gov_sp_atualizada <-
  atualizar_dados_gov_sp(pag_inicial = 1, pag_final = 1) %>%
  remover_aspas_duplicadas()

# verificar como ta
base_noticias_gov_sp_atualizada[base_noticias_gov_sp_atualizada$id == "5434704", "chamada"]


# Comparar para escrever a mensagem de commit
linhas_diferenca <-
  dplyr::anti_join(base_noticias_gov_sp_atualizada,
                   base_noticias_gov_sp) %>% nrow()

commit_message <-
  paste0(
    "[GitHub Actions] Atualizando noticias. ",
    linhas_diferenca,
    " novas linhas adicionadas na base."
  )

commit_message

writeLines(commit_message, "mensagem-comit.txt")

# exportar csv
base_noticias_gov_sp_atualizada %>%
  readr::write_csv2("inst/base_noticias_gov_sp.csv")
