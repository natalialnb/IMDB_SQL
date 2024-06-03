# Análise da Base IMDB usando MySQL

A Internet Movie Database (IMDB) é uma base de dados abrangente que contém informações sobre séries, filmes, músicas e games, além de críticas e avaliações dos usuários. 

Após um mês de curso, onde aprendi mais sobre MySQL, fui desafiada pela Jump Star a resolver um case utilizando dados do IMDB.

Além de criar a base, as tabelas e trazer todos os dados, tive que responder as questões abaixo: 

1 - Gerar um relatório contendo os 10 filmes mais lucrativos de todos os tempos, e identificar em qual faixa de idade/gênero eles foram mais bem avaliados.

2 - Quais os gêneros que mais aparecem entre os Top 10 filmes mais bem avaliados de cada ano, nos últimos 10 anos.

3 - Quais os 50 filmes com menor lucratividade ou que deram prejuízo, nos últimos 30 anos. Considerar apenas valores em dólar ($).

4 - Selecionar os top 10 filmes baseados nas avaliações dos usuários, para cada ano, nos últimos 20 anos.

5 - Gerar um relatório com os top 10 filmes mais bem avaliados pela crítica e os top 10 pela avaliação de usuário, contendo também o budget dos filmes.

6 - Gerar um relatório contendo a duração média de 5 gêneros a sua escolha.
7 - Gerar um relatório sobre os 5 filmes mais lucrativos de um ator/atriz(que podemos filtrar), trazendo o nome, ano de exibição, e Lucro obtido. Considerar apenas valores em dólar($).

8 - Baseado em um filme que iremos selecionar, trazer um relatório contendo quais os atores/atrizes participantes, e pra cada ator trazer um campo com a média de avaliação da crítica dos últimos 5 filmes em que esse ator/atriz participou.

9 - Gerar mais duas análises a sua escolha, baseado nessas tabelas (em uma delas deve incluir a análise exploratória de dois campos, um quantitativo e um qualitativo, respectivamente)


<strong> Segue algumas funções diferentes utilizadas na resolução do meu case:</strong>

- Para importar os dados dos CSV após criar as tabelas

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.1/Uploads/CASE_SQL/CaseSQL_names.csv"

INTO TABLE CaseSQL_names

FIELDS TERMINATED BY ','

ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS;

- SUBSTRING_INDEX(): É uma função que pega uma parte específica de uma string, baseada em um separador específico. EX: ' R$ 10000" . No caso, estamos usando um espaço (' ') como separador na coluna.

- ROUND(GREATEST(
  
            males_0age_avg_vote,
  
            males_18age_avg_vote,
  
            males_30age_avg_vote,
  
            males_45age_avg_vote,
  
            females_0age_avg_vote,
  
            females_18age_avg_vote,
  
            females_30age_avg_vote,
  
            females_45age_avg_vote
  
        ), 2
			) AS Melhor_avaliação,
  
GREATEST(): Compara todos os valores fornecidos dentro dos parênteses.


- Criar Ranking:
  
  ROW_NUMBER() OVER (PARTITION BY year ORDER BY votes DESC, avg_vote DESC) AS `rank`

 - TIME_FORMAT(SEC_TO_TIME(AVG(duration * 60)),'%H:%i:%s') AS Duração_média

Sec_to_time: A função retorna uma string no formato de tempo 'HH:MM'.

TIME_FORMAT: formata um valor de tempo de acordo com uma string de formato especificada.
