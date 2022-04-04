
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
| SP     | [Portal do Governo do Estado de São Paulo](https://www.saopaulo.sp.gov.br/ultimas-noticias/) | A cada 6 horas       | [`.csv`](https://raw.githubusercontent.com/beatrizmilz/noticiasgov/master/inst/base_noticias_gov_sp.csv) | `base_noticias_gov_sp <- readr::read_delim("https://raw.githubusercontent.com/beatrizmilz/noticiasgov/master/inst/base_noticias_gov_sp.csv", delim = ";")` |

## Exemplo dos dados disponíveis

``` r
base_noticias_gov_sp <- readr::read_delim("https://raw.githubusercontent.com/beatrizmilz/noticiasgov/master/inst/base_noticias_gov_sp.csv", delim = ";")

dplyr::glimpse(base_noticias_gov_sp)
#> Rows: 93,537
#> Columns: 11
#> $ id              <dbl> 5501054, 5500984, 5500968, 5500980, 5500954, 5500930, …
#> $ data            <date> 2022-04-04, 2022-04-04, 2022-04-04, 2022-04-04, 2022-…
#> $ horario         <chr> "14h22", "12h40", "12h14", "12h08", "11h53", "10h25", …
#> $ url_noticia     <chr> "https://www.saopaulo.sp.gov.br/spnoticias/governo-de-…
#> $ titulo          <chr> "Governo de SP anuncia R$ 33 milhões para obras de inf…
#> $ chamada         <chr> "Serão beneficiados 15 municípios com recursos estadua…
#> $ categorias      <chr> "comunicacao, desenvolvimento, gestao, infraestrutura,…
#> $ tags            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ img_url         <chr> "https://www.saopaulo.sp.gov.br/wp-content/uploads/202…
#> $ img_alt         <chr> "Governo de SP anuncia R$ 33 milhões para obras de inf…
#> $ url_noticia_img <chr> "https://www.saopaulo.sp.gov.br/spnoticias/governo-de-…
```

Pesquisar as notícias que contém algum termo ao longo do tempo:

``` r
library(ggplot2)

noticias_sp_filtradas <- base_noticias_gov_sp %>%
  dplyr::mutate(titulo_clean = stringr::str_to_lower(titulo),
                titulo_clean = abjutils::rm_accent(titulo_clean)) %>% 
  dplyr::filter(
      stringr::str_detect(titulo_clean, "rio pinheiros")
  )

noticias_sp_filtradas |> 
  dplyr::mutate(titulo_url = glue::glue("[{titulo}]({url_noticia})")) |> 
    dplyr::select(data, titulo_url) |> 
  knitr::kable()
```

| data       | titulo_url                                                                                                                                                                                                                                               |
|:-----------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 2022-03-24 | [Governo inicia as obras de revitalização da Usina São Paulo no Rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/governo-inicia-as-obras-de-revitalizacao-da-usina-sao-paulo-no-rio-pinheiros/)                                                  |
| 2022-03-24 | [Novo Rio Pinheiros: 85% das águas já têm mais oxigênio e menos poluição](https://www.saopaulo.sp.gov.br/spnoticias/novo-rio-pinheiros-85-das-aguas-ja-tem-mais-oxigenio-e-menos-poluicao/)                                                              |
| 2022-03-22 | [Novo Rio Pinheiros: Sabesp ultrapassa 100% de imóveis conectados à rede](https://www.saopaulo.sp.gov.br/spnoticias/novo-rio-pinheiros-sabesp-ultrapassa-100-de-imoveis-conectados-a-rede/)                                                              |
| 2021-12-18 | [Governo de SP entrega sonorização e 3ª fase de iluminação da Ciclovia Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/doria-entrega-sistema-de-sonorizacao-e-terceira-fase-de-iluminacao-da-ciclovia-rio-pinh-2/)                        |
| 2021-07-31 | [Governo de SP entrega segunda fase da iluminação na Ciclovia Novo Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/governo-de-sp-entrega-segunda-fase-da-iluminacao-na-ciclovia-novo-rio-pinheiros/)                                      |
| 2021-07-11 | [Ponte da Sabesp no rio Pinheiros ganha grafite em alerta sobre água](https://www.saopaulo.sp.gov.br/spnoticias/orgaos-governamentais/secretaria-de-saneamento-e-recursos-hidricos/ponte-da-sabesp-no-rio-pinheiros-ganha-grafite-em-alerta-sobre-agua/) |
| 2021-06-13 | [Governo de São Paulo inicia obras no Parque Bruno Covas – Novo Rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/governo-de-sao-paulo-inicia-obras-no-parque-bruno-covas-novo-rio-pinheiros/)                                                    |
| 2021-05-19 | [Governo de SP capta US$ 100 milhões para despoluição do rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/governo-de-sp-capta-us-100-milhoes-para-despoluicao-do-rio-pinheiros-2/)                                                               |
| 2021-05-07 | [Governo de SP e Enel instalam iluminação inteligente na Ciclovia Novo Rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/governo-de-sp-e-enel-instalam-iluminacao-inteligente-na-ciclovia-novo-rio-pinheiros/)                                    |
| 2021-01-27 | [Rio Pinheiros ganhará novo parque linear com equipamentos de esporte e lazer](https://www.saopaulo.sp.gov.br/spnoticias/rio-pinheiros-ganhara-novo-parque-linear-com-equipamentos-de-esporte-e-lazer-2/)                                                |
| 2020-12-11 | [Sabesp obtém financiamento do BID Invest para Novo Rio Pinheiros e energia sustentável](https://www.saopaulo.sp.gov.br/ultimas-noticias/sabesp-obtem-financiamento-do-bid-invest-para-novo-rio-pinheiros-e-energia-sustentavel/)                        |
| 2020-11-12 | [Governo de SP assina contrato de concessão da Usina São Paulo, no Rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/governo-de-sp-assina-contrato-de-concessao-da-usina-sao-paulo-no-rio-pinheiros-2/)                                           |
| 2020-09-15 | [EMAE executa ações de limpeza no Rio Pinheiros, em combate aos pernilongos](https://www.saopaulo.sp.gov.br/ultimas-noticias/emae-executa-acoes-de-limpeza-no-rio-pinheiros-em-combate-aos-pernilongos/)                                                 |
| 2020-09-10 | [Desenvolve SP investe R$ 70 milhões em obra do Novo Rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/desenvolve-sp-investe-r-70-milhoes-em-obra-do-novo-rio-pinheiros/)                                                                         |
| 2020-07-15 | [Governo do Estado assina últimos contratos para sanear Bacia do Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/governo-do-estado-assina-ultimos-contratos-para-sanear-bacia-do-rio-pinheiros/)                                          |
| 2020-05-15 | [Governo de SP assina mais 6 contratos do Novo Rio Pinheiros e gera 2,5 mil empregos](https://www.saopaulo.sp.gov.br/spnoticias/governo-de-sp-assina-mais-6-contratos-do-novo-rio-pinheiros-e-gera-25-mil-empregos/)                                     |
| 2020-03-02 | [CPTM firma parceria para gestão da Ciclofaixa Rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/cptm-firma-parceria-para-gestao-da-ciclofaixa-rio-pinheiros/)                                                                                    |
| 2020-02-22 | [Novo Rio Pinheiros é tema de debate em reunião do Conselho Estadual do Meio Ambiente](https://www.saopaulo.sp.gov.br/ultimas-noticias/novo-rio-pinheiros-e-tema-de-debate-em-reuniao-do-conselho-estadual-de-meio-ambiente/)                            |
| 2020-02-13 | [Ciclofaixa Rio Pinheiros: trecho é interditado entre Vila Olímpia e Villa-Lobos Jaguaré](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclofaixa-rio-pinheiros-trecho-e-interditado-entre-vila-olimpia-e-villa-lobos-jaguare/)                       |
| 2020-01-25 | [Painéis convidam paulistano a participar da despoluição do Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/saneamento/paineis-convidam-paulistano-a-participar-da-despoluicao-do-rio-pinheiros/)                                         |
| 2020-01-20 | [Governo de SP retira 9 mil toneladas de resíduos do Rio Pinheiros em 2019](https://www.saopaulo.sp.gov.br/ultimas-noticias/governo-de-sp-retira-9-mil-toneladas-de-residuos-do-rio-pinheiros-em-2019/)                                                  |
| 2020-01-19 | [Visitantes do MIS Experience deixam mensagens para o Rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/visitantes-do-mis-experience-deixam-mensagens-para-o-rio-pinheiros/)                                                                      |
| 2020-01-07 | [Desenvolve SP vai financiar projetos de despoluição do Rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/desenvolve-sp-vai-financiar-projetos-de-despoluicao-do-rio-pinheiros/)                                                                  |
| 2020-01-03 | [Liberado trecho da Ciclofaixa Rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/liberado-trecho-da-ciclofaixa-rio-pinheiros/)                                                                                                                    |
| 2019-12-10 | [Trecho da Ciclofaixa Rio Pinheiros é reaberto ao público](https://www.saopaulo.sp.gov.br/spnoticias/trecho-da-ciclofaixa-rio-pinheiros-e-reaberto-ao-publico/)                                                                                          |
| 2019-10-25 | [Obras da Emae interditam trecho da Ciclofaixa Rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/obras-da-emae-interditam-trecho-da-ciclofaixa-rio-pinheiros/)                                                                                    |
| 2019-09-26 | [Objetivo do Novo Rio Pinheiros é revitalizar símbolo da capital](https://www.saopaulo.sp.gov.br/spnoticias/multimidia/infograficos/objetivo-do-novo-rio-pinheiros-e-revitalizar-simbolo-da-capital/)                                                    |
| 2019-08-16 | [Governo de SP investe R$ 1,5 bilhão para despoluir bacia do Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/governo-anuncia-pacote-de-obras-para-projeto-do-novo-rio-pinheiros/)                                                         |
| 2019-07-12 | [Rio Pinheiros: desassoreamento recebe aporte de R$ 70 mi](https://www.saopaulo.sp.gov.br/spnoticias/governo-paulista-anuncia-novas-medidas-de-seguranca-e-acoes-para-o-rio-pinheiros/)                                                                  |
| 2019-06-05 | [Governo inicia testes com ecobarcos para coleta de lixo no rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/governo-inicia-testes-com-ecobarcos-para-coleta-de-lixo-no-rio-pinheiros-2/)                                                        |
| 2019-06-05 | [Governo de SP inicia testes com ecobarcos no rio Pinheiros](https://www.saopaulo.sp.gov.br/spnoticias/governo-de-sp-inicia-testes-com-ecobarcos-no-rio-pinheiros/)                                                                                      |
| 2019-03-19 | [Ciclofaixa Rio Pinheiros aumenta o número de ciclistas no espaço urbano](https://www.saopaulo.sp.gov.br/spnoticias/ciclofaixa-rio-pinheiros-aumenta-o-numero-de-ciclistas-no-espaco-urbano/)                                                            |
| 2019-03-15 | [Ciclofaixa Rio Pinheiros recebe passeio ciclístico SP by Bike](https://www.saopaulo.sp.gov.br/spnoticias/ciclofaixa-rio-pinheiros-recebe-passeio-ciclistico-sp-by-bike/)                                                                                |
| 2019-01-28 | [Aumenta o número de ciclistas na Ciclofaixa Rio Pinheiros da CPTM](https://www.saopaulo.sp.gov.br/spnoticias/aumenta-o-numero-de-ciclistas-na-ciclofaixa-rio-pinheiros-da-cptm/)                                                                        |
| 2019-01-11 | [Ciclofaixa Rio Pinheiros recebe 7° Passeio Ciclístico](https://www.saopaulo.sp.gov.br/spnoticias/ciclofaixa-rio-pinheiros-recebe-7-passeio-ciclistico/)                                                                                                 |
| 2018-12-27 | [‘Pomar Urbano’ promove revitalização do canal do Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/projeto-pomar-urbano-promove-revitalizacao-do-canal-do-rio-pinheiros/)                                                                  |
| 2018-04-05 | [Ciclovia Rio Pinheiros: alternativa para lazer e deslocamento diário](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-alternativa-para-lazer-e-deslocamento-diario/)                                                             |
| 2018-01-10 | [Ciclovia Rio Pinheiros recebeu em 2017 mais de 470 mil ciclistas](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-recebeu-em-2017-mais-de-470-mil-ciclistas/)                                                                    |
| 2017-03-16 | [Com obras concluídas, trecho da ciclovia Rio Pinheiros é liberado](https://www.saopaulo.sp.gov.br/spnoticias/trecho-de-pinheiros-da-ciclovia-rio-pinheiros-e-liberada-apos-obras/)                                                                      |
| 2016-10-18 | [Ciclovia às margens do Rio Pinheiros tem horário ampliado](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-as-margens-do-rio-pinheiros-tem-horario-ampliado/)                                                                                  |
| 2016-04-19 | [Trecho em obras da ciclovia Rio Pinheiros será liberado em maio](https://www.saopaulo.sp.gov.br/ultimas-noticias/trecho-em-obras-da-ciclovia-rio-pinheiros-sera-liberado-em-maio/)                                                                      |
| 2014-12-06 | [Passeio ciclístico inaugura galeria de arte da Ciclovia Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/passeio-ciclistico-inaugura-galeria-de-arte-da-ciclovia-rio-pinheiros/)                                                          |
| 2014-12-05 | [Passeio ciclístico inaugura galeria de arte da Ciclovia Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/passeio-ciclistico-inaugura-galeria-de-arte-da-ciclovia-rio-pinheiros-1/)                                                        |
| 2014-12-01 | [Ciclovia Rio Pinheiros terá trecho interditado por causa de obras](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-tera-trecho-interditado-por-causa-de-obras/)                                                                  |
| 2013-12-23 | [Aproveite horário ampliado da ciclovia do Rio Pinheiros durante o Horário de Verão](https://www.saopaulo.sp.gov.br/ultimas-noticias/aproveite-horario-ampliado-da-ciclovia-do-rio-pinheiros-durante-o-horario-de-verao/)                                |
| 2013-12-17 | [Ponte e nova ciclovia no Rio Pinheiros facilitam acesso à estação Santo Amaro](https://www.saopaulo.sp.gov.br/ultimas-noticias/ponte-e-nova-ciclovia-no-rio-pinheiros-facilitam-acesso-a-estacao-santo-amaro-1/)                                        |
| 2013-11-07 | [Conheça alternativa à ciclovia do Rio Pinheiros durante obras da Linha 17-Ouro do Metrô](https://www.saopaulo.sp.gov.br/ultimas-noticias/conheca-alternativa-a-ciclovia-do-rio-pinheiros-durante-obras-da-linha-17-ouro-do-metro/)                      |
| 2013-10-26 | [Ciclovia Rio Pinheiros funciona 1h30 a mais no horário de verão](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-funciona-1h30-a-mais-no-horario-de-verao/)                                                                      |
| 2013-10-24 | [Ciclovia Rio Pinheiros funciona 1h30 a mais no horário de verão](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-funciona-1h30-a-mais-no-horario-de-verao-1/)                                                                    |
| 2013-10-20 | [Ciclistas ganham 1h30 a mais na ciclovia Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclistas-ganham-1h30-a-mais-na-ciclovia-rio-pinheiros/)                                                                                        |
| 2013-10-05 | [Desde 2010 quase um milhão de usuários já passaram pela Ciclovia Rio Pinheiros da CPTM](https://www.saopaulo.sp.gov.br/ultimas-noticias/desde-2010-quase-um-milhao-de-usuarios-ja-passaram-pela-ciclovia-rio-pinheiros-da-cptm/)                        |
| 2013-10-04 | [Governo recebe cicloativistas para discutir interdição da Ciclovia Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/governo-recebe-cicloativistas-para-discutir-interdicao-da-ciclovia-rio-pinheiros-1/)                                  |
| 2013-10-02 | [SP suspende interdição da Ciclovia Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/sp-suspende-interdicao-da-ciclovia-rio-pinheiros/)                                                                                                    |
| 2013-10-01 | [(PENDENTE)Ciclovia do Rio Pinheiros será parcialmente interditada para obras do Metrô](https://www.saopaulo.sp.gov.br/ultimas-noticias/pendente-ciclovia-do-rio-pinheiros-sera-parcialmente-interditada-para-obras-do-metro/)                           |
| 2013-09-23 | [Ciclovia Rio Pinheiros da CPTM é alternativa saudável para o deslocamento diário na capital](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-da-cptm-e-alternativa-saudavel-para-o-deslocamento-diario-na-capital/)              |
| 2013-06-29 | [Ciclovia Rio Pinheiros reabre neste domingo](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-reabre-neste-domingo/)                                                                                                              |
| 2013-06-28 | [Ciclovia Rio Pinheiros será reaberta domingo](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-sera-reaberta-domingo/)                                                                                                            |
| 2013-05-26 | [Desde 2010 quase um milhão de usuários já passaram pela Ciclovia Rio Pinheiros da CPTM](https://www.saopaulo.sp.gov.br/ultimas-noticias/desde-2010-quase-um-milhao-de-usuarios-ja-passaram-pela-ciclovia-rio-pinheiros-da-cptm-1/)                      |
| 2013-05-06 | [Ciclovia do Rio Pinheiros tem funcionamento ampliado](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-do-rio-pinheiros-tem-funcionamento-ampliado/)                                                                                            |
| 2013-05-01 | [Ciclovia do Rio Pinheiros tem horário ampliado](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-do-rio-pinheiros-tem-horario-ampliado/)                                                                                                        |
| 2013-04-30 | [Horário da ciclovia do Rio Pinheiros é ampliado](https://www.saopaulo.sp.gov.br/ultimas-noticias/horario-da-ciclovia-do-rio-pinheiros-e-ampliado/)                                                                                                      |
| 2012-11-05 | [Horário da Ciclovia Rio Pinheiros da CPTM é ampliado](https://www.saopaulo.sp.gov.br/ultimas-noticias/horario-da-ciclovia-rio-pinheiros-da-cptm-e-ampliado/)                                                                                            |
| 2012-10-24 | [Obras de modernização interditam trecho da ciclovia Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/obras-de-modernizacao-interditam-trecho-da-ciclovia-rio-pinheiros/)                                                                  |
| 2012-10-23 | [Horário da ciclovia Rio Pinheiros é ampliado](https://www.saopaulo.sp.gov.br/ultimas-noticias/horario-da-ciclovia-rio-pinheiros-e-ampliado/)                                                                                                            |
| 2012-09-23 | [Muro da ciclovia do Rio Pinheiros recebe arte em grafite neste domingo](https://www.saopaulo.sp.gov.br/ultimas-noticias/muro-da-ciclovia-do-rio-pinheiros-recebe-arte-em-grafite-neste-domingo/)                                                        |
| 2012-09-18 | [Governador visita obras do esgotamento sanitário do rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/governador-visita-obras-do-esgotamento-sanitario-do-rio-pinheiros-1/)                                                                |
| 2012-08-26 | [Ciclovia do Rio Pinheiros é a maior da capital](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-do-rio-pinheiros-e-a-maior-da-capital/)                                                                                                        |
| 2012-02-10 | [Estado entrega mais 4,8km da ciclovia Rio Pinheiros da CPTM](https://www.saopaulo.sp.gov.br/ultimas-noticias/estado-entrega-mais-4-8km-da-ciclovia-rio-pinheiros-da-cptm-1/)                                                                            |
| 2011-08-04 | [Ciclovia Rio Pinheiros da CPTM ganhará mais 6,4 km](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-da-cptm-ganhara-mais-6-4-km/)                                                                                                |
| 2011-06-01 | [Alckmin discursa em anuncio de obras de desassoreamento do Rio Pinheiros](https://www.saopaulo.sp.gov.br/discursos/alckmin-discursa-em-anuncio-de-obras-de-desassoreamento-do-rio-pinheiros/)                                                           |
| 2011-06-01 | [Alckmin inicia obras de desassoreamento do Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/alckmin-inicia-obras-de-desassoreamento-do-rio-pinheiros-1/)                                                                                  |
| 2011-03-05 | [Ciclovia Rio Pinheiros da CPTM completa um ano com a marca de 200 mil ciclistas](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-da-cptm-completa-um-ano-com-a-marca-de-200-mil-ciclistas/)                                      |
| 2010-09-02 | [Ciclovia Rio Pinheiros é boa opção para passear no feriado](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-e-boa-opcao-para-passear-no-feriado/)                                                                                |
| 2010-05-06 | [Ciclovia Rio Pinheiros é aprovada por quase 100% dos usuários](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-e-aprovada-por-quase-100-dos-usuarios/)                                                                           |
| 2010-04-01 | [Ciclovia Rio Pinheiros ganha acesso junto à estação Jurubatuba](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-ganha-acesso-junto-a-estacao-jurubatuba/)                                                                        |
| 2010-03-24 | [Intervenção às margens do Rio Pinheiros provoca reflexão durante Semana da Água](https://www.saopaulo.sp.gov.br/ultimas-noticias/intervencao-as-margens-do-rio-pinheiros-provoca-reflexao-durante-semana-da-agua/)                                      |
| 2010-03-08 | [Ciclovia Rio Pinheiros da CPTM recebe mais de 3 mil ciclistas no domingo](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-da-cptm-recebe-mais-de-3-mil-ciclistas-no-domingo/)                                                    |
| 2010-03-05 | [Ciclovia Rio Pinheiros ganhará acesso junto à Ponte Estaiada](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-ganhara-acesso-junto-a-ponte-estaiada/)                                                                            |
| 2010-03-04 | [Ciclovia Rio Pinheiros amplia horário de operação em março](https://www.saopaulo.sp.gov.br/ultimas-noticias/ciclovia-rio-pinheiros-amplia-horario-de-operacao-em-marco/)                                                                                |
| 2010-03-02 | [Governo anuncia dois novos acessos à Ciclovia Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/governo-anuncia-dois-novos-acessos-a-ciclovia-rio-pinheiros/)                                                                              |
| 2010-02-27 | [Serra entrega primeiro trecho da Ciclovia Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/serra-entrega-primeiro-trecho-da-ciclovia-rio-pinheiros-1/)                                                                                    |
| 2010-02-26 | [CPTM inaugura primeiro trecho da Ciclovia Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/cptm-inaugura-primeiro-trecho-da-ciclovia-rio-pinheiros/)                                                                                      |
| 2008-10-15 | [Pomar Urbano do Meio Ambiente atrai fauna para o rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/pomar-urbano-do-meio-ambiente-atrai-fauna-para-o-rio-pinheiros/)                                                                        |
| 2008-02-24 | [Rio Pinheiros pode voltar a ter peixe em 2011, calcula governo](https://www.saopaulo.sp.gov.br/spnoticias/na-imprensa/rio-pinheiros-pode-voltar-a-ter-peixe-em-2011-calcula-governo/)                                                                   |
| 2006-06-13 | [Meio Ambiente: Ipês roxos florescem na Marginal do Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/meio-ambiente-ipes-roxos-florescem-na-marginal-do-rio-pinheiros/)                                                                     |
| 2001-06-12 | [Despoluição do Rio Pinheiros vai gerar mais energia](https://www.saopaulo.sp.gov.br/ultimas-noticias/despoluicao-do-rio-pinheiros-vai-gerar-mais-energia/)                                                                                              |
| 2001-06-06 | [Meio Ambiente: Marginal do rio Pinheiros ganha mudas de palmeiras imperiais](https://www.saopaulo.sp.gov.br/ultimas-noticias/meio-ambiente-marginal-do-rio-pinheiros-ganha-mudas-de-palmeiras-imperiais/)                                               |
| 2001-03-22 | [Despoluição do Rio Pinheiros é tema do Dia Mundial da Água](https://www.saopaulo.sp.gov.br/ultimas-noticias/despoluicao-do-rio-pinheiros-e-tema-do-dia-mundial-da-agua/)                                                                                |
| 2001-03-21 | [Despoluição do Rio Pinheiros é tema do Dia Mundial da Água](https://www.saopaulo.sp.gov.br/ultimas-noticias/despoluicao-do-rio-pinheiros-e-tema-do-dia-mundial-da-agua-1/)                                                                              |
| 2001-02-23 | [Margem direita do Rio Pinheiros terá árvores de grande porte](https://www.saopaulo.sp.gov.br/ultimas-noticias/margem-direita-do-rio-pinheiros-tera-arvores-de-grande-porte/)                                                                            |
| 2001-02-23 | [(Flash) – Alckmin presta atendimento médico durante cerimônia no Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/flash-alckmin-presta-atendimento-medico-durante-cerimonia-no-rio-pinheiros/)                                            |
| 2001-02-01 | [Governo do Estado lança projeto para despoluir o rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/governo-do-estado-lanca-projeto-para-despoluir-o-rio-pinheiros/)                                                                        |
| 2001-02-01 | [(Flash) – Primeira audiência pública da licitação para despoluição do Rio Pinheiros será no próximo](https://www.saopaulo.sp.gov.br/ultimas-noticias/flash-primeira-audiencia-publica-da-licitacao-para-despoluicao-do-rio-pinheiros-sera-no-proximo/)  |
| 2001-02-01 | [(Flash) – Operação de despoluição do Rio Pinheiros deve começar em junho](https://www.saopaulo.sp.gov.br/ultimas-noticias/flash-operacao-de-despoluicao-do-rio-pinheiros-deve-comecar-em-junho/)                                                        |
| 2001-02-01 | [Governo do Estado anuncia Projeto de Despoluição do Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/governo-do-estado-anuncia-projeto-de-despoluicao-do-rio-pinheiros/)                                                                  |
| 2001-01-31 | [Governo do Estado anuncia Projeto de Despoluição do Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/governo-do-estado-anuncia-projeto-de-despoluicao-do-rio-pinheiros-1/)                                                                |
| 2001-01-30 | [Alckmin anuncia Projeto de Despoluição do Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/alckmin-anuncia-projeto-de-despoluicao-do-rio-pinheiros/)                                                                                      |
| 2001-01-23 | [Governo paulista vai adotar sistema de flotação no Projeto de Despoluição do Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/governo-paulista-vai-adotar-sistema-de-flotacao-no-projeto-de-despoluicao-do-rio-pinheiros/)                |
| 2000-10-06 | [Meio Ambiente: Projeto Pomar ensina aos estudantes ações voltadas à recuperação do Rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/meio-ambiente-projeto-pomar-ensina-aos-estudantes-acoes-voltadas-a-recuperacao-do-rio-pinheiros/)     |
| 2000-09-12 | [Projeto Pomar revitaliza mais um trecho da marginal do rio Pinheiros](https://www.saopaulo.sp.gov.br/ultimas-noticias/projeto-pomar-revitaliza-mais-um-trecho-da-marginal-do-rio-pinheiros/)                                                            |
