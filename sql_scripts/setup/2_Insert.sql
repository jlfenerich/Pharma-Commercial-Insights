USE HSL_TESTE
GO

DECLARE @CD_EMPRESA_LABMAIS INT,
        @CD_EMPRESA_ALPHALAB INT

-- Empresas
INSERT INTO EMPRESA VALUES ('Labmais')
SELECT @CD_EMPRESA_LABMAIS = SCOPE_IDENTITY()

INSERT INTO EMPRESA VALUES ('Alphalab')
SELECT @CD_EMPRESA_ALPHALAB = SCOPE_IDENTITY()

-- Produtos
INSERT INTO PRODUTO VALUES ('Nimesulida', '1236774484862')
INSERT INTO PRODUTO VALUES ('Azitromicina', '4600312108192')
INSERT INTO PRODUTO VALUES ('Bromoprida','2411876356324')
INSERT INTO PRODUTO VALUES ('Paroxetina','5892103329345')
INSERT INTO PRODUTO VALUES ('Paracetamol','7055812062124')
INSERT INTO PRODUTO VALUES ('Venlafaxina','4629526767636')
INSERT INTO PRODUTO VALUES ('Meloxicam','7130188814477')
INSERT INTO PRODUTO VALUES ('Nitrofurantoína','7387011391563')
INSERT INTO PRODUTO VALUES ('abcalcium-b12','9581071715309')
INSERT INTO PRODUTO VALUES ('abcler-abnat','8800809928833')
INSERT INTO PRODUTO VALUES ('acebrofilina','7346695864115')
INSERT INTO PRODUTO VALUES ('bacinantrat','5629915705967')
INSERT INTO PRODUTO VALUES ('bactrim','5534351511007')
INSERT INTO PRODUTO VALUES ('belfaren-comprimido','2686267116626')
INSERT INTO PRODUTO VALUES ('kalostop','7251452900182')

-- Usuarios
INSERT INTO USUARIO VALUES ('Yasmin')
INSERT INTO USUARIO VALUES ('Isabel')
INSERT INTO USUARIO VALUES ('Diana')
INSERT INTO USUARIO VALUES ('Vitor')
INSERT INTO USUARIO VALUES ('Maurício')
INSERT INTO USUARIO VALUES ('Júlia')
INSERT INTO USUARIO VALUES ('Leticia')
INSERT INTO USUARIO VALUES ('Calebe')
INSERT INTO USUARIO VALUES ('Igor')
INSERT INTO USUARIO VALUES ('Ângelo')
INSERT INTO USUARIO VALUES ('Catarina')
INSERT INTO USUARIO VALUES ('Micaela')
INSERT INTO USUARIO VALUES ('Emanuel')
INSERT INTO USUARIO VALUES ('André')
INSERT INTO USUARIO VALUES ('Tiago')
INSERT INTO USUARIO VALUES ('Sarah')
INSERT INTO USUARIO VALUES ('Vitória')
INSERT INTO USUARIO VALUES ('Dulce')
INSERT INTO USUARIO VALUES ('Rafael')
INSERT INTO USUARIO VALUES ('Guilherme')

-- Empresa x Produto
INSERT INTO EMPRESA_PRODUTO (CD_EMPRESA, CD_PRODUTO)
SELECT A.CD_EMPRESA, B.CD_PRODUTO 
  FROM EMPRESA A
 CROSS JOIN PRODUTO B
 WHERE A.NM_EMPRESA = 'Labmais'
   AND B.NM_PRODUTO IN ('Nimesulida', 'acebrofilina', 'bactrim', 'kalostop', 'Venlafaxina', 'Nitrofurantoína')

INSERT INTO EMPRESA_PRODUTO (CD_EMPRESA, CD_PRODUTO)
SELECT A.CD_EMPRESA, B.CD_PRODUTO 
  FROM EMPRESA A
 CROSS JOIN
       (
        SELECT A.CD_PRODUTO
          FROM PRODUTO A
          LEFT JOIN EMPRESA_PRODUTO B
            ON A.CD_PRODUTO = B.CD_PRODUTO
         WHERE B.CD_PRODUTO IS NULL
       )B
 WHERE A.NM_EMPRESA = 'Alphalab'

 -- Empresa x Usuário
INSERT INTO EMPRESA_USUARIO (CD_EMPRESA, CD_USUARIO)
SELECT @CD_EMPRESA_LABMAIS, CD_USUARIO
  FROM USUARIO
 WHERE NM_USUARIO IN ('Yasmin', 'Isabel', 'Diana', 'Vitor', 'Maurício', 'Júlia', 'Leticia', 'Calebe', 'Igor', 'Ângelo')

UNION

SELECT @CD_EMPRESA_ALPHALAB, CD_USUARIO
  FROM USUARIO
 WHERE NM_USUARIO IN ('Catarina', 'Micaela', 'André', 'Tiago', 'Sarah', 'Vitória', 'Dulce', 'Rafael', 'Guilherme')

-- Equipe
INSERT INTO EQUIPE VALUES ('Comercial', @CD_EMPRESA_LABMAIS)
INSERT INTO EQUIPE VALUES ('Visitação Médica', @CD_EMPRESA_LABMAIS)
INSERT INTO EQUIPE VALUES ('Hospitalar', @CD_EMPRESA_ALPHALAB)
INSERT INTO EQUIPE VALUES ('Vendas', @CD_EMPRESA_ALPHALAB)

-- Equipe x Usuario
INSERT INTO EQUIPE_USUARIO
SELECT A.CD_EQUIPE, B.CD_USUARIO 
  FROM EQUIPE A
  JOIN EMPRESA_USUARIO B
    ON A.CD_EMPRESA = B.CD_EMPRESA

-- Equipe x Produto
INSERT INTO EQUIPE_PRODUTO
SELECT B.CD_EQUIPE, A.CD_PRODUTO,
       CASE WHEN B.NM_EQUIPE = 'Comercial' THEN    
                                                        CASE WHEN C.EAN = '7346695864115' THEN .15 
                                                             WHEN C.EAN = '5534351511007' THEN .2
                                                             WHEN C.EAN = '7251452900182' THEN .1
                                                             WHEN C.EAN = '1236774484862' THEN .18
                                                             WHEN C.EAN = '7387011391563' THEN .17
                                                             WHEN C.EAN = '4629526767636' THEN .2 END
            WHEN B.NM_EQUIPE = 'Hospitalar' THEN    
                                                        CASE WHEN C.EAN = '9581071715309' THEN .05 
                                                             WHEN C.EAN = '8800809928833' THEN .12
                                                             WHEN C.EAN = '4600312108192' THEN .19
                                                             WHEN C.EAN = '5629915705967' THEN .15
                                                             WHEN C.EAN = '2686267116626' THEN .09
                                                             WHEN C.EAN = '2411876356324' THEN .06
                                                             WHEN C.EAN = '7130188814477' THEN .04
                                                             WHEN C.EAN = '7055812062124' THEN .14
                                                             WHEN C.EAN = '5892103329345' THEN .16 END
            WHEN B.NM_EQUIPE = 'Vendas' THEN    
                                                        CASE WHEN C.EAN = '9581071715309' THEN .03 
                                                             WHEN C.EAN = '8800809928833' THEN .07
                                                             WHEN C.EAN = '4600312108192' THEN .05
                                                             WHEN C.EAN = '5629915705967' THEN .15
                                                             WHEN C.EAN = '2686267116626' THEN .09
                                                             WHEN C.EAN = '2411876356324' THEN .16
                                                             WHEN C.EAN = '7130188814477' THEN .14
                                                             WHEN C.EAN = '7055812062124' THEN .17
                                                             WHEN C.EAN = '5892103329345' THEN .14 END
            WHEN B.NM_EQUIPE = 'Visitação Médica' THEN    
                                                        CASE WHEN C.EAN = '7346695864115' THEN .25
                                                             WHEN C.EAN = '5534351511007' THEN .1
                                                             WHEN C.EAN = '7251452900182' THEN .07
                                                             WHEN C.EAN = '1236774484862' THEN .15
                                                             WHEN C.EAN = '7387011391563' THEN .32
                                                             WHEN C.EAN = '4629526767636' THEN .11 END END
  FROM EMPRESA_PRODUTO A
  JOIN EQUIPE B
    ON A.CD_EMPRESA = B.CD_EMPRESA
  JOIN PRODUTO C
    ON A.CD_PRODUTO = C.CD_PRODUTO
 ORDER BY B.NM_EQUIPE, C.NM_PRODUTO
