# Análise e dashboard no Power BI

## 1. Objetivo

Depois de realizar a exploração dos dados com SQL e o tratamento com Python, utilizei o Power BI para construir a etapa visual do projeto.

Um dos objetivos deste trabalho foi colocar em prática o que foi aprendido durante o curso, passando por todas as etapas de um projeto de análise de dados: preparação dos dados, modelagem, criação de indicadores, construção de visualizações, análise dos resultados e apresentação final.

Por isso, não utilizei uma base já pronta diretamente no Power BI.

Utilizei os arquivos CSV que foram preparados anteriormente com Python e que estão disponíveis na pasta `python` deste projeto.

O fluxo completo ficou:

**MySQL → SQL → Python/Pandas → CSV tratados → Power BI**

---

## 2. Utilização dos arquivos tratados em Python

Os arquivos utilizados no Power BI foram gerados na etapa anterior com Python.

Foram utilizados:

- `pedidos_tratados.csv`
- `itens_tratados.csv`
- `produtos_tratados.csv`
- `avaliacoes_tratadas.csv`
- `clientes_tratados.csv`

A ideia foi utilizar no Power BI exatamente os dados que haviam sido preparados anteriormente, mantendo uma sequência entre as etapas do projeto.

Isso também permitiu demonstrar na prática a integração entre as ferramentas utilizadas durante o curso.

---

## 3. Importação dos dados

Depois de gerar os CSVs, fiz a importação dos arquivos para o Power BI.

Antes de começar a criar os gráficos, procurei verificar:

- nomes das colunas;
- tipos de dados;
- datas;
- valores numéricos;
- campos utilizados nos relacionamentos;
- possíveis valores nulos;
- consistência dos dados importados.

Essa etapa foi importante porque um erro no tipo de dado ou no relacionamento entre as tabelas poderia afetar os resultados dos gráficos.

---

## 4. Organização do modelo de dados

Depois da importação, organizei as tabelas no modelo do Power BI.

A estrutura foi pensada seguindo a lógica de um modelo dimensional, utilizando uma organização próxima ao modelo estrela.

A ideia foi separar as informações de acordo com sua função dentro da análise, evitando colocar todos os dados em uma única tabela.

As principais tabelas utilizadas foram:

### Tabelas de dados

- `pedidos_tratados`
- `itens_tratados`
- `avaliacoes_tratadas`

### Tabelas de dimensão

- `produtos_tratados`
- `clientes_tratados`
- `Dim_Calendario`

Essa organização facilitou a utilização dos filtros e a criação das análises.

---

## 5. Relacionamentos entre as tabelas

Depois de importar as tabelas, criei e validei os relacionamentos no modelo.

Os principais relacionamentos utilizados foram:

### Avaliações → Pedidos

`avaliacoes_tratadas[order_id]`

relacionado com:

`pedidos_tratados[order_id]`

Relacionamento:

**Muitos para um (*:1)**

---

### Itens → Pedidos

`itens_tratados[order_id]`

relacionado com:

`pedidos_tratados[order_id]`

Relacionamento:

**Muitos para um (*:1)**

---

### Itens → Produtos

`itens_tratados[product_id]`

relacionado com:

`produtos_tratados[product_id]`

Relacionamento:

**Muitos para um (*:1)**

---

### Pedidos → Clientes

`pedidos_tratados[customer_id]`

relacionado com:

`clientes_tratados[customer_id]`

Relacionamento:

**Muitos para um (*:1)**

---

### Pedidos → Calendário

`pedidos_tratados[Data_Compra]`

relacionado com:

`Dim_Calendario[Date]`

Relacionamento:

**Muitos para um (*:1)**

A tabela de calendário foi utilizada para facilitar as análises de evolução ao longo do tempo.

---

## 6. Modelo em formato estrela

A organização do modelo foi feita utilizando a lógica de um modelo estrela, separando as tabelas utilizadas como base dos acontecimentos das tabelas utilizadas para classificação e análise.

A tabela de pedidos funciona como uma das principais tabelas do modelo, enquanto informações como calendário, produtos e clientes ajudam a filtrar e analisar os dados.

De forma simplificada, a estrutura ficou organizada assim:

```text
                         Dim_Calendario
                               │
                               │
                               ▼
Clientes ───────────────► Pedidos ◄────────────── Avaliações
                              │
                              │
                              ▼
                            Itens
                              │
                              │
                              ▼
                           Produtos
