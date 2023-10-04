#linguagem R: 2 encontro

#obtendo e modificando working directory (wd)
getwd()

setwd("C:/Users/arjon/Documents/GitHub/curso-r-pos-grad")

getwd()


#abrindo a primeira base de dados
#certificar-se que o (wd) está selecionado
#corretamente e que o arquivo .csv está
#na pasta correta

dados <- read.csv("cartao_bolsonaro2019.csv",
                    sep=",",dec=".",
                    header=TRUE,
                    encoding = "latin1")

library(readr)
tst <- read_csv("cartao_bolsonaro2019.csv", 
         locale = locale(encoding = "WINDOWS-1252"))

#Ver dados
View(dados)

#head (as primeiras observações)
head(dados)

#str (estrutura das colunas)
str(dados)

#summary (resumo de cada coluna)
summary(dados)

#colnames (nome das colunas)
colnames(dados)


#usando o cifrão ($) para referenciar colunas
head(dados$NOME.ÓRGÃO,n=10)


#corrigindo nomes das colunas 
#removendo espaços e pontos
#colocando tudo em minúsculas
names(dados) <- c("código_órgão_superior","nome_órgão_superior","código_órgão",
                  "nome_órgão","código_unidade_gestora","nome_unidade_gestora",
                  "ano_extrato","mês_extrato","cpf_portador","nome_portador",
                  "cnpj_ou_cpf_favorecido","nome_favorecido","transação",
                  "data_transação","valor_transação")

#table
table(dados$nome_órgão_superior)

#prop.table
prop.table(table(dados$nome_órgão_superior))

##pacotes
#instalando (necessário rodar apenas uma vez)
install.packages("tidyverse")

#carregando (necessário rodar toda nova sessão)
library(tidyverse)

##funções tradicionais do dplyr
#select

#selecionando colunas sem usar objetos para armazenar indices
head(select(dados,c(1,2,3)),n=3)
View(select(dados,c(1,2,3)),n=3)

#removendo colunas sem usar objetos para armazenar indices
head(select(dados,-c(2,1,3)),n=3)
View(select(dados,-c(2,1,3)),n=3)

#selecionando colunas usando objetos para armazenar indices

#quando passamos um objeto dessa forma, precisamos colocar
#o objeto dentro de uma função chamada "all_of"
#ela apenas diz ao R e ao select que eles precisamos pegar 
#(ou remover no caso do exemplo logo depois desse) tudo o que
#esta nesse objeto 

vars <- c(1,2,3)
head(select(dados,all_of(vars)),n=3)
View(select(dados,all_of(vars)),n=3)

#removendo colunas usando objetos para armazenar indices

#como anteriormente, para remover usamos o sinal de menos
# - antes do "all_of"

vars <- c(4:15)
head(select(dados,-all_of(vars)),n=3)
View(select(dados,-all_of(vars)),n=3)

#nao se preocupem de entender esse "all_of", é apenas uma
#convenção que usamos mas que pode ser "desviada"
#usando o numero das colunas como mencionamos nos dois primeiros
#exemplos

#selecionando/removendo com o nome da coluna
#o dplyr permite usarmos o nome das colunas sem aspas
#aqui, mas atenção isso é algo desse pacote apenas!

head(select(dados,nome_órgão_superior),n=3)
View(select(dados,nome_órgão_superior))

View(select(dados,-nome_órgão_superior))
View(select(dados,-nome_órgão_superior))

#passando um objeto com os nomes
#CUIDADO: no exemplo acima nao escrevemos o nome com aspas
#nesse abaixo precisamos escrever o nome da coluna com aspas!!
#e usar o "all_of"

vars <- c("nome_órgão_superior")

head(select(dados,all_of(vars)),n=3)
View(select(dados,all_of(vars)))

head(select(dados,-all_of(vars)),n=3)
View(select(dados,-all_of(vars)))

#na maioria das vezes e nos nosssos exercicios façam a seleção
#usando o formato com os numeros, como no caso abaixo

head(select(dados,c(1,2,3)),n=3)

#ele é mais versatil e dá menos trabalho de escrever

#filter
head(filter(dados,nome_órgão_superior=="Presidência da República"))
View(filter(dados,nome_órgão_superior=="Presidência da República"))

#filtrando valores
View(filter(dados,valor_transação<100))

#duas condições concomitantes (simultaneas)
head(filter(dados,
            nome_órgão_superior=="Presidência da República" &
              valor_transação >10000),n=3)

View(filter(dados,
            nome_órgão_superior=="Presidência da República" &
              valor_transação >10000))

#duas condições concorrentes(esta, aquela ou ambas)
head(filter(dados,
            nome_órgão_superior=="Presidência da República" |
              nome_órgão_superior== "Ministério da Economia"),n=3)

View(filter(dados,
            nome_órgão_superior=="Presidência da República" |
              nome_órgão_superior== "Ministério da Economia"))

#condições concorrentes e concomitantes
#são mais complexas, já que vários filtros são aplicados
#logo, leiam com atenção

head(filter(dados,
            (nome_órgão_superior=="Presidência da República" &
               valor_transação >10000) |
              nome_órgão_superior=="Ministério da Economia" &
              transação=="SAQUE CASH/ATM BB"),n=3)

#o que esse filtro faz:
#pega despesas feitas pela Presidência da República com valor 
#acima de 10 mil reais (indicado pela letra '&')
#OU (indicado pelo caracter '|')
#pega despesas feitas pelo Ministério da Economia na modalidade
#"SAQUE CASH/ATM BB" (indicado pela letra &)

#group_by+summarise
#agrupando por orgao e pedindo a soma total
summarise(group_by(dados,nome_órgão_superior),soma=sum(valor_transação))

#agrupando por orgao, pedindo varias metricas estatisticas e
#armazenando os resultados num objeto chamado 'resumo'
resumo <- summarise(group_by(dados,nome_órgão_superior),
                    soma=sum(valor_transação),
                    contagem=n(),
                    media=mean(valor_transação),
                    mediana=median(valor_transação),
                    min=min(valor_transação),
                    max=max(valor_transação))
resumo

#agrupando por orgao, pedindo a media e o dobro da media
#podemos usar colunas criadas no proprio summarise para
#criar outras colunas
#nesse caso abaixo, criamos 'media' e depois 'media_vezes_2'
summarise(group_by(dados,nome_órgão_superior),
          media=mean(valor_transação),
          media_vezes_2=media*2)

#o group_by+summarise apenas gera visualizações agrupadas dos
#dados. Ele não cria novas colunas, quem faz isso é o 'mutate'
#que veremos adiante

#arrange
arrange(resumo,desc(media))

#se passarmos mas nomes de colunas o R faz uma ordenação sequencial
#primeiro pela primeira coluna e depois pela segunda

#no caso abaixo, primeiro ordenamos pelo nome do orgao superior
#(ordem alfabetica) e depois pelo valor das medias decrescendo
arrange(resumo,nome_órgão_superior,desc(media))

#mutate
#diferença da media
View(mutate(dados,diff_media=valor_transação-mean(valor_transação),
            media=mean(valor_transação)))

#diferença da mediana
View(mutate(dados,diff_mediana=valor_transação-median(valor_transação),
            mediana=median(valor_transação)))

##operador pipe %>% 

#sem pipe (analogia da gota d'água)
mean(head(seq(100,125),n=3))

#com pipe (analogia da linha de produção)
seq(100,125) %>%
  head(n=3) %>%
  mean()


##dplyr + pipe

#despesas de maio do presidente da república
dados %>% 
  select(2,8,10,12,13,15) %>% 
  filter(mês_extrato == 5 & nome_órgão_superior == "Presidência da República") %>% 
  arrange(desc(valor_transação)) %>% 
  head(n=15) %>% 
  View()

#resumo estatístico por órgão federal

dados %>% 
  group_by(nome_órgão_superior) %>% 
  summarise(contagem=n(),
            soma=sum(valor_transação),
            media=mean(valor_transação),
            mediana=median(valor_transação),
            min=min(valor_transação),
            max=max(valor_transação)) %>% 
  arrange(desc(soma)) %>% 
  View()

#resumo estatístico de despesas sigilosas
dados %>% 
  filter(nome_favorecido=="Sigiloso") %>% 
  group_by(nome_órgão_superior) %>% 
  summarise(contagem=n(),
            soma=sum(valor_transação),
            media=mean(valor_transação),
            mediana=median(valor_transação),
            min=min(valor_transação),
            max=max(valor_transação)) %>% 
  arrange(desc(soma)) %>% 
  View()


#resumo estatistico das despesas sigilosas 
#feitas pela presidência por sub-órgão
dados %>% 
  filter(nome_órgão=="Presidência da República" & nome_favorecido=="Sigiloso") %>% 
  group_by(nome_unidade_gestora) %>% 
  summarise(contagem=n(),
            soma=sum(valor_transação),
            media=mean(valor_transação),
            mediana=median(valor_transação),
            min=min(valor_transação),
            max=max(valor_transação)) %>% 
  arrange(desc(soma)) %>% 
  View()

#resumo estatístico das despesas por órgão federal
#e por status (despesa sigilosa ou despesa aberta)
#uso do mutate na prática
dados %>% 
  mutate(status=ifelse(nome_favorecido=="Sigiloso","Sigiloso","Aberto")) %>% 
  group_by(nome_órgão_superior,status) %>% 
  summarise(contagem=n(),
            soma=sum(valor_transação),
            media=mean(valor_transação),
            mediana=median(valor_transação),
            min=min(valor_transação),
            max=max(valor_transação)) %>% 
  View()

#exercícios

#1.Extraia métricas (como as obtidas usando nossos 'summarise')
#para da um dos valores da coluna "transação". Esta coluna
#define se a transação foi uma compra ou um saque em 
#espécie. Use group_by+summarise

#2.Luciano Hang, dono das lojas Havan, foi uma figura 
#muito presente durante o governo de Bolsonaro. Obtenha 
#as despesas feitas em suas lojas, que aparecem com o 
#ome "HAVAN LOJAS DE DEPARTAMENTOS LTDA" (exatamente 
#dessa forma!) em "nome_favorecido. Use filter

#3.Selecione as despesas que constam no extrato de Agosto
#(mês_extrato==8), agrupe por 'data_transação" e obtenha
#a soma total das despesas para cada uma das datas. 
#Qual foi o dia com o menor valor total?
#use filter e group_by+summarise

#4.(Desafio) Extraia informações da despesa de maior valor
#feita. Quem a fez, qual seu valor e em que foi gasto o 
#dinheiro? 

#Dica: é possível usar as funções *max* e *min* para
#criar condições lógicas de filtro. Use filter e 
#'max(valor_transação)'

#5.(Desafio) Corrija o valor da maior despesa feita em 
#2019 pela inflação em Dezembro de 2022. Para corrigir 
#um valor monetário passado pela inflação de forma a
#compararmos poderes de compra, multiplicamos o valor
#antigo pelo IPCA acumulado do período considerado. 
#Para 01/2019 até 12/2022, o valor a ser multiplicado 
#é de 1.64. Qual é o novo valor?

#Dica: precisamos usar um *mutate* para criar os valores
#corrigidos e logo em seguida um *arrange* decrescente 
#pelo valor corrigido para termos a maior despesa no topo
#da nossa visualização. A operação aser feita será um
#'mutate' onde multiplicamos 'valor_transação' por 1.64

#ps: é 1.64, e não 1,64!!!

#6.(Desafio) Encontre todas as despesas feitas pelo
#Ministério da Educação no cartão corporativo para a
#UFSCar. A universidade aparece nos dados com o nome
#"Fundação Universidade Federal de São Carlos" 
#(exatamente dessa forma!) na coluna "nome_órgão"
#(não "nome_órgão_superior". 

#Use um 'arrange' decrescente de valor_transação (usando 'desc()'). 

#Selecione apenas as colunas "nome_órgão", "nome_portador",
#"nome_favorecido" e "valor_transação" (colunas 4,10,12,15). 
#Qual o valor da maior despesa? 
