# Carregar pacote
pkgload::load_all()

base_noticias_gov_sp <-
  readr::read_delim(
    "inst/base_noticias_gov_sp.csv",
    delim = ";",
    escape_double = FALSE,
    col_types = readr::cols(data = readr::col_date(format = "%Y-%m-%d")),
    trim_ws = TRUE
  ) %>%
  dplyr::mutate(id = as.character(id))

# atualizar a base de dados
base_noticias_gov_sp_atualizada <-
  atualizar_dados_gov_sp(pag_inicial = 1, pag_final = 2) %>%
  remover_aspas_duplicadas() %>%
  remover_aspas_duplicadas() %>%
  remover_aspas_duplicadas() %>%
  remover_aspas_duplicadas() %>%
  remover_aspas_duplicadas()



# Comparar com Waldo para escrever a mensagem de commit
waldo_diferenca <-
  waldo::compare(base_noticias_gov_sp[1:500,], base_noticias_gov_sp_atualizada[1:500,])

frase_waldo <-
  glue::glue("O Waldo encontrou {length(waldo_diferenca)} diferenças!") %>% as.character()

commit_message <-
  paste0("Atualiza noticias [GitHub Actions]. ", frase_waldo)

writeLines(commit_message, "mensagem-comit.txt")

# exportar csv
base_noticias_gov_sp_atualizada %>%
  readr::write_csv2("inst/base_noticias_gov_sp.csv")
