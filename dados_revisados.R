#pacotes
library(tidyverse)

#arquivo
dados_rev <- read.table("cartao_bolsonaro2019.csv",
                    sep=",",dec=".",
                    header=TRUE,
                    fileEncoding = "latin1")

#nomes
names(dados_rev) <- colnames(dados_rev) %>% 
  str_to_lower() %>% 
  str_replace_all(pattern="\\.",replacement = "_")

#corrigindo nome órgão superior
dados_rev$nome_órgão_superior <- dados_rev$nome_órgão_superior %>% 
  str_replace_all(c("ça"="ca","ç"="c","é|ê"="e","ã|á|à"="a","í"="i",
                    "ú"="u","ó|ô"="o")) 
#corrigindo nome órgão
dados_rev$nome_órgão <- dados_rev$nome_órgão %>% 
  str_to_upper() %>% 
  str_replace_all(c("ÇÃ"="CA","Ç"="C","É|Ê"="E","Ã|Á|À"="A","Í"="I",
                    "Ú"="U","Ó|Ô"="O")) 

#corrigindo unidade gestora
dados_rev$nome_unidade_gestora <- dados_rev$nome_unidade_gestora %>% 
  str_to_upper() %>% 
  str_replace_all(c("ÇÃ"="CA","Ç"="C","É|Ê"="E","Ã|Á|À"="A","Í"="I",
                    "Ú"="U","Ó|Ô"="O")) 

#data separada
dados_rev <- dados_rev %>% 
  mutate(dia=str_extract(data_transação,pattern="[:digit:]{2}(?=/)"),
         mes=str_extract(data_transação,pattern="(?<=/)[:digit:]{2}(?=/)"),
         ano=str_extract(data_transação,pattern="(?<=/)[:digit:]{4}"))


write.csv(dados_rev,"cartao_bolsonaro2019_revisado.csv",
          row.names = FALSE,fileEncoding = "latin1")

tst <- read.table("cartao_bolsonaro2019_revisado.csv",
                        sep=",",dec=".",
                        header=TRUE,
                        fileEncoding = "latin1")
