# Pharma-Commercial-Insights

## Strategic SQL Analysis: Importing, Normalizing, and Advanced Analytics

![MicrosoftSQLServer](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927.svg?style=for-the-badge&logo=Microsoft-SQL-Server&logoColor=white)
![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-007ACC.svg?style=for-the-badge&logo=Visual-Studio-Code&logoColor=white)
![DBeaver](https://img.shields.io/badge/DBeaver-382923.svg?style=for-the-badge&logo=DBeaver&logoColor=white)

### Repository Structure

```nohighlight
├── README.md                                    <- Project documentation.
├── data
│   ├── BASE_OBJETIVOS.csv                        <- Raw data to be normalized.
│   └── BASE_VENDAS.csv                           <- Raw data to be normalized.
│
├── docs                                          <- Diagram in .png
│
├── sql_scripts
│   ├── normalization
│   │   ├── LOAD_OBJETIVO.sql                     <- Script to load normalized data into OBJETIVO table.
│   │   ├── LOAD_VENDA.sql                        <- Script to load normalized data into VENDA table.
│   │   ├── Normalizacao_CreateTempTABLES.sql     <- Script to create temporary table.
│   │   ├── Normalizacao_InsertCSVtoTempTABLE.sql <- Script to load CSV data into temporary table.
│   │   ├── Normalizacao_TempObjetivos-CD.sql     <- Script for normalization with related codes.
│   │   └── Normalizacao_TempVendas-CD.sql        <- Script for normalization with related codes.
│   ├── queries
│   │   └── 3_Perguntas.sql                       <- Questions to be answered using the data.
│   └── setup
│       ├── 0_CreateDatabase.sql                  <- Script to create the database.
│       ├── 1_CreateTable.sql                     <- Script to create relational tables.
│       └── 2_Insert.sql                          <- Data insertion.
```

### Project Context

This repository was created with the dual purpose of sharing solutions developed for the challenges proposed in the selection process for the position of Senior Incentive Analyst at HSL Tecnologia, as well as documenting the technical data preparation process.
Installation and Configuration of SQL Server Locally

The first step was to install and configure SQL Server on my machine and connect to DBeaver for data handling.
CSV Import to SQL Server

The second step of this project involves the careful import of data from CSV files into temporary tables in SQL Server.
Data Normalization and Structuring

The normalization step follows, where imported data are restructured and optimized.

Scripts for this phase are available in the sql_script\normalization folder.

### Files Structure
<details>
  <summary>SCRIPTS</summary>

  * 0_CreateDatabase.sql
  * 1_CreateTable.sql
  * 2_Insert.sql
  * 3_Perguntas.sql
</details>

<details>
  <summary>ARQUIVOS</summary>

  * BASE_OBJETIVOS.csv
    * `EAN`
    * `EQUIPE`
    * `VENDEDOR`
    * `JAN`
    * `FEV`
    * `MAR`
    * `ABR`
    * `MAI`
    * `JUN`
    * `JUL`
    * `AGO`
    * `SET`
    * `OUT`
    * `NOV`
    * `DEZ`
  * BASE_VENDAS.csv
    * `EAN`
    * `EQUIPE`
    * `VENDEDOR`
    * `JAN`
    * `FEV`
    * `MAR`
    * `ABR`
    * `MAI`
    * `JUN`
    * `JUL`
    * `AGO`
    * `SET`
    * `OUT`
    * `NOV`
    * `DEZ`
</details>

<details>
  <summary>DATABASE</summary>

* `OBJETIVO`
	* `CD_VENDA` PRIMARY KEY
	* `CD_PRODUTO` FOREIGN KEY
	* `CD_EQUIPE` FOREIGN KEY
	* `CD_USUARIO` FOREIGN KEY
	* `DT_PERIODO`
	* `NR_QUANTIDADE`
* `VENDA`
	* `CD_VENDA` PRIMARY KEY
	* `CD_PRODUTO` FOREIGN KEY
	* `CD_EQUIPE` FOREIGN KEY
	* `CD_USUARIO` FOREIGN KEY
	* `DT_PERIODO`
	* `NR_QUANTIDADE`
* `PRODUTO`
	* `CD_PRODUTO` PRIMARY KEY
	* `NM_PRODUTO`
	* `EAN`
* `EQUIPE`
	* `CD_EQUIPE` PRIMARY KEY
	* `NM_EQUIPE`
	* `CD_EMPRESA` FOREIGN KEY
* `EMPRESA`
	* `CD_EMPRESA` PRIMARY KEY
	* `NN_EMPRESA`
* `USARIO`
	* `CD_USUARIO` PRIMARY KEY
	* `NM_USUARIO`
* `EQUIPE_PRODUTO`
	* `CD_EQUIPE_PRODUTO` PRIMARY KEY
	* `CD_EQUIPE` FOREIGN KEY
	* `CD_PRODUTO` FOREIGN KEY
	* `NR_PESO`
* `EMPRESA_PRODUTO`
	* `CD_EMPRESA_PRODUTO` PRIMARY KEY
	* `CD_EMPRESA` FOREIGN KEY
	* `CD_PRODUTO` FOREIGN KEY
* `EQUIPE_USUARIO`
	* `CD_EQUIPE_USUARIO` PRIMARY KEY
	* `CD_EQUIPE` FOREIGN KEY
	* `CD_USUARIO` FOREIGN KEY
* `USUARIO_EMPRESA`
	* `CD_EMPRESA_USUARIO` PRIMARY KEY
	* `CD_EMPRESA` FOREIGN KEY
	* `CD_USUARIO` FOREIGN KEY
</details>

### Diagrama Relaciona da banco de dados
![Diagrama](https://github.com/jlfenerich/HSL-Processo-Seletivo/blob/main/docs/master%20-%20HSL_TESTE%20-%20dbo.png?raw=true)

---

### Project Objectives

1. **Team and Product Analysis**:
   - **Objective**: Return the information of "Company name", "Team name", "User name", and "Quantity of Products" associated with the user in their respective team.
   - **Filter**: Products with a weight greater than 10%.
   - **Sorting**: By "Team" and "User".

2. **Best-Selling Products by Team**:
   - **Objective**: Return "Team name", "Product name", and the "Quantity of Products sold".
   - **Specification**: Only for the best-selling products in each team.

3. **Sales and Ranking in the First Semester**:
   - **Objective**: Return "Team name", "Product name", "User name", "Quantity of Products sold", and the "Ranking".
   - **Period**: Only in the 1st semester (January to June).

4. **Objectives by Quarter**:
   - **Objective**: Return "Team name", "User name", "Product name", "Quarter name" (e.g., "1st Quarter") and the "average objectives per quarter".
   - **Sorting**: By "Team name", "User name", "Product name", and "average objectives per quarter" (descending).

5. **Monthly Sales Coverage**:
   - **Objective**: Return "Month", "Team name", "User name", "Product name", "Objective", "Sale", and the "Sales achievement coverage (sale/objective)".
   - **Specification**: Only the lowest coverage achievements for each month.

6. **Bactrim Sales Performance in May**:
   - **Objective**: Return "User name", "Units of Products sold", "Objective", and the percentage of objective achievement in May, for the product Bactrim.
   - **Sorting**: By performance in descending order.

7. **Yasmin's Sales and Representativeness**:
   - **Objective**: Return "Product name", the quantity sold of each, and its representativeness in the total sales of the user "Yasmin".
   - **Sorting**: By representativeness descending.

8. **Quarterly Sales Growth**:
   - **Objective**: Return "User name", "Product name", the quantity sold in the second quarter, the quantity sold in the third quarter, and the percentage growth from the second to the third quarter.
   - **Specification**: Only for the highest and lowest growths.

9. **Monthly Performance/Coverage of Sales**:
   - **Objective**: Return a list of performance/coverage (Sale / Objective) of "User name", "Product name" for all months and "Year".
   - **Details**: Coverage of each month in separate columns with two decimal places.
   - **Filter**: Only for the Sales team.

10. **Best Paracetamol Seller in the Last Quarter**:
    - **Objective**: Identify the "User name" who was the best seller of Paracetamol in the last quarter of the year.
    - **Company**: Considering all teams of the company ALPHALAB.

11. **Worst Nimesulida Seller in the First Quarter**:
    - **Objective**: Identify the "User name" who was the worst seller of Nimesulida in the first quarter of the year.
    - **Company**: Considering all teams of the company Labmais.

12. **Best Meloxicam Seller of the Year**:
    - **Objective**: Identify the "User name" who was the best (coverage) seller of Meloxicam this year.
    - **Company**: Considering all teams of the company ALPHALAB.

