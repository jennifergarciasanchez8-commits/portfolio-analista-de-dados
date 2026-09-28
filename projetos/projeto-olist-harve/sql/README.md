# Análise dos dados com SQL

## 1. Objetivo

Usei SQL para conhecer melhor a base da Olist e entender o que estava acontecendo com os dados antes de começar a montar as análises no Power BI.

A ideia não era apenas fazer consultas e pegar números. Durante essa etapa também fui verificando se os dados faziam sentido e se existiam problemas que poderiam afetar os resultados.

As consultas utilizadas estão no arquivo:

`analises_olist.sql`

---

## 2. Conhecendo a base

Primeiro procurei entender quais tabelas eu tinha disponíveis e quais informações poderiam ser usadas no projeto.

Trabalhei principalmente com dados de:

- pedidos;
- itens dos pedidos;
- produtos;
- pagamentos;
- avaliações;
- datas de compra e entrega.

A partir disso, comecei a montar consultas para responder às perguntas do projeto e também para conhecer melhor os dados.

---

## 3. Uma dúvida que apareceu durante a análise

Uma das coisas que me chamou atenção foi o cálculo do tempo de entrega.

Em alguns casos, o resultado aparecia com um valor negativo.

Isso me fez pensar que poderia existir algum problema nas datas da base, como datas invertidas ou algum registro preenchido de uma forma diferente do esperado.

Em vez de simplesmente excluir esses dados, resolvi investigar primeiro.

---

## 4. Investigando as datas

Fiz algumas consultas para comparar as diferentes datas do pedido e entender onde estava o problema.

Analisei principalmente:

- `order_purchase_timestamp`;
- `order_approved_at`;
- `order_delivered_carrier_date`;
- `order_delivered_customer_date`;
- `order_estimated_delivery_date`.

Nessa investigação encontrei **38 registros com tempo de entrega negativo**.

Depois de verificar esses casos, decidi não utilizar os valores negativos nos cálculos de tempo de entrega, porque eles poderiam distorcer a análise.

---

## 5. Conferindo os resultados

Depois de separar os registros válidos, calculei novamente o tempo médio de entrega.

Também calculei a mediana para comparar com a média e entender melhor o comportamento dos dados.

Fiz isso porque a média pode ser influenciada por alguns pedidos com tempos muito altos ou muito baixos.

Essa etapa foi importante para não tirar uma conclusão apenas olhando para um único indicador.

---

## 6. Analisando os atrasos

Também comparei a data real de entrega com a data estimada para verificar os pedidos que chegaram antes, dentro do prazo ou depois do prazo.

Essa análise foi importante porque uma das perguntas do projeto era entender se os problemas de entrega poderiam estar relacionados à satisfação dos clientes.

---

## 7. Avaliações dos clientes

Depois analisei as avaliações, verificando a distribuição das notas de 1 a 5.

A ideia era comparar as avaliações com as informações de entrega e tentar entender se existia alguma relação entre o tempo que o cliente esperou e a nota que ele deu.

Mais tarde essa análise também foi levada para o Power BI.

---

## 8. Outras verificações

Além das datas e avaliações, também fiz consultas para entender melhor:

- quantidade de pedidos;
- valores das vendas;
- pagamentos;
- informações dos produtos;
- informações dos itens dos pedidos;
- pedidos com dados de entrega disponíveis;
- possíveis valores nulos ou inconsistentes.

Algumas consultas foram sendo modificadas durante o desenvolvimento conforme apareciam novas dúvidas.

---

## 9. Uma decisão importante

Durante o projeto, percebi que não deveria utilizar todos os pedidos da mesma maneira em todas as análises.

Por exemplo, para calcular o tempo real de entrega, um pedido precisava ter as informações necessárias de aprovação e entrega.

Por isso, para essa análise, considerei somente os registros que tinham as datas necessárias.

Isso ajudou a evitar que pedidos cancelados, não entregues ou sem informação de entrega alterassem os resultados.

---

## 10. O que aprendi nessa etapa

Essa foi uma das partes em que mais percebi a importância de olhar os dados antes de começar a criar os gráficos.

Quando apareceu o problema dos tempos negativos, minha primeira hipótese foi que poderia haver alguma data invertida.

Em vez de assumir que era isso, usei SQL para investigar a situação e verificar quantos registros eram afetados.

Esse processo me ajudou a entender que, em uma análise de dados, nem sempre o primeiro resultado deve ser considerado correto. É necessário investigar, validar e só depois decidir como utilizar aquela informação.

---

## 11. Resultado

Depois dessas verificações, utilizei os resultados das consultas como base para a etapa seguinte do projeto.

O processo ficou:

**MySQL → SQL → validação → Python → arquivos tratados → Power BI**

O arquivo `analises_olist.sql` contém as consultas utilizadas durante essa etapa e permite acompanhar como fui explorando e validando os dados.
