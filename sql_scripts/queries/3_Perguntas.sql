USE HSL_TESTE
GO

-- 1) Retornar as informações de "Nome da empresa", "Nome da equipe", "Nome do usuário" e "Qtd de Produtos" associados ao usuário em sua respectiva equipe, 
-- filtrando apenas os produtos com peso maior que 10% e ordenando as informações por "Equipe" e "Usuário".

USE HSL_TESTE
SELECT 
    E.NM_EMPRESA AS 'Nome da Empresa',
    T.NM_EQUIPE AS 'Nome da Equipe',
    U.NM_USUARIO AS 'Nome do Usuário',
    COUNT(P.CD_PRODUTO) AS 'Qtd de Produtos'
FROM 
    USUARIO U
    JOIN EQUIPE_USUARIO EU ON U.CD_USUARIO = EU.CD_USUARIO
    JOIN EQUIPE T ON EU.CD_EQUIPE = T.CD_EQUIPE
    JOIN EMPRESA E ON T.CD_EMPRESA = E.CD_EMPRESA
    JOIN EQUIPE_PRODUTO EP ON T.CD_EQUIPE = EP.CD_EQUIPE
    JOIN PRODUTO P ON EP.CD_PRODUTO = P.CD_PRODUTO
WHERE 
    EP.NR_PESO > 0.10  -- peso maior que 10%
GROUP BY 
    E.NM_EMPRESA, T.NM_EQUIPE, U.NM_USUARIO
ORDER BY 
    T.NM_EQUIPE, U.NM_USUARIO;



-- 2) Retornar o "Nome da equipe" e "Nome do produto" e a "Qtd de Produtos vendidos", porém apenas dos produtos mais vendidos em cada uma das equipes

USE HSL_TESTE;

WITH VendasPorProduto AS (
    SELECT 
        EP.CD_EQUIPE,
        EP.CD_PRODUTO,
        SUM(V.NR_QUANTIDADE) AS QtdVendida
    FROM 
        VENDA V
        JOIN EQUIPE_PRODUTO EP ON V.CD_PRODUTO = EP.CD_PRODUTO
    GROUP BY 
        EP.CD_EQUIPE, EP.CD_PRODUTO
), MaxVendasPorEquipe AS (
    SELECT 
        CD_EQUIPE,
        MAX(QtdVendida) AS MaxVendas
    FROM 
        VendasPorProduto
    GROUP BY 
        CD_EQUIPE
), ProdutosMaisVendidosPorEquipe AS (
    SELECT 
        VP.CD_EQUIPE,
        VP.CD_PRODUTO,
        VP.QtdVendida
    FROM 
        VendasPorProduto VP
        INNER JOIN MaxVendasPorEquipe MV ON VP.CD_EQUIPE = MV.CD_EQUIPE AND VP.QtdVendida = MV.MaxVendas
)
SELECT 
    E.Nm_EQUIPE AS 'Nome da Equipe',
    P.Nm_PRODUTO AS 'Nome do Produto',
    PMV.QtdVendida AS 'Qtd de Produtos Vendidos'
FROM 
    ProdutosMaisVendidosPorEquipe PMV
    JOIN EQUIPE E ON PMV.CD_EQUIPE = E.CD_EQUIPE
    JOIN PRODUTO P ON PMV.CD_PRODUTO = P.CD_PRODUTO
ORDER BY 
    'Nome da Equipe', 'Qtd de Produtos Vendidos' DESC;



-- 3) Retornar o "Nome da equipe", "Nome do produto", "Nome do usuário", "Qtd de Produtos vendidos" e o "Ranking" considerando quantidade de produtos vendidos apenas 
-- no 1º semestre (Janeiro a Junho)
-- Assumindo que a tabela de vendas se chama VENDAS e tem colunas para data da venda (DT_VENDA), código do produto (CD_PRODUTO), código do usuário (CD_USUARIO) e quantidade vendida (QTD_VENDIDA)

USE HSL_TESTE;

WITH VendasSemestre AS (
    SELECT 
        V.CD_EQUIPE, -- Assumindo que esta coluna existe diretamente na tabela VENDA
        V.CD_PRODUTO,
        V.CD_USUARIO,
        SUM(V.NR_QUANTIDADE) AS QtdVendida
    FROM 
        VENDA V
    WHERE 
        V.DT_PERIODO >= '2023-01-01' AND V.DT_PERIODO <= '2023-06-30'
    GROUP BY 
        V.CD_EQUIPE, V.CD_PRODUTO, V.CD_USUARIO
),
RankedVendas AS (
    SELECT
        CD_EQUIPE,
        CD_PRODUTO,
        CD_USUARIO,
        QtdVendida,
        RANK() OVER (ORDER BY QtdVendida DESC) AS Ranking
    FROM 
        VendasSemestre
)
SELECT 
    E.NM_EQUIPE AS 'Nome da Equipe',
    P.NM_PRODUTO AS 'Nome do Produto',
    U.NM_USUARIO AS 'Nome do Usuário',
    RV.QtdVendida AS 'Qtd de Produtos Vendidos',
    RV.Ranking
FROM 
    RankedVendas RV
    JOIN EQUIPE E ON RV.CD_EQUIPE = E.CD_EQUIPE
    JOIN PRODUTO P ON RV.CD_PRODUTO = P.CD_PRODUTO
    JOIN USUARIO U ON RV.CD_USUARIO = U.CD_USUARIO
ORDER BY 
    RV.Ranking;



-- 4) Retornar "Nome da equipe", "Nome do usuário", "Nome do produto", "Nome do Trimestre" (por exemplo "1º Trimestre") e a "média dos objetivos por trimestre" 
-- ao retornar as informações ordenar por "Nome da equipe", "Nome do usuário", "Nome do produto" e "média dos objetivos por trimestre" (decrescente)

USE HSL_TESTE;

WITH ObjetivosPorTrimestre AS (
    SELECT
        EP.CD_EQUIPE,
        O.CD_USUARIO,
        O.CD_PRODUTO,
        CASE 
            WHEN MONTH(O.DT_PERIODO) IN (1, 2, 3) THEN '1º Trimestre'
            WHEN MONTH(O.DT_PERIODO) IN (4, 5, 6) THEN '2º Trimestre'
            WHEN MONTH(O.DT_PERIODO) IN (7, 8, 9) THEN '3º Trimestre'
            WHEN MONTH(O.DT_PERIODO) IN (10, 11, 12) THEN '4º Trimestre'
        END AS NomeTrimestre,
        AVG(O.NR_QUANTIDADE) AS MediaObjetivos
    FROM
        OBJETIVO O
        JOIN EQUIPE_PRODUTO EP ON O.CD_PRODUTO = EP.CD_PRODUTO
    GROUP BY
        EP.CD_EQUIPE, O.CD_USUARIO, O.CD_PRODUTO, MONTH(O.DT_PERIODO)
)
SELECT
    E.NM_EQUIPE AS 'Nome da Equipe',
    U.NM_USUARIO AS 'Nome do Usuário',
    P.NM_PRODUTO AS 'Nome do Produto',
    OT.NomeTrimestre,
    OT.MediaObjetivos
FROM
    ObjetivosPorTrimestre OT
    JOIN EQUIPE E ON OT.CD_EQUIPE = E.CD_EQUIPE
    JOIN USUARIO U ON OT.CD_USUARIO = U.CD_USUARIO
    JOIN PRODUTO P ON OT.CD_PRODUTO = P.CD_PRODUTO
ORDER BY
    E.NM_EQUIPE,
    U.NM_USUARIO,
    P.NM_PRODUTO,
    OT.MediaObjetivos DESC;



-- 5) Como foi possível verificar até aqui, temos informações de Objetivo e Vendas para cada Equipe, Usuário e Produto e agora precisamos retornar as informações abaixo:
-- "Mês", "Nome da equipe", "Nome do usuário", "Nome do produto", "Objetivo", "Venda" e a "Cobertura de atingimento da venda (que é a venda/objetivo)", porém gostaríamos de 
-- retornar somente os menores atingimentos de cobertura para cada um dos meses do ano.

USE HSL_TESTE;

WITH CoberturaCalculada AS (
    SELECT
        MONTH(V.DT_PERIODO) AS Mes,
        E.NM_EQUIPE,
        U.NM_USUARIO,
        P.NM_PRODUTO,
        SUM(O.NR_QUANTIDADE) AS Objetivo,
        SUM(V.NR_QUANTIDADE) AS Venda,
        CAST(CASE WHEN SUM(O.NR_QUANTIDADE) = 0 THEN 0 ELSE SUM(V.NR_QUANTIDADE) * 1.0 / SUM(O.NR_QUANTIDADE) END AS DECIMAL(10, 2)) AS Cobertura
    FROM VENDA V
    JOIN OBJETIVO O ON V.CD_PRODUTO = O.CD_PRODUTO AND V.CD_USUARIO = O.CD_USUARIO
    JOIN EQUIPE_PRODUTO EP ON V.CD_PRODUTO = EP.CD_PRODUTO
    JOIN EQUIPE E ON EP.CD_EQUIPE = E.CD_EQUIPE
    JOIN PRODUTO P ON V.CD_PRODUTO = P.CD_PRODUTO
    JOIN USUARIO U ON V.CD_USUARIO = U.CD_USUARIO
    WHERE V.DT_PERIODO BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY MONTH(V.DT_PERIODO), E.NM_EQUIPE, U.NM_USUARIO, P.NM_PRODUTO
),
RankedCoberturas AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Mes ORDER BY Cobertura ASC, Objetivo DESC) AS Rnk -- Ordena por cobertura ascendente e objetivo descendente para desempate
    FROM CoberturaCalculada
)
SELECT
    Mes,
    NM_EQUIPE AS "Nome da Equipe",
    NM_USUARIO AS "Nome do Usuário",
    NM_PRODUTO AS "Nome do Produto",
    Objetivo,
    Venda,
    Cobertura
FROM RankedCoberturas
WHERE Rnk = 1
ORDER BY Mes;


-- 6) Retornar a lista "Nome do usuário", "Unidades de Produtos vendidos", "Objetivo", e o percentual do atingimento do objetivo no mês de Maio, para o produto 
-- Bactrim e ordenado pela performance em ordem decrescente

USE HSL_TESTE;

SELECT 
    U.NM_USUARIO AS 'Nome do Usuário',
    SUM(V.NR_QUANTIDADE) AS 'Unidades de Produtos Vendidos',
    SUM(O.NR_QUANTIDADE) AS 'Objetivo',
    CASE 
        WHEN SUM(O.NR_QUANTIDADE) = 0 THEN 0 
        ELSE CAST(SUM(V.NR_QUANTIDADE) AS FLOAT) / SUM(O.NR_QUANTIDADE) * 100 
    END AS 'Percentual de Atingimento do Objetivo'
FROM 
    VENDA V
    JOIN OBJETIVO O ON V.CD_PRODUTO = O.CD_PRODUTO AND V.CD_USUARIO = O.CD_USUARIO
    JOIN PRODUTO P ON V.CD_PRODUTO = P.CD_PRODUTO
    JOIN USUARIO U ON V.CD_USUARIO = U.CD_USUARIO
WHERE 
    P.NM_PRODUTO = 'Bactrim'
    AND MONTH(V.DT_PERIODO) = 5  -- Maio
    AND MONTH(O.DT_PERIODO) = 5
GROUP BY 
    U.NM_USUARIO
ORDER BY 
    'Percentual de Atingimento do Objetivo' DESC;


-- 7) Retornar a relação dos produtos, a quantidade vendida de cada um deles e sua representatividade dentro do total de vendas para a 
-- usuária "Yasmin", ordenada pela representatividade decrescente

USE HSL_TESTE;

WITH TotalVendasYasmin AS (
    SELECT 
        SUM(V.NR_QUANTIDADE) AS TotalVendido
    FROM 
        VENDA V
        JOIN USUARIO U ON V.CD_USUARIO = U.CD_USUARIO
    WHERE 
        U.NM_USUARIO = 'Yasmin'
),
VendasPorProduto AS (
    SELECT 
        P.NM_PRODUTO,
        SUM(V.NR_QUANTIDADE) AS QtdVendida
    FROM 
        VENDA V
        JOIN PRODUTO P ON V.CD_PRODUTO = P.CD_PRODUTO
        JOIN USUARIO U ON V.CD_USUARIO = U.CD_USUARIO
    WHERE 
        U.NM_USUARIO = 'Yasmin'
    GROUP BY 
        P.NM_PRODUTO
)
SELECT 
    VP.NM_PRODUTO AS 'Nome do Produto',
    VP.QtdVendida AS 'Quantidade Vendida',
    CAST((CAST(VP.QtdVendida AS FLOAT) / TV.TotalVendido * 100) AS DECIMAL(10, 2)) AS 'Representatividade (%)'
FROM 
    VendasPorProduto VP
    CROSS JOIN TotalVendasYasmin TV
ORDER BY 
    'Representatividade (%)' DESC;



-- 8) Retornar "Nome do usuário", "Nome do produto", a quantidade vendida no segundo trimestre, a quantidade vendida no terceiro trimestre e o crescimento do segundo para o 
-- terceiro trimestre em percentual, apenas daqueles com o Maior e o Menor crescimento

USE HSL_TESTE;

WITH VendasPorTrimestre AS (
    SELECT
        U.NM_USUARIO,
        P.NM_PRODUTO,
        SUM(CASE WHEN MONTH(V.DT_PERIODO) IN (4, 5, 6) THEN V.NR_QUANTIDADE ELSE 0 END) AS VendasQ2,
        SUM(CASE WHEN MONTH(V.DT_PERIODO) IN (7, 8, 9) THEN V.NR_QUANTIDADE ELSE 0 END) AS VendasQ3
    FROM
        VENDA V
        JOIN USUARIO U ON V.CD_USUARIO = U.CD_USUARIO
        JOIN PRODUTO P ON V.CD_PRODUTO = P.CD_PRODUTO
    GROUP BY
        U.NM_USUARIO, P.NM_PRODUTO
),
Crescimento AS (
    SELECT
        *,
        CASE 
            WHEN VendasQ2 = 0 THEN NULL
            ELSE CAST((VendasQ3 - VendasQ2) AS FLOAT) / VendasQ2 * 100 
        END AS CrescimentoPercentual
    FROM VendasPorTrimestre
),
RankingCrescimento AS (
    SELECT
        *,
        RANK() OVER (ORDER BY CrescimentoPercentual DESC) AS RankCresc,
        RANK() OVER (ORDER BY CrescimentoPercentual ASC) AS RankDecresc
    FROM Crescimento
)
SELECT 
    NM_USUARIO,
    NM_PRODUTO,
    VendasQ2,
    VendasQ3,
    CrescimentoPercentual
FROM 
    RankingCrescimento
WHERE 
    RankCresc = 1 OR RankDecresc = 1
ORDER BY 
    CrescimentoPercentual DESC;

-- 9) Retornar uma lista de performance/cobertura (onde performance = Venda / Objetivo) de "Nome do usuário", 
-- "Nome do produto" de todos os meses disponíveis e "Ano", onde a cobertura de cada mês, deve estar por cada coluna.
-- Exibir a "Cobertura", com duas casas decimais
-- Filtrar somente o time de Vendas
-- Ex.:
/*
NR_ANO NM_USUARIO NM_PRODUTO JANEIRO FEVEREIRO MARÇO ABRIL MAIO JUNHO JULHO AGOSTO SETEMBRO OUTUBRO NOVEMBRO DEZEMBRO
2023 André abcalcium-b12 110,71 111,29 119,79 92,63 87,05 98,03 108,62 104,15 101,98 104,76 88,85 94,16
2023 André abcler-abnat 96,89 94,44 120 118,73 87,68 95,7 118,99 94,21 99,13 96,12 135,85 118,13
2023 André Azitromicina 109,8 130,77 91,42 135,21 122,16 128,03 82,64 94,18 93,88 100 109,38 83,73
*/
USE HSL_TESTE;

WITH CoberturaDados AS (
    SELECT
        YEAR(V.DT_PERIODO) AS NR_ANO,
        U.NM_USUARIO,
        P.NM_PRODUTO,
        MONTH(V.DT_PERIODO) AS Mes,
        CASE 
            WHEN SUM(O.NR_QUANTIDADE) = 0 THEN 0
            ELSE CAST(SUM(V.NR_QUANTIDADE) AS FLOAT) / SUM(O.NR_QUANTIDADE) * 100
        END AS Cobertura
    FROM
        VENDA V
        JOIN OBJETIVO O ON V.CD_PRODUTO = O.CD_PRODUTO AND V.CD_USUARIO = O.CD_USUARIO
        JOIN PRODUTO P ON V.CD_PRODUTO = P.CD_PRODUTO
        JOIN USUARIO U ON V.CD_USUARIO = U.CD_USUARIO
        JOIN EQUIPE_USUARIO EU ON U.CD_USUARIO = EU.CD_USUARIO
        JOIN EQUIPE E ON EU.CD_EQUIPE = E.CD_EQUIPE
    WHERE
        E.Nm_EQUIPE = 'Vendas'
    GROUP BY
        YEAR(V.DT_PERIODO),
        U.NM_USUARIO,
        P.NM_PRODUTO,
        MONTH(V.DT_PERIODO)
),
CoberturaPivot AS (
    SELECT *
    FROM CoberturaDados
    PIVOT (
        AVG(Cobertura)
        FOR Mes IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
    ) AS PivotTable
)
SELECT 
    NR_ANO,
    Nm_USUARIO,
    Nm_PRODUTO,
    CAST([1] AS DECIMAL(10, 2)) AS 'Janeiro',
    CAST([2] AS DECIMAL(10, 2)) AS 'Fevereiro',
    CAST([3] AS DECIMAL(10, 2)) AS 'Março',
    CAST([4] AS DECIMAL(10, 2)) AS 'Abril',
    CAST([5] AS DECIMAL(10, 2)) AS 'Maio',
    CAST([6] AS DECIMAL(10, 2)) AS 'Junho',
    CAST([7] AS DECIMAL(10, 2)) AS 'Julho',
    CAST([8] AS DECIMAL(10, 2)) AS 'Agosto',
    CAST([9] AS DECIMAL(10, 2)) AS 'Setembro',
    CAST([10] AS DECIMAL(10, 2)) AS 'Outubro',
    CAST([11] AS DECIMAL(10, 2)) AS 'Novembro',
    CAST([12] AS DECIMAL(10, 2)) AS 'Dezembro'
FROM 
    CoberturaPivot
ORDER BY 
    NR_ANO, NM_USUARIO, NM_PRODUTO;

-- 10) Quem foi o melhor (em quantidade vendida) vendedor de Paracetamol no último trimestre do ano, considerando
-- todos os times da empresa ALPHALAB?

USE HSL_TESTE;

SELECT TOP 1
    U.Nm_USUARIO AS [Nome do Vendedor],
    SUM(V.NR_QUANTIDADE) AS [Quantidade Vendida]
FROM 
    VENDA V
    JOIN PRODUTO P ON V.CD_PRODUTO = P.CD_PRODUTO
    JOIN USUARIO U ON V.CD_USUARIO = U.CD_USUARIO
    JOIN EQUIPE_USUARIO EU ON U.CD_USUARIO = EU.CD_USUARIO
    JOIN EQUIPE E ON EU.CD_EQUIPE = E.CD_EQUIPE
    JOIN EMPRESA EM ON E.CD_EMPRESA = EM.CD_EMPRESA
WHERE 
    P.Nm_PRODUTO = 'Paracetamol'
    AND EM.Nm_EMPRESA = 'ALPHALAB'
    AND V.DT_PERIODO BETWEEN '2023-10-01' AND '2023-12-31'
GROUP BY 
    U.Nm_USUARIO
ORDER BY 
    [Quantidade Vendida] DESC;

-- 11) Quem foi o pior vendedor (em quantidade vendida) de Nimesulida no primeiro trimestre do ano, considerando
-- todos os times da empresa Labmais?

USE HSL_TESTE;

SELECT TOP 1
    U.Nm_USUARIO AS [Nome do Vendedor],
    SUM(V.NR_QUANTIDADE) AS [Quantidade Vendida]
FROM 
    VENDA V
    JOIN PRODUTO P ON V.CD_PRODUTO = P.CD_PRODUTO
    JOIN USUARIO U ON V.CD_USUARIO = U.CD_USUARIO
    JOIN EQUIPE_USUARIO EU ON U.CD_USUARIO = EU.CD_USUARIO
    JOIN EQUIPE E ON EU.CD_EQUIPE = E.CD_EQUIPE
    JOIN EMPRESA EM ON E.CD_EMPRESA = EM.CD_EMPRESA
WHERE 
    P.Nm_PRODUTO = 'Nimesulida'
    AND EM.Nm_EMPRESA = 'Labmais'
    AND YEAR(V.DT_PERIODO) = 2023  -- Especificando o ano de 2023
    AND MONTH(V.DT_PERIODO) BETWEEN 1 AND 3 -- Primeiro trimestre
GROUP BY 
    U.NM_USUARIO
ORDER BY 
    [Quantidade Vendida] ASC; -- Procurando pelo menor vendedor



-- 12) Quem foi o melhor (cobertura) vendedor de Meloxicam neste ano, considerando
-- todos os times da empresa ALPHALAB?

USE HSL_TESTE;

SELECT TOP 1
    U.Nm_USUARIO AS [Nome do Vendedor],
    SUM(V.NR_QUANTIDADE) AS [Quantidade Vendida],
    SUM(O.NR_QUANTIDADE) AS [Objetivo de Vendas Total],
    (CAST(SUM(V.NR_QUANTIDADE) AS FLOAT) / SUM(O.NR_QUANTIDADE)) * 100 AS [Percentual de Cobertura]
FROM 
    VENDA V
    INNER JOIN PRODUTO P ON V.CD_PRODUTO = P.CD_PRODUTO
    INNER JOIN USUARIO U ON V.CD_USUARIO = U.CD_USUARIO
    INNER JOIN EQUIPE_USUARIO EU ON U.CD_USUARIO = EU.CD_USUARIO
    INNER JOIN EQUIPE E ON EU.CD_EQUIPE = E.CD_EQUIPE
    INNER JOIN EMPRESA EM ON E.CD_EMPRESA = EM.CD_EMPRESA
    LEFT JOIN OBJETIVO O ON V.CD_PRODUTO = O.CD_PRODUTO AND V.CD_USUARIO = O.CD_USUARIO AND YEAR(O.DT_PERIODO) = 2023
WHERE 
    P.Nm_PRODUTO = 'Meloxicam'
    AND EM.Nm_EMPRESA = 'ALPHALAB'
    AND YEAR(V.DT_PERIODO) = 2023
GROUP BY 
    U.Nm_USUARIO
ORDER BY 
    [Percentual de Cobertura] DESC;

