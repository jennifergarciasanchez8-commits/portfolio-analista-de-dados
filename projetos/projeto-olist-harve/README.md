# Análise de Dados — Olist

## Contexto

Este projeto foi desenvolvido como trabalho final do curso de Analista de Dados da Harve, simulando meu primeiro desafio profissional como analista.

A proposta era imaginar que uma empresa havia me contratado para analisar seus dados e responder algumas perguntas importantes sobre o negócio.

## Desafio

A partir dos dados fornecidos, precisei investigar:

- O que está acontecendo com as vendas?
- Quem são os melhores clientes?
- Os problemas de entrega podem estar afetando a satisfação dos clientes?
- Quais categorias de produtos mais contribuem para a receita?

As respostas foram construídas a partir da análise dos dados e apresentadas no Power BI.

## Ferramentas

**SQL · Python · Pandas · Power BI · GitHub**

## Estrutura

O projeto foi organizado em três etapas principais:

- **SQL** — exploração e investigação dos dados.
- **Python** — tratamento dos dados e criação dos arquivos CSV.
- **Power BI** — modelagem, análise visual e apresentação dos resultados.

Cada etapa possui sua própria documentação dentro do projeto.

## Resultado

O resultado final é uma análise dos dados da Olist apresentada como uma entrega para a empresa, com uma **Visão Executiva** reunindo os principais resultados encontrados.

A documentação de cada etapa também registra algumas das dúvidas, problemas e decisões que surgiram durante o desenvolvimento.

## Respostas às quatro perguntas de negócio

### 1. O que está acontecendo com as vendas?

Ao analisar a evolução do faturamento ao longo do tempo, foi possível perceber um crescimento durante boa parte do período, mas também algumas oscilações e uma redução nos meses finais.

Para entender melhor esse comportamento, comparei a evolução das vendas com categorias de produtos, estados dos clientes e outras informações disponíveis na base.

Durante a exploração dos dados, também verifiquei se existia uma grande quantidade de pedidos que não chegaram a ser aprovados ou entregues. A análise mostrou que existem registros com informações de entrega ausentes, mas isso, sozinho, não é suficiente para afirmar que essa é a principal causa da queda nas vendas.

Assim, os dados mostram a existência de uma redução no final do período, mas seria necessário aprofundar a análise de fatores como sazonalidade, campanhas, oferta de produtos e comportamento dos consumidores para determinar a causa.

### 2. Quem são os nossos melhores clientes?

Para responder a essa pergunta, utilizei como principal critério o valor total das compras.

A análise permitiu identificar os clientes que possuem maior valor acumulado e, consequentemente, representam uma parcela importante da receita.

Esse grupo pode ser utilizado como ponto de partida para análises de retenção e relacionamento com clientes. Porém, é importante considerar que “melhor cliente” pode ter diferentes definições, dependendo do objetivo da empresa, como frequência de compra, valor gasto ou ticket médio.

### 3. Os problemas de entrega estão afetando a satisfação dos clientes?

Essa foi uma das análises que exigiu mais cuidado.

Comparei o tempo de entrega com as avaliações dadas pelos clientes. Foi possível observar que os pedidos com maior tempo de entrega estão associados às avaliações mais baixas.

Esse resultado indica uma relação entre a experiência de entrega e a satisfação do cliente.

Porém, a análise não permite afirmar que o atraso, sozinho, foi a causa de uma avaliação baixa ou de uma eventual perda de clientes. Por isso, considerei o resultado como uma associação e não como uma relação de causa e efeito.

Também foi necessário considerar apenas os pedidos que possuíam as informações necessárias para analisar a entrega, evitando misturar pedidos cancelados, não enviados ou sem data de entrega com os pedidos efetivamente entregues.

### 4. Quais categorias de produtos mais contribuem para a receita?

A análise por categoria mostrou que a receita está concentrada em algumas categorias de produtos.

Utilizei o faturamento por categoria para identificar quais grupos possuem maior participação no resultado geral. Essas categorias representam os principais motores de receita e podem receber maior atenção em análises futuras.

Por outro lado, uma categoria com faturamento menor não significa necessariamente que tenha um desempenho ruim. Para chegar a essa conclusão seria necessário considerar outros indicadores, como margem, quantidade vendida, preço médio e evolução ao longo do tempo.

### Conclusão das análises

As quatro perguntas ajudaram a transformar os dados em informações para o negócio.

A análise mostrou mudanças no comportamento das vendas ao longo do tempo, identificou clientes de maior valor, encontrou uma relação entre tempo de entrega e avaliação dos clientes e mostrou quais categorias possuem maior participação na receita.

Esses resultados servem como ponto de partida para decisões e novas investigações, evitando conclusões que os dados disponíveis não conseguem comprovar sozinhos.
