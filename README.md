
<!-- README.md is generated from README.Rmd. Please edit that file -->

# noticiasgov

<!-- badges: start -->

[![atualiza_dados](https://github.com/beatrizmilz/noticiasgov/actions/workflows/atualizar_dados.yaml/badge.svg)](https://github.com/beatrizmilz/noticiasgov/actions/workflows/atualizar_dados.yaml)

<!-- badges: end -->

O objetivo deste repositório/pacote é raspar as notícias de portais de
noticias governamentais, e disponibilizar para análise.

| Bases                                                                                                | Código para importar no R                                                                 |
|:-----------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------|
| [SP](https://raw.githubusercontent.com/beatrizmilz/noticiasgov/master/inst/base_noticias_gov_sp.csv) | `base_noticias_gov_sp <- readr::read_delim("inst/base_noticias_gov_sp.csv", delim = ";")` |
