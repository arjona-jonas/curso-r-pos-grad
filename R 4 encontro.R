#linguagem R: 4 encontro

setwd("C:/Users/arjon/Documents/GitHub/curso-r-pos-grad")
getwd()

library(tidyverse)

#dados
dados_rev <- read.table("cartao_bolsonaro2019_revisado.csv",
                        sep=",",dec=".",
                        header=TRUE,
                        fileEncoding = "latin1")

#canvas em branco
ggplot(data=dados_rev)

#teste de gráfico
objeto_teste <- data.frame(num_1=seq(1,10),
                           num_2=seq(1,10)^2)

ggplot(objeto_teste)+
  geom_point(mapping=aes(x=num_1,y=num_2))

#gráfico nome_órgão_superior
ggplot(dados_rev)+
  geom_bar(mapping=aes(x=nome_órgão_superior))

#gráfico com coord_flip
ggplot(dados_rev)+
  geom_bar(mapping=aes(x=nome_órgão_superior))+
  coord_flip()

#gráfico com cor
ggplot(dados_rev)+
  geom_bar(mapping=aes(x=nome_órgão_superior,fill=transação))+
  coord_flip()

#gráfico de linhas
dados_metricas <- dados_rev %>% 
  filter(ano=="2019") %>% 
  group_by(dia) %>% 
  summarise(media=mean(valor_transação),
            desvio=sd(valor_transação))

ggplot(dados_metricas)+
  geom_line(mapping=aes(x=media,y=desvio))

#gráfico de linhas com cor
dados_metricas <- dados_rev %>% 
  filter(ano=="2019") %>% 
  group_by(dia,mes) %>% 
  summarise(media=mean(valor_transação),
            desvio=sd(valor_transação))

ggplot(dados_metricas)+
  geom_line(mapping=aes(x=media,
                        y=desvio,
                        color=as.factor(mes)))

#dados faltantes presentes no dia 2 do mês 1
dados_rev %>% filter(mes==1 & dia==2)

#boxplot com números em log base 2
sigilosas <- dados_rev %>% 
  filter(nome_portador=="Sigiloso" & nome_órgão=="PRESIDENCIA DA REPUBLICA") %>% 
  mutate(valor_log=log(valor_transação,base = 2))

table(sigilosas$nome_unidade_gestora)

ggplot(sigilosas)+
  geom_boxplot(mapping=aes(x=nome_unidade_gestora,
                           y=valor_log))

#titulos e legendas
ggplot(dados_rev)+
  geom_bar(aes(x=nome_órgão_superior,fill=transação))+
  coord_flip()+
  labs(x="Órgão superior",
       y="Número de despesas",
       title="Número de despesas por órgão e tipo de transação",
       subtitle="Dados coletados do site do Portal da Transparência para o ano de 2019",
       fill="Tipo de transação")

#customizando com a função theme
ggplot(dados_rev)+
  geom_bar(aes(x=nome_órgão_superior,fill=transação))+
  coord_flip()+
  theme(legend.title = element_text(size=9),
        legend.text = element_text(size=7),
        axis.text.y=element_text(size=7))+
  labs(x="Órgão superior",
       y="Número de despesas",
       title="Número de despesas por órgão e tipo de transação",
       subtitle="Portal da Transparência (2019)",
       fill="Tipo de transação")

#dplyr+ggplot2
dados_rev %>% 
  group_by(nome_órgão_superior) %>% 
  summarise(media=mean(valor_transação)) %>% 
  ggplot()+
  geom_col(aes(x=nome_órgão_superior,y=media))+
  coord_flip()

#barras coloridas e reordenadas
dados_rev %>% 
  group_by(nome_órgão_superior,transação) %>% 
  summarise(contagem=n()) %>% 
  ggplot()+ 
  geom_col(aes(x=reorder(nome_órgão_superior,
                         contagem),
               y=contagem,
               fill=transação))+
  coord_flip()

#objetos de configuração
objeto_config <- theme(title = element_text(size = 14),
                       axis.title = element_text(size = 12),
                       axis.text = element_text(size = 8),
                       legend.title = element_text(size = 12),
                       legend.text = element_text(size = 8),
                       panel.border = element_rect(colour = "black",fill = NA),
                       panel.background = element_rect(fill = "#f2f4f7"),
                       panel.grid = element_line(colour = "grey70"))

objeto_cores <- scale_fill_manual(values = c("#f6b395","#f6e095",
                                             "#b9f695","#acf5ed",
                                             "#acbff5"))

#gráficos com objetos de config
#barras
dados_rev %>% 
  filter(nome_órgão_superior=="Presidencia da Republica") %>% 
  group_by(nome_unidade_gestora,transação) %>% 
  summarise(contagem=n()) %>% 
  ggplot()+ 
  geom_col(aes(x=reorder(nome_unidade_gestora,
                         contagem),
               y=contagem,
               fill=transação))+
  coord_flip()+
  labs(x="Unidade gestora",
       y="Número de despesas",
       fill="Tipo de transação",
       title="Número de despesas por unidade gestora e tipo de transação")+
  objeto_config+
  objeto_cores

#boxplot
dados_rev %>% 
  filter(nome_órgão_superior=="Presidencia da Republica") %>% 
  mutate(valor_log=log(valor_transação,base=2)) %>% 
  ggplot()+
  geom_boxplot(aes(x=reorder(nome_unidade_gestora,valor_log,median),
                   y=valor_log,
                   fill=transação))+
  coord_flip()+
  labs(x="Unidade gestora",
       y="Valor da despesa",
       fill="Tipo de transação",
       title="Valor das despesas por unidade gestora e tipo de transação")+
  objeto_config+
  objeto_cores

#exercícios
#1.Usando dplyr filtre pelos dados feitos com a 
#UFSCAR (`nome_unidade_gestora=="FUNDACAO UNIVERSIDADE
#FEDERAL DE SAO CARLOS"`) e plote um boxplot para 
#"nome_portador" e "valor_transação". Use *coord_flip* 
#para melhorar a visualização. Há algo anormal?
  
#2.(Desafio) Usando *mutate* crie uma nova variável na
#nossa base para gastos maiores que 1000 reais usando
#uma condição *ifelse* onde se sim o valor será
#"Maior que mil" e se não o valor será "Menor que mil"
#(reveja aula dois se for preciso). Junte esse resultado
#num gráfico de barras por "nome_órgão_superior" e
#adicione a variável criada no argumento fill.

#Dica: retomem a explicação sobre um *mutate* condicional.
#Como a métrica que estamos usando é número de despesas
#podemos usar *geom_bar* ao invés de *geom_col, como 
#vinhamos fazendo.

#3.(Desafio) Em métodos quantitativos, é comum encontrarmos
#relações entre variáveis onde os retornos de uma 
#variável independente é decrescente, ou seja, quanto 
#mais aumentamos X menos Y cresce. Acredita-se que esse
#é o caso da relação entre escolaridade e salário.
#Esse tipo de relação é conhecida como logarítmica. 
#Monte um data.frame com duas variáveis que se relacionem
#dessa forma e plote o gráfico usando *geom_point*.

#Dica: no exemplo usado neste material da função 
# geom_point fizemos algo parecido mas com uma relação
#exponencial. Para obter o logarítmo de um número usamos
#a função *log* e como argumento o número em si.


