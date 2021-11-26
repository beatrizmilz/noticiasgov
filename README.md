
<!-- README.md is generated from README.Rmd. Please edit that file -->

# noticiasgov

<!-- badges: start -->

[![atualiza_dados](https://github.com/beatrizmilz/noticiasgov/actions/workflows/atualizar_dados.yaml/badge.svg)](https://github.com/beatrizmilz/noticiasgov/actions/workflows/atualizar_dados.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

O objetivo deste repositório/pacote é raspar as notícias de portais de
noticias governamentais, e disponibilizar em `.csv`.

| Estado | Fonte                                                                                        | Freq. de atualização | Baixar base                                                                                              | Código para importar no R                                                                                                                                  |
|:-------|:---------------------------------------------------------------------------------------------|:---------------------|:---------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| SP     | [Portal do Governo do Estado de São Paulo](https://www.saopaulo.sp.gov.br/ultimas-noticias/) | A cada hora          | [`.csv`](https://raw.githubusercontent.com/beatrizmilz/noticiasgov/master/inst/base_noticias_gov_sp.csv) | `base_noticias_gov_sp <- readr::read_delim("https://raw.githubusercontent.com/beatrizmilz/noticiasgov/master/inst/base_noticias_gov_sp.csv", delim = ";")` |

## Exemplo dos dados disponíveis

``` r
base_noticias_gov_sp <- readr::read_delim("https://raw.githubusercontent.com/beatrizmilz/noticiasgov/master/inst/base_noticias_gov_sp.csv", delim = ";")

dplyr::glimpse(base_noticias_gov_sp)
#> Rows: 92,949
#> Columns: 11
#> $ id              <dbl> 5456390, 5456332, 5456332, 5456325, 5456309, 5456267, …
#> $ data            <date> 2021-11-26, 2021-11-25, 2021-11-25, 2021-11-25, 2021-…
#> $ horario         <chr> "8h47", "18h27", "18h07", "17h02", "16h14", "16h03", "…
#> $ url_noticia     <chr> "https://www.saopaulo.sp.gov.br/ultimas-noticias/fapes…
#> $ titulo          <chr> "FAPESP, GSK e Butantan renovam parceria para descober…
#> $ chamada         <chr> "Parceria público-privada foi prorrogada por mais cinc…
#> $ categorias      <chr> "ciencia e tecnologia, fapesp, saude, secretaria de de…
#> $ tags            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ img_url         <chr> "https://www.saopaulo.sp.gov.br/wp-content/uploads/202…
#> $ img_alt         <chr> "FAPESP, GSK e Butantan renovam parceria para descober…
#> $ url_noticia_img <chr> "https://www.saopaulo.sp.gov.br/ultimas-noticias/fapes…
```

Pesquisar a quantidade de notícias que contém algum termo ao longo do
tempo:

``` r
library(ggplot2)

noticias_sp_filtradas <- base_noticias_gov_sp %>%
  dplyr::mutate(titulo_clean = stringr::str_to_lower(titulo),
                titulo_clean = abjutils::rm_accent(titulo_clean)) %>% 
  dplyr::filter(
    stringr::str_detect(categorias, "coronavirus") |
      stringr::str_detect(titulo_clean, "covid-19|coronavirus|covid 19")
  )


noticias_sp_filtradas %>%
  dplyr::mutate(mes = lubridate::floor_date(data, unit = "month")) %>%
  dplyr::count(mes) %>%
  ggplot() +
  geom_col(aes(x = mes, y = n), fill = "gray") +
  scale_x_date(date_labels = "%m/%y", date_breaks = "2 months") +
  labs(y = "Quantidade de notícias", x = "Mês/ano", title = "Número de notícias por mês",
       subtitle = "Notícias publicadas na categoria 'coronavirus', \nou que tem no título alguma das seguintes palavras:  \nCoronavírus, COVID-19, Covid 19") +
  theme_minimal()
```

<img src="man/figures/README-grafico-sp-covid-noticias-1.png" width="100%" />
