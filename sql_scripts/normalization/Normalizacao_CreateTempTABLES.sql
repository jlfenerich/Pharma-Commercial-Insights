
-- Criação das tabelas temporárias para armazenar os dados do arquivo CSV de Objetivos
CREATE TABLE TempObjetivos (
    EAN BIGINT,
    EQUIPE VARCHAR(255),
    VENDEDOR VARCHAR(255),
    JAN INT,
    FEV INT,
    MAR INT,
    ABR INT,
    MAI INT,
    JUN INT,
    JUL INT,
    AGO INT,
    SET9 INT,
    OUT10 INT,
    NOV INT,
    DEZ INT
);

-- Criação das tabelas temporárias para armazenar os dados do arquivo CSV de Vendas
CREATE TABLE TempVendas (
    EAN BIGINT,
    EQUIPE VARCHAR(255),
    VENDEDOR VARCHAR(255),
    JAN INT,
    FEV INT,
    MAR INT,
    ABR INT,
    MAI INT,
    JUN INT,
    JUL INT,
    AGO INT,
    SET9 INT,
    OUT10 INT,
    NOV INT,
    DEZ INT
);
