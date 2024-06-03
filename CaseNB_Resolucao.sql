USE case_jump_4;

-- Análise das tabelas:

-- Verificando o nome das colunas nas tabelas:
SET @NomeTabela = 'casesql_movies';

SELECT 
	COLUMN_NAME
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'case_jump_4' 
	AND TABLE_NAME = @NomeTabela;

-- Verificando os nulos:
SELECT 
	SUM(CASE WHEN country IS NULL OR country = '' THEN 1 ELSE 0 END) AS country,
	SUM(CASE WHEN director IS NULL OR director = '' THEN 1 ELSE 0 END) AS director,
	SUM(CASE WHEN duration IS NULL OR duration = '' THEN 1 ELSE 0 END) AS duration,
	SUM(CASE WHEN genre IS NULL OR genre = '' THEN 1 ELSE 0 END) AS genre,
	SUM(CASE WHEN imdb_title_id IS NULL OR imdb_title_id = '' THEN 1 ELSE 0 END) AS imdb_title_id,
	SUM(CASE WHEN original_title IS NULL OR original_title = '' THEN 1 ELSE 0 END) AS original_title,
	SUM(CASE WHEN production_company IS NULL OR production_company = '' THEN 1 ELSE 0 END) AS production_company,
	SUM(CASE WHEN reviews_from_critics IS NULL OR reviews_from_critics = '' THEN 1 ELSE 0 END) AS reviews_from_critics,
	SUM(CASE WHEN reviews_from_users IS NULL OR reviews_from_users = '' THEN 1 ELSE 0 END) AS reviews_from_users,
	SUM(CASE WHEN title IS NULL OR title = '' THEN 1 ELSE 0 END) AS title,
	SUM(CASE WHEN usa_gross_income IS NULL OR usa_gross_income = '' THEN 1 ELSE 0 END) AS usa_gross_income,
	SUM(CASE WHEN votes IS NULL OR votes = '' THEN 1 ELSE 0 END) AS votes,
	SUM(CASE WHEN worldwide_gross_income IS NULL OR worldwide_gross_income = '' THEN 1 ELSE 0 END) AS worldwide_gross_income,
	SUM(CASE WHEN year IS NULL OR year = '' THEN 1 ELSE 0 END) AS year
FROM casesql_movies;

-- Verificando a coluna year:
SELECT 
	distinct year
FROM 
	casesql_movies
order by year;

-- Verificando se há valores duplicados na Tabela movies:
SELECT
	imdb_title_id,
    Row_num
FROM (SELECT
		*,
		ROW_NUMBER() OVER(partition by 
			actors,
			avg_vote,
			budget,
			country,
			date_published,
			description,
			director,
			duration,
			genre,
			imdb_title_id,
			language,
			metascore,
			original_title,
			production_company,
			reviews_from_critics,
			reviews_from_users,
			title,
			usa_gross_income,
			votes,
			worldwide_gross_income,
			writer,
			year order by imdb_title_id ) Row_num
	FROM 
		casesql_movies) AS SUB
WHERE Row_num = 1;

/* Algumas observações, poderia verificar também a coluna:
- production_company: os nomes das produtoras são escritos de formas diferentes.*/

-- Criação da VIEW movies_view com as alterações necessárias para construção do Case:

CREATE VIEW movies_view AS
SELECT
	imdb_title_id,
    title,
	cast(SUBSTRING(year, -4) as UNSIGNED)  as year,
    genre,
    duration,
    actors,
    production_company,
    original_title,
    SUBSTRING_INDEX(budget, ' ', 1) as currency_budget,
    CAST(SUBSTRING_INDEX(budget, ' ', -1) AS DECIMAL(12,0)) as budget,
	SUBSTRING_INDEX(usa_gross_income, ' ', 1) as currency_usa_income,
    CAST(SUBSTRING_INDEX(usa_gross_income, ' ', -1) AS DECIMAL(12,0)) as income_usa,
	SUBSTRING_INDEX(worldwide_gross_income, ' ', 1) as currency_world_income,
    CAST(SUBSTRING_INDEX(worldwide_gross_income, ' ', -1) AS DECIMAL(12,0)) as income_world,
    (CAST(SUBSTRING_INDEX(worldwide_gross_income, ' ', -1) AS DECIMAL(12,0)) - CAST(SUBSTRING_INDEX(budget, ' ', -1) AS DECIMAL(12,0))) AS profit,
    avg_vote,
    votes, 
    director,
    cast(metascore as UNSIGNED)  as Metascore,
    reviews_from_critics,
	reviews_from_users
FROM
	casesql_movies;

-- SUBSTRING_INDEX(): É uma função que pega uma parte específica de uma string, baseada em um separador específico. No nosso caso, estamos usando um espaço (' ') como separador na nossa coluna.
-------------------------------------------------------------------------------------------------

-- Exercício 1
-- Gerar um relatório contendo os 10 filmes mais lucrativos de todos os tempos, e identificar em qual faixa de idade/gênero eles foram mais bem avaliados.

/* 
GREATEST(...):

Compara todos os valores fornecidos dentro dos parênteses.
Neste caso, os valores são as médias das avaliações dadas por diferentes grupos demográficos (homens e mulheres em várias faixas etárias).

Nota: Esta função considera apenas as notas mais altas, independentemente da quantidade de votos recebidos por cada grupo.
*/


SELECT
    title AS Título,
    CONCAT('$ ', FORMAT(budget, 2, 'de_DE')) AS Custos,
    CONCAT('$ ', FORMAT(income_world, 2, 'de_DE')) AS Faturamento,
    CONCAT('$ ', FORMAT(profit, 2, 'de_DE')) AS Lucro,
    ROUND(
        GREATEST(
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
		CASE 
			WHEN GREATEST(
				males_0age_avg_vote,
				males_18age_avg_vote,
				males_30age_avg_vote,
				males_45age_avg_vote,
				females_0age_avg_vote,
				females_18age_avg_vote,
				females_30age_avg_vote,
				females_45age_avg_vote
			) = males_0age_avg_vote THEN 'Masculino - 0 Age'
			WHEN GREATEST(
				males_0age_avg_vote,
				males_18age_avg_vote,
				males_30age_avg_vote,
				males_45age_avg_vote,
				females_0age_avg_vote,
				females_18age_avg_vote,
				females_30age_avg_vote,
				females_45age_avg_vote
			) = males_18age_avg_vote THEN 'Masculino - 18 Age'
			WHEN GREATEST(
				males_0age_avg_vote,
				males_18age_avg_vote,
				males_30age_avg_vote,
				males_45age_avg_vote,
				females_0age_avg_vote,
				females_18age_avg_vote,
				females_30age_avg_vote,
				females_45age_avg_vote
			) = males_30age_avg_vote THEN 'Masculino - 30 Age'
			WHEN GREATEST(
				males_0age_avg_vote,
				males_18age_avg_vote,
				males_30age_avg_vote,
				males_45age_avg_vote,
				females_0age_avg_vote,
				females_18age_avg_vote,
				females_30age_avg_vote,
				females_45age_avg_vote
			) = males_45age_avg_vote THEN 'Masculino - 45 Age'
			WHEN GREATEST(
				males_0age_avg_vote,
				males_18age_avg_vote,
				males_30age_avg_vote,
				males_45age_avg_vote,
				females_0age_avg_vote,
				females_18age_avg_vote,
				females_30age_avg_vote,
				females_45age_avg_vote
			) = females_0age_avg_vote THEN 'Feminino - 0 Age'
			WHEN GREATEST(
				males_0age_avg_vote,
				males_18age_avg_vote,
				males_30age_avg_vote,
				males_45age_avg_vote,
				females_0age_avg_vote,
				females_18age_avg_vote,
				females_30age_avg_vote,
				females_45age_avg_vote
			) = females_18age_avg_vote THEN 'Feminino - 18 Age'
			WHEN GREATEST(
				males_0age_avg_vote,
				males_18age_avg_vote,
				males_30age_avg_vote,
				males_45age_avg_vote,
				females_0age_avg_vote,
				females_18age_avg_vote,
				females_30age_avg_vote,
				females_45age_avg_vote
			) = females_30age_avg_vote THEN 'Feminino - 30 Age'
			WHEN GREATEST(
				males_0age_avg_vote,
				males_18age_avg_vote,
				males_30age_avg_vote,
				males_45age_avg_vote,
				females_0age_avg_vote,
				females_18age_avg_vote,
				females_30age_avg_vote,
				females_45age_avg_vote
			) = females_45age_avg_vote THEN 'Feminino - 45 Age'
		END AS Avaliador_GenXIdade
FROM
    movies_view MOV
		LEFT JOIN casesql_ratings RAT
			ON MOV.imdb_title_id = RAT.imdb_title_id
WHERE
    currency_budget = '$'
ORDER BY
    profit DESC
LIMIT 10;


/*Insights: 'Olhando para o Lucro e para o faturamento, podemos observar que alguns filmes faturaram mais, porém tiveram o lucro menor.
A franquia Avengers ocupa 3 posições na classificação do TOP 10.
A maioria dos filmes é de ação e aventura e para um público mais jovem. */
-------------------------------------------------------------------------------------------------
-- Exercício 2 
-- Quais os gêneros que mais aparecem entre os Top 10 filmes mais bem avaliados de cada ano, nos últimos 10 anos.

-- Criação de CTE: Tabela temporária para filtrar os filmes dos últimos 10 anos e criar um ranking.
-- Em seguida, serão selecionados os filmes mais bem avaliados.
-- OBS: Para garantir um ranking mais justo, primeiro classificamos pela quantidade de votos e, em seguida, pela nota dos filmes.


WITH Top10Movies AS (
    SELECT
        imdb_title_id as Id_filme,
        title as Título,
        genre as Gênero,
        year as Ano,
        avg_vote as Média_votos,
        votes as Qtd_votos,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY votes DESC, avg_vote DESC) AS `rank`
    FROM
        movies_view 
    WHERE year > YEAR(DATE_SUB(NOW(), INTERVAL 11 YEAR))
)
SELECT
    Gênero,
    COUNT(*) AS Total
FROM
    Top10Movies
WHERE `rank` <= 10
GROUP BY Gênero
ORDER BY Total DESC;

-- Insights: Como mencionado no Exercício 1, os filmes de maior sucesso pertencem aos gêneros que dominam o topo desta tabela.

-------------------------------------------------------------------------------------------------
-- Exercicio 3
-- Quais os 50 filmes com menor lucratividade ou que deram prejuízo, nos últimos 30 anos. Considerar apenas valores em dólar ($).

SELECT
    title as Título,
    year as Ano,
    CONCAT('$ ', FORMAT(income_world, 2, 'de_DE')) as Faturamento,
	CONCAT('$ ', FORMAT(budget, 2, 'de_DE')) as Custos,
    CONCAT('$ ', FORMAT(profit, 2, 'de_DE')) as Lucro,
    currency_budget as Moeda
FROM
    movies_view
WHERE
    year > YEAR(DATE_SUB(NOW(), INTERVAL 30 YEAR))
	AND currency_budget = '$'
	AND income_world <> 0
ORDER BY
    profit asc
LIMIT 50;

-------------------------------------------------------------------------------------------------
-- Exercício 4
-- 4 - Selecionar os top 10 filmes baseados nas avaliações dos usuários, para cada ano, nos últimos 20 anos.

-- Criação de uma CTE: Tabela temporária para filtrar os filmes dos últimos 20 anos e criar um ranking.
-- Em seguida, serão selecionados os filmes mais bem avaliados.
-- OBS: Para garantir um ranking mais justo, classificamos primeiro pela quantidade de votos e, depois, pela nota dos filmes.

    
WITH Top10FilmesporAno AS (
	SELECT
		imdb_title_id AS Id_filmes,
		title AS Título,
		year AS Ano,
		avg_vote AS Notas_usuários,
		votes AS Qtd_votos_usuários,
		ROW_NUMBER() OVER (PARTITION BY year ORDER BY votes DESC, avg_vote DESC) AS `Rank`
	FROM
		movies_view 
	WHERE
		year > YEAR(DATE_SUB(NOW(), INTERVAL 21 YEAR))
)
SELECT
    Id_filmes,
    Título,
    Ano,
    Notas_usuários,
    FORMAT(Qtd_votos_usuários,'de_DE') as Qtd_VOtos
FROM
    Top10FilmesporAno
WHERE
    `Rank` <= 10
ORDER BY
    Qtd_votos_usuários DESC;
        
/* Insights:
- Gêneros Populares: Ação e Aventura dominam;
- Super-heróis estão entre os favoritos;
- Correlação: Altas Notas e Muitos Votos - Filmes como "The Dark Knight" (9.0), "Inception" (8.8), e "Interstellar" (8.6) não só têm altas avaliações, mas também um grande número de votos, indicando que são amplamente assistidos e apreciados por um grande público.
- Preferência por Franquias e Sequências:
- Notas Elevadas Nem Sempre Correlacionam com o Número de Votos: Alguns filmes com notas muito altas, como "Parasite" (8.6) e "Dil Bechara" (8.8), têm menos votos em comparação com outros, sugerindo que podem ter um público mais nichado ou serem relativamente novos.  
*/   


   
-------------------------------------------------------------------------------------------------
-- Exercício 5
-- Gerar um relatório com os top 10 filmes mais bem avaliados pela crítica e os top 10 pela avaliação de usuário, contendo também o budget dos filmes.

WITH rank_filmes AS (
    SELECT
        title AS Título,
        'Votos pela Crítica' AS Tipo_de_votos,
        Metascore AS Notas,
        NULL AS Qtd_votos, 
        CONCAT('$ ', FORMAT(budget, 2, 'de_DE')) AS Custos,
        ROW_NUMBER() OVER (ORDER BY metascore DESC) AS ranking
    FROM 
        movies_view
	
    UNION ALL

    SELECT
        title AS Título,
        'Votos Usuários' AS Tipo_de_votos,
        Round((avg_vote),2) AS Notas,
        FORMAT(votes, 'de_DE') AS Qtd_votos,
        CONCAT('$ ', FORMAT(budget, 2, 'de_DE')) AS Custos,
        ROW_NUMBER() OVER (ORDER BY votes DESC, avg_vote DESC) AS ranking
    FROM 
        movies_view 
)
SELECT
    Título,
    Tipo_de_votos,
    Notas,
    Qtd_votos,
    Custos
FROM 
    rank_filmes
WHERE 
    ranking BETWEEN 1 AND 10
ORDER BY 
    Tipo_de_votos, Notas DESC;
    
/*
Clássicos do Cinema: Filmes como "O Poderoso Chefão", "Casablanca" e "O Mágico de Oz" são amplamente reconhecidos como clássicos, recebendo altas avaliações tanto da crítica quanto dos usuários ao longo do tempo.

Qualidade Independente do Orçamento: "Boyhood", com um orçamento modesto, demonstra que filmes de baixo custo podem alcançar reconhecimento crítico e popular.

Investimentos Significativos e Qualidade: Apesar de terem orçamentos substanciais, filmes como "Lawrence da Arábia" e "O Leopardo" ainda são altamente considerados, mostrando que o alto investimento não comprometeu sua qualidade.

Divergência de Percepções: Alguns filmes, como "A Lista de Schindler" e "O Cavaleiro das Trevas", têm avaliações altas do público, mas não são igualmente apreciados pela crítica, sugerindo uma discrepância nas percepções entre esses grupos.

Consistência na Qualidade: Produções como "O Poderoso Chefão" e "O Senhor dos Anéis: O Retorno do Rei" recebem elogios tanto da crítica quanto dos usuários, indicando uma qualidade consistente.

Popularidade e Qualidade: Filmes populares como "Pulp Fiction" e "Forrest Gump" alcançam altas avaliações, demonstrando que podem ser bem-sucedidos comercialmente e ao mesmo tempo manter uma alta qualidade percebida.

*/

-------------------------------------------------------------------------------------------------

-- Exercício 6
-- Gerar um relatório contendo a duração média de 5 gêneros a sua escolha.

-- A função SEC_TO_TIME é uma função do MySQL que converte um valor de segundos em um valor de tempo no formato 'HH:MM'.

SELECT
    genre as Gênero,
    TIME_FORMAT(SEC_TO_TIME(AVG(duration * 60)),'%H:%i:%s') AS Duração_média
FROM 
	movies_view
WHERE 
	genre IN ('Drama', 'Comedy', 'Romance', 'Crime', 'Family')
GROUP BY 	
	genre
ORDER BY duration;

-------------------------------------------------------------------------------------------------
-- Exercício 7 alter
-- Gerar um relatório sobre os 5 filmes mais lucrativos de um ator/atriz(que podemos filtrar), trazendo o nome, ano de exibição, e Lucro obtido. Considerar apenas valores em dólar($).

-- Selecionar o nome do artista para pesquisa, exemplos: 
-- Angelina Jolie
-- George Clooney
-- Brad Pitt
-- Julia Roberts
-- Cameron Diaz

SET @varNomedoartista = 'Brad Pitt';

SELECT
    @varNomedoartista AS 'Ator/Atriz',
    title as Título,
    year as Ano,
    CONCAT('$ ', FORMAT(profit, 2, 'de_DE')) as Lucro
FROM 
	movies_view
WHERE 	
	FIND_IN_SET(@varNomedoartista, actors) 	
	AND currency_budget = '$'
ORDER BY profit desc
LIMIT 5;


/*A função FIND_IN_SET do MySQL é usada para buscar um valor dentro de uma lista de valores separados por vírgula. 
Na query acima, ela procura na coluna "Actors" o nome do ator ou atriz especificado na variável.
*/
-------------------------------------------------------------------------------------------------

-- Exercício 8
-- Baseado em um filme que iremos selecionar, trazer um relatório contendo quais os atores/atrizes participantes, e pra cada ator trazer um campo com a média de avaliação da crítica dos últimos 5 filmes em que esse ator/atriz participou.

-- Definindo o título do filme, exemplos:
-- Salt
-- World War Z
-- Titanic
-- Notte brava a Las Vegas

SET @varNomedoFilme = 'World War Z';

-- CTE para obter os atores/atrizes do filme especificado
WITH movie_cast AS (
    SELECT
        @varNomedoFilme AS Título,
        MOV.imdb_title_id AS Id_filme,
        TIT.imdb_name_id AS Id_atores,
        NAM.name AS 'Ator/Atriz'
    FROM 
		casesql_title_principals TIT
			INNER JOIN casesql_names NAM 
				ON TIT.imdb_name_id = NAM.imdb_name_id
					INNER JOIN movies_view MOV 
						ON TIT.imdb_title_id = MOV.imdb_title_id
    WHERE 
		MOV.title = @varNomedoFilme
		AND TIT.category IN ('actor', 'actress')
),

-- CTE para calcular a média de avaliação dos últimos 5 filmes dos atores/atrizes
actor_ratings AS (
    SELECT
        TIT.imdb_name_id AS Id_atores,
        ROUND(AVG(mov2.metascore),2) AS Média_avaliacao_critica
    FROM 
		casesql_title_principals TIT
			INNER JOIN movies_view mov2 
				ON TIT.imdb_title_id = mov2.imdb_title_id
    WHERE TIT.category IN ('actor', 'actress')
						AND mov2.metascore IS NOT NULL
						AND TIT.imdb_title_id IN (
								  SELECT
										ranked_movies.imdb_title_id
								  FROM (
									  SELECT 
										  TP.imdb_title_id, 
										  TP.imdb_name_id, 
										  ROW_NUMBER() OVER (PARTITION BY TP.imdb_name_id ORDER BY MV.year DESC) AS row_num
									  FROM 
										movies_view MV
											JOIN casesql_title_principals TP 
												ON MV.imdb_title_id = TP.imdb_title_id
										) AS ranked_movies
								WHERE ranked_movies.row_num <= 5)
							GROUP BY TIT.imdb_name_id
)

-- Consulta principal
SELECT
    MC.Título,
    MC.Id_filme,
    MC.Id_atores,
    MC.`Ator/Atriz`,
    AR.Média_avaliacao_critica
FROM 
    movie_cast MC
		LEFT JOIN actor_ratings AR 
			ON MC.Id_atores = AR.Id_atores
ORDER BY 
    MC.`Ator/Atriz`;

-------------------------------------------------------------------------------------------------
-- Exercicío 9
-- Gerar mais duas análises a sua escolha, baseado nessas tabelas (em uma delas deve incluir a análise exploratória de dois campos, um quantitativo e um qualitativo, respectivamente).

/*Comparação do faturamento que atores X atrizes trouxeram para o cinema. TOP 3

O total de faturamento dos filmes pode influenciar a disparidade salarial entre atores e atrizes na indústria cinematográfica, pois afeta fatores como negociação de salários, oportunidades de papéis, percepção de valor e normas da indústria.*/

WITH atores_ordenados AS (
    SELECT
        NAM.name AS 'Ator/Atriz',
        COUNT(TIT.imdb_title_id) as Qtd_filmes,
        CONCAT('$ ', FORMAT(SUM(MOV.income_world), 2, 'de_DE')) as Soma_Faturamento,
        ROUND(AVG(MOV.avg_vote),2) AS Média_notas,
        TIT.category as Categoria,
        ROW_NUMBER() OVER (PARTITION BY TIT.category ORDER BY SUM(MOV.income_world) DESC) AS ranking
    FROM 
		casesql_title_principals TIT
			LEFT JOIN movies_view MOV 
				ON TIT.imdb_title_id = MOV.imdb_title_id
					LEFT JOIN casesql_names NAM 
						ON TIT.imdb_name_id = NAM.imdb_name_id
    WHERE TIT.category IN ('actor', 'actress')
    GROUP BY TIT.imdb_name_id, TIT.category
)
SELECT
	Categoria,
    `Ator/Atriz`,
    Qtd_filmes,
    Soma_Faturamento,
    Média_notas
FROM 
	atores_ordenados
WHERE Categoria = 'actor' AND ranking <= 3
UNION 
SELECT
	Categoria,
    `Ator/Atriz`,
    Qtd_filmes,
    Soma_Faturamento,
    Média_notas
FROM 
	atores_ordenados
WHERE Categoria = 'actress' AND ranking <= 3;

----------------------


/*Vamos analisar os filmes de algumas franquias específicas para extrair insights valiosos sobre seus respectivos faturamentos, médias de avaliação, quantidade de votos, diretores, produtoras e seu desempenho relativo. Isso nos ajudará a entender melhor o sucesso de cada franquia e identificar padrões ou tendências importantes na indústria cinematográfica*/

-- The Lion King
-- Toy Story
-- Batman
-- The Twilight Saga
-- Snow White

SET @varNomedoFilme = '%Toy Story%';

SELECT
    original_title as Título_original,
    title as Título,
    Year as Ano,
	production_company as Produtora,
    director,
    CONCAT('$ ', FORMAT(income_world, 2, 'de_DE')) as Faturamento,
    currency_budget as Moeda,
    avg_vote AS Média_notas,
    FORMAT((votes), 'de_DE') AS Qtd_notas
FROM
    movies_view
WHERE
    original_title LIKE @varNomedoFilme
order by income_world desc;
