# Tratamento e preparação dos dados com Python

## 1. Objetivo

Nesta etapa do projeto, utilizei Python para preparar os dados que seriam utilizados posteriormente no Power BI.

O objetivo foi transformar os dados extraídos do banco de dados MySQL em arquivos estruturados e prontos para análise, mantendo o processo organizado e facilitando as validações antes da construção dos dashboards.

---

## 2. Tecnologias utilizadas

- Python
- Pandas
- MySQL
- SQL
- Power BI

O código principal desta etapa está no arquivo:

`analise_olist.py`

As consultas SQL utilizadas na análise estão documentadas separadamente no arquivo:

`../analises_olist.sql`

---

## 3. Fluxo de tratamento

O processo desenvolvido foi:

**MySQL → SQL → Python/Pandas → CSV tratados → Power BI**

Primeiro, os dados foram explorados e consultados no banco de dados utilizando SQL. Em seguida, utilizei Python e Pandas para carregar os resultados, realizar os tratamentos necessários e gerar os arquivos utilizados no Power BI.

A separação dessas etapas facilitou a organização do projeto e permitiu validar os dados antes da criação das visualizações.

---

## 4. Conexão com o banco de dados

O script Python realiza a conexão com o banco de dados MySQL e executa as consultas necessárias para obter os dados utilizados no projeto.

As informações de acesso ao banco foram mantidas em um arquivo `.env` local.

Por segurança, esse arquivo não foi incluído no GitHub, pois contém informações de acesso ao banco de dados.

---

## 5. Tratamento realizado

Após carregar os dados, utilizei Pandas para organizar os DataFrames e preparar os arquivos para utilização no Power BI.

Entre os tratamentos realizados estão:

- seleção das informações necessárias para cada análise;
- organização das colunas;
- tratamento dos campos de data;
- cálculo e utilização das informações relacionadas ao tempo de entrega;
- organização dos dados de pedidos, itens, produtos e avaliações;
- criação de uma base agregada de clientes;
- exportação dos resultados para arquivos CSV.

Durante o processo, também foram realizadas verificações para identificar valores nulos e possíveis inconsistências nos dados.

---

## 6. Base de clientes

Durante o desenvolvimento, identifiquei que a estrutura do banco de dados disponível não possuía a tabela de clientes completa utilizada no dataset original da Olist.

Para não interromper a análise, criei uma base agregada utilizando as informações disponíveis nas tabelas de pedidos e pagamentos.

Foram calculados:

- quantidade de pedidos;
- valor total das compras;
- data da primeira compra;
- data da última compra.

Também foi criada uma classificação com base na quantidade de pedidos.

### Observação

Como o banco disponível não possuía o campo `customer_unique_id`, a identificação de clientes recorrentes não pode ser reproduzida exatamente como no dataset completo da Olist.

Por isso, na análise final, o foco dos clientes foi principalmente o valor total das compras.

Essa decisão foi registrada para deixar clara a limitação dos dados utilizados no projeto.

---

## 7. Arquivos gerados

O script gera os seguintes arquivos tratados:

| Arquivo | Descrição |
|---|---|
| `pedidos_tratados.csv` | Dados dos pedidos e informações de datas |
| `itens_tratados.csv` | Itens associados aos pedidos |
| `produtos_tratados.csv` | Produtos e categorias |
| `avaliacoes_tratadas.csv` | Avaliações dos clientes |
| `clientes_tratados.csv` | Dados agregados dos clientes |

Esses arquivos foram utilizados como fonte de dados para o Power BI.

---

## 8. Validação dos dados

Antes de utilizar os arquivos no Power BI, realizei algumas verificações para confirmar a qualidade dos dados.

Entre as validações realizadas:

- verificação de valores nulos;
- conferência das datas;
- análise das informações de entrega;
- conferência dos valores de vendas e pagamentos;
- verificação da quantidade de registros;
- comparação dos resultados obtidos durante as consultas;
- conferência dos arquivos CSV gerados.

Essas verificações ajudaram a identificar possíveis problemas antes da etapa de visualização.

---

## 9. Decisões durante o desenvolvimento

Durante o projeto, algumas decisões foram tomadas a partir dos problemas encontrados nos dados.

Um exemplo foi a análise do tempo de entrega. Nem todos os pedidos possuíam as datas necessárias para calcular esse indicador. Por isso, para essa análise foram considerados apenas os registros com as informações necessárias de aprovação e entrega.

Também procurei diferenciar uma relação entre variáveis de uma conclusão de causa e efeito. Por exemplo, uma associação entre maior tempo de entrega e avaliações menores indica um comportamento que merece ser investigado, mas não permite afirmar, isoladamente, que o tempo de entrega foi a única causa da avaliação.

---

## 10. Resultado

Ao final do processo, os dados foram organizados em arquivos CSV tratados e preparados para a etapa de análise no Power BI.

O Python funcionou principalmente como uma etapa intermediária entre o banco de dados e a ferramenta de visualização, permitindo organizar, validar e documentar o tratamento dos dados antes da construção dos dashboards.
