#linguagem R: 2 encontro

#obtendo e modificando working directory (wd)
getwd()

setwd("C:/Users/arjon/Documents/GitHub/curso-r-pos-grad")

getwd()


#abrindo a primeira base de dados
#certificar-se que o (wd) está selecionado
#corretamente e que o arquivo .csv está
#na pasta correta
dados <- read.table("cartao_bolsonaro2019.csv",
                    sep=",",dec=".",
                    header=TRUE,
                    fileEncoding = "latin1")

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

#filter

#group_by+summarise

#arrange

#mutate


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
  head(n=15)

#resumo estatístico por órgão federal

dados %>% 
  group_by(nome_órgão_superior) %>% 
  summarise(contagem=n(),
            soma=sum(valor_transação),
            media=mean(valor_transação),
            mediana=median(valor_transação),
            min=min(valor_transação),
            max=max(valor_transação)) %>% 
  arrange(desc(soma))

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
  arrange(desc(soma))


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
  arrange(desc(soma))

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
            max=max(valor_transação))

#exercícios

#1.Extraia métricas (como as obtidas usando *summarise*)
#para da um dos valores da coluna "transação". Esta coluna
#define se a transação foi uma compra ou um saque em 
#espécie.

#2.Luciano Hang, dono das lojas Havan, foi uma figura 
#muito presente durante o governo de Bolsonaro. Extraia 
#as despesas feitas em suas lojas, que aparecem com o 
#ome "HAVAN LOJAS DE DEPARTAMENTOS LTDA" (exatamente 
#dessa forma!) em "nome_favorecido.

#3.Selecione as despesas que constam no extrato de Agosto
#(mês_extrato==8), agrupe por dia e obtenha a soma total
#das despesas para cada um dos dias. Qual foi o dia com
#o menor valor total?

#4.(Desafio) Extraia informações da despesa de maior valor
#feita. Quem a fez, qual seu valor e em que foi gasto o 
#dinheiro? 

#Dica: é possível usar as funções *max* e *min* para
#criar condições lógicas de filtro.

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
#da nossa visualização

#6.(Desafio) Encontre todas as despesas feitas pelo
#Ministério da Educação no cartão corporativo para a
#UFSCar. A universidade aparece nos dados com o nome
#"Fundação Universidade Federal de São Carlos" 
#(exatamente dessa forma!) na coluna "nome_órgão". 
#Use um *arrange* decrescente de valor_transação . 
#Selecione apenas as colunas "nome_órgão", "nome_portador",
#"nome_favorecido" e "valor_transação". 
#Qual o valor da maior despesa? 
