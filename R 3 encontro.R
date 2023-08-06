#linguagem R: 3 encontro

setwd("C:/Users/arjon/Documents/GitHub/curso-r-pos-grad")
getwd()

library(tidyverse)


#dados 
dados <- read.table("cartao_bolsonaro2019.csv",
                    sep=",",dec=".",
                    header=TRUE,
                    fileEncoding = "latin1")

#colnames
colnames(dados)

#str_to_lower
colnames(dados) %>% 
  str_to_lower()

#str_replace_all
colnames(dados) %>% 
  str_replace_all(pattern="\\.",replacement = "_")

#ambos juntos para renomear colunas
names(dados) <- colnames(dados) %>% 
  str_to_lower() %>% 
  str_replace_all(pattern="\\.",replacement = "_")

names(dados)

#### nome_órgão_superior
unique(dados$nome_órgão_superior)

#### nome_órgão
unique(dados$nome_órgão)

#### nome_unidade gestora
unique(dados$nome_unidade_gestora) %>% 
  head(n=25)

#só presidencia
presidencia <- dados %>% 
  filter(nome_órgão_superior=="Presidência da República")

unique(presidencia$nome_unidade_gestora)

#corrigindo orgaos
presidencia$nome_unidade_gestora <- presidencia$nome_unidade_gestora %>% 
  str_replace_all(pattern = "Ê",replacement="E") %>%
  str_replace_all(pattern= "ÇÃ",replacement = "CA") %>% 
  str_replace_all(pattern = "Ç",replacement = "C")

unique(presidencia$nome_unidade_gestora)

#multiplas correções
dados$nome_órgão %>% 
  str_to_upper() %>% 
  str_replace_all(c("ÇÃ"="CA","Ê"="E","Ç"="C","É"="E","Ã"="A")) %>% 
  unique() %>% 
  head(n=10)

#str_detect
str_detect(dados$nome_unidade_gestora,pattern="Ê") %>% 
  table()

#str_detect+indice
indice <- str_detect(dados$nome_unidade_gestora,pattern="Ê")

dados[indice,]

#str_extract e str_extract_all
str_extract(dados$nome_portador,pattern="QUEIROZ") %>% 
  table()

str_extract(dados$nome_portador,pattern="QUEIROZ") %>% 
  head(n=100)

#str_subset
str_subset(dados$nome_favorecido,pattern="JOIA")

#pattern e regex
letras_numeros <- c("AA2","BB20","CC190","DD10000000")

str_replace_all(letras_numeros,pattern="[:digit:]",replacement = "")

teste_regex <- c("joao","caio","maria","camila")

teste_regex

str_replace_all(teste_regex,pattern=".",replacement = "A")

#regex e datas
head(dados$data_transação)

dados <- dados %>% 
  mutate(dia=str_extract(data_transação,pattern="[:digit:]{2}(?=/)"),
         mes=str_extract(data_transação,pattern="(?<=/)[:digit:]{2}(?=/)"),
         ano=str_extract(data_transação,pattern="(?<=/)[:digit:]{4}"))

dados %>% 
  select(data_transação,dia,mes,ano) %>% 
  head()

#exercicios

#1 Num encontro anterior, selecionamos as 
#despesas feitas em nome da UFSCar, usando
#um nome específico. Use "SÃO CARLOS" em 
#"nome_unidade_gestora" para encontrar os 
#possíveis nomes que a universidade pode
#receber (só os nomes mesmo).

#Dica: use *unique* para pegar apenas
#valores únicos.

#2 Troque "SÃO CARLOS" por "UFSCAR". Há 
#alguma diferença? Se sim, quais outras
#unidades surgem?

#3 Com nossos novos dados de data, filtre 
#apenas pelas despesas feitas em 2019 
#(usando a nova coluna "ano"), agrupe por
#dia do mês e obtenha a soma, o número de
#despesas e a mediana das despesas. Qual
#dia do mês foi o que no total teve a 
#maior soma?

#4 Usando nossa base "presidencia" e 
#str_subset obtenha os valores possíves
#(com *unique*) das despesas em que 
#"nome_favorecido" contenha "LTDA".

#5 Corrija o valor da transação, 
#substituindo o ponto (".") como 
#separador por vírgula (",").
#Dica: lembre-se que quando o "pattern" 
#é um ponto "." a forma correta de se
#referir a ele é com "\\."

#6 (Desafio) Temos um problema com pessoas
#chamadas Fabrício. Suspeitamos que as
#despesas que elas fizeram usando o cartão
#sejam fraudulentas. Extraia todas as
#despesas onde o "nome_portador" contenha
#"FABRICIO" (exatamente dessa forma!!) 
#usando *str_detect*. Faça um *arrange* 
#decrescente pelo valor da transação. 
#Qual o maior valor e qual órgão o fez? 

#Dica: um str_detect retorna apenas as
#observações que possuam totalmente 
#aquilo que colocamos em "pattern", 
#isto é, retorna TRUE para elas e FALSE
#para as demais. É possível usarmos o
#resultado do *str_detect* dentro de um
#índice para selecionar um conjunto de 
#linhas. Como queremos outras informações,
#nosso espaço para colunas no índice 
#deverá estar vazio.

