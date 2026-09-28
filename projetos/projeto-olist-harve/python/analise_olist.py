# =====================================================
# PROJETO DE ANÁLISE DE DADOS — OLIST
# Trabalho final — Curso de Analista de Dados Harve
# =====================================================

import pandas as pd
import mysql.connector
from dotenv import load_dotenv
import os


# =====================================================
# 1. CONEXÃO COM O BANCO DE DADOS
# =====================================================

# Carregar as informações do arquivo .env
load_dotenv()

conexao = mysql.connector.connect(
    host=os.getenv("DB_HOST"),
    port=int(os.getenv("DB_PORT")),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME")
)

print("Conexão realizada com sucesso!")


# =====================================================
# 2. CARREGAMENTO DOS DADOS
# Objetivo: carregar a tabela de pedidos para o Python.
# =====================================================

query = "SELECT * FROM olist_orders_dataset"

orders = pd.read_sql(query, conexao)

print("\nDados carregados com sucesso!")
print(orders.head())

# =====================================================
# 3. ANÁLISE INICIAL DOS DADOS
# Objetivo: verificar a estrutura da tabela e identificar
# possíveis valores nulos e tipos de dados.
# =====================================================

print("\nInformações dos dados:")
print(orders.info())

print("\nValores nulos:")
print(orders.isnull().sum())

# =====================================================
# 4. TRATAMENTO DAS DATAS
# Objetivo: converter as colunas de data para o formato
# datetime e facilitar as análises posteriores.
# =====================================================

colunas_data = [
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date"
]

for coluna in colunas_data:
    orders[coluna] = pd.to_datetime(orders[coluna], errors="coerce")

print("\nTipos de dados após o tratamento:")
print(orders.dtypes)

# =====================================================
# 5. CRIAÇÃO DE UMA COLUNA DE APOIO
# Objetivo: calcular o tempo de entrega dos pedidos
# que possuem as datas necessárias.
# =====================================================

orders["dias_entrega"] = (
    orders["order_delivered_customer_date"]
    - orders["order_purchase_timestamp"]
).dt.days

print("\nExemplo da coluna de dias de entrega:")
print(orders[["order_id", "dias_entrega"]].head())

# =====================================================
# 6. EXPORTAÇÃO DOS DADOS TRATADOS
# Objetivo: salvar os dados tratados em CSV para
# utilizar posteriormente no Power BI.
# =====================================================

orders.to_csv(
    "pedidos_tratados.csv",
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo pedidos_tratados.csv criado com sucesso!")

# =====================================================
# 7. EXPORTAÇÃO DOS ITENS DOS PEDIDOS
# Objetivo: carregar os itens dos pedidos e salvar
# os dados em CSV para utilizar no Power BI.
# =====================================================

query_itens = """
SELECT *
FROM olist_order_items_dataset
"""

itens = pd.read_sql(query_itens, conexao)

print("\nItens carregados com sucesso!")
print(itens.head())

# Salvar os dados em CSV
itens.to_csv(
    "itens_tratados.csv",
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo itens_tratados.csv criado com sucesso!")

# =====================================================
# 8. EXPORTAÇÃO DAS AVALIAÇÕES
# Objetivo: carregar as avaliações dos clientes e salvar
# os dados em CSV para utilizar no Power BI.
# =====================================================

query_avaliacoes = """
SELECT *
FROM olist_order_reviews_dataset
"""

avaliacoes = pd.read_sql(query_avaliacoes, conexao)

print("\nAvaliações carregadas com sucesso!")
print(avaliacoes.head())

# Salvar os dados em CSV
avaliacoes.to_csv(
    "avaliacoes_tratadas.csv",
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo avaliacoes_tratadas.csv criado com sucesso!")

# =====================================================
# 9. EXPORTAÇÃO DOS PRODUTOS
# Objetivo: carregar os produtos e suas categorias para
# utilizar posteriormente no Power BI.
# =====================================================

query_produtos = """
SELECT *
FROM olist_products_dataset
"""

produtos = pd.read_sql(query_produtos, conexao)

print("\nProdutos carregados com sucesso!")
print(produtos.head())

# Salvar os dados em CSV
produtos.to_csv(
    "produtos_tratados.csv",
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo produtos_tratados.csv criado com sucesso!")

# ============================================================
# 10. EXPORTAÇÃO DOS CLIENTES
# Objetivo: criar uma tabela agregada por cliente para
# analisar clientes novos e recorrentes no Power BI.
# ============================================================

query_clientes = """
SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS qtd_pedidos,
    ROUND(SUM(p.payment_value), 2) AS valor_total,
    MIN(o.order_purchase_timestamp) AS data_primeira_compra,
    MAX(o.order_purchase_timestamp) AS data_ultima_compra
FROM olist_orders_dataset o
INNER JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
GROUP BY o.customer_id
"""

clientes = pd.read_sql(query_clientes, conexao)

# Classificar clientes como novos ou recorrentes
clientes["cliente_tipo"] = clientes["qtd_pedidos"].apply(
    lambda x: "Recorrente" if x > 1 else "Novo"
)

print("\nClientes carregados com sucesso!")
print(clientes.head())

# Salvar os dados em CSV
clientes.to_csv(
    "clientes_tratados.csv",
    index=False,
    encoding="utf-8-sig"
)

print("\nArquivo clientes_tratados.csv criado com sucesso!")

# Fechar a conexão
conexao.close()
