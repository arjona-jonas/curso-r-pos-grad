#linguagem R: 1 encontro


#operacoes matemáticas

#operacoes simples
1+1
4-2
2*5
100/10

#potencia
10^2 
2^2

#multiplas operacoes
(2+2)*100

#media
(2+5+7+9+3+11+2)/7

#porcentagem
((2+5+7+9+3+11+2)/39)*100
((2+5+7+9+3)/39)*100

#comparacoes
2 == 3
3 == 3
(9/3) == 3
4 != 5
7 != 7
5 < 9
11 > 9

#comparacoes complexas
2 == 3 & 3 == 3
3 == 3 & 9/3 == 3

#comparacoes condicionais
T == T & T == F #T & F = F 
T == F & T == F #F & F = F

T != F | T != T #T | F = T
T == F | F != F #F | F = F

#funcoes
seq(from=100,to=125)
seq(100,125)

(seq(100,125)+10)/100

seq(100,125)+10/100

?seq


#objetos

#objeto de texto
objeto <- c("a","b","c","d")
objeto

#objeto de números
objeto_numero <- c(3,4,1,2)
objeto_numero

#objeto misto (errado)
objeto_misto <- c(a,5,b,9,c,1)

#objeto misto (correto)
objeto_misto <- c("a",5,"b",9,"c",1)

#print dos dois objetos criados separados
print(c(objeto,objeto_numero))



#sequencias
sequencia <- c(1:10)
sequencia

sequencia_par <- seq(0,10,2)
sequencia_par

objeto_numero+2
sequencia_par+5

#tipos de dados

#character
objeto_character <- c("AZUL","VERMELHO","AMARELO")
objeto_character

class(objeto_character)

#factor
objeto_factor <- factor(c("muito","normal","pouco"))
objeto_factor

class(objeto_factor)

levels(objeto_factor)

#numeric
objeto_numero <- c(1.3,2,4.9,7.2,9.5)

class(objeto_numero)

objeto_numero+2

#logical
objeto_logical <- c(T,F,T,T,F,F)
objeto_logical

class(objeto_logical)

#conversões

#character para factor
as.factor(objeto_character)
class(as.factor(objeto_character))

#numeric para character
as.character(objeto_numeric)
class(as.character(objeto_numeric))

#factor para numeric
as.numeric(objeto_factor)
class(as.numeric(objeto_factor))

#logical para character ou numeric
as.character(objeto_logical)
class(as.character(objeto_logical))

as.numeric(objeto_logical)
class(as.numeric(objeto_logical))

#indices
objeto_character[3]

objeto_factor[1]

objeto_numeric[1:4]

objeto_logical[4:6]

#OBJETOS MULTIDIMENSIONAIS
#matrizes
matrix(data=c(1,2,3,4,5,6,7,8,9),nrow=3,ncol=3)

#listas
list(x=list("a",c(1,2,3),"c"),
     y=list(T,F,c("a","b")),
     z=list("teste1","teste2",c(T,F,T)))

#data.frame
data.frame(alunos=c("matheus","carlos","bossa","gustavo"),
           comida_preferida=c("macarronada","salgadinho","bolacha","churrasco"),
           idade=c(14,18,20,47))

#data.frame tudo em uma só linha
data.frame(alunos=c("matheus","carlos","bossa","gustavo"),comida_preferida=c("macarronada","salgadinho","bolacha","churrasco"),idade=c(14,18,20,47))

#combinando objetos
alunos <- c("maria","joao","caio","matheus")
portugues <- c(4,7,9,10)

data.frame(alunos,portugues)

#objetos e dados ad hoc
data.frame(alunos,portugues,faltas=c(1,2,3,4))

#atribuir um unico valor
data.frame(alunos,portugues,faltas=1)

#refenciando colunas dentro da propria função
data.frame(alunos,portugues,nota_com_ponto_extra=portugues+1)


#associando objeto
df <- data.frame(alunos,portugues,faltas=c(1,2,3,4))

#indice em data.frames
df[1,1:3]
df[,1]
df[1,]
df[1:3,]
df[,1:3]

df[1,1] #LINHA 1 E COLUNA 1
df[2,3] #LINHA 2 E COLUNA 3

#todas as linhas ou colunas
df[1,] #TODAS AS COLUNAS DA LINHA 1
df[,2] #TODAS AS LINHAS DA COLUNA 2

#usando funcao c e indices
df[c(2,3),c(2,1)]

#objeto como indice
indice <- c(1:3)

df[indice,] #TODAS AS LINHAS DAS LINHAS COLUNAS 1 ATE 3
df[,indice] #TODAS AS COLUNAS DAS LINHAS 1 ATE 3
df[indice,indice] #LINHAS 1 ATE 3 DAS COLUNAS 1 ATE 3


#exercícíos

#1.Crie um data.frame contendo dados fictícios. Coloque ao menos
#6 linhas com: nome, cor favorita, idade e se possui alguma animal
#de estimação (booleano).

#2.Extraia apenas nome e animal de estimação usando índices.

#3.Extraia apenas as observações 3,4,5 usando índices.

#4.(Desafio) Escolha aleatoriamente duas linhas dos dados e extraia
#todas as informações de ambas do nosso data.frame.

#Dica: primeiro precisamos armazenar os respectivos índices em um
#objeto separado e depois usar de índices para fazer a extração 
#dos respectivos dados.
  
#5.(Desafio) Você gostaria de saber quantas horas cada uma das
#pessoas do data.frame tem de vida. Para isso, você precisa
#primeiro saber quantos dias cada pessoa tem e em seguida
#quantas horas. Faça esse cálculo.

#Dica: você precisará usar índices para selecionar apenas as idades,
#para em seguida multiplicá-las por 365 dias e o resultado disso
#multiplicar por 24 horas.**
  
#6.(Desafio) Adicione uma nova coluna que contenha o time de futebol chamada 
#*time* que contenha o time de cada uma das pessoas. Extraia então usando
#índices o nome e o time.

#Dica: vimos que é possível criar um data.frame combinando objetos 
#e escrevendo manualmente os dados. Também é possível fazer o mesmo
#com um data.frame já existente. Para isso, pensem em como fizemos 
#isso no exemplo das faltas usado acima. Lembrem-se de que se não 
#usarmos o operador de associação o objeto não é salvo e não pode
#ser referenciado.




