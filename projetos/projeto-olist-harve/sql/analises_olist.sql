

-- =====================================================
-- 1. Distribuição dos pedidos por status
-- Objetivo: identificar a quantidade de pedidos
-- em cada status e entender a situação dos pedidos
-- na plataforma.
-- =====================================================
SELECT
    order_status,
    COUNT(*) AS quantidade
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY quantidade DESC;

-- =====================================================
-- 2. Pedidos com aprovação e entrega
-- Objetivo: analisar a quantidade de pedidos que possuem
-- aprovação e data de entrega, identificando também
-- pedidos sem essas informações.
-- =====================================================

SELECT
    COUNT(*) AS total_pedidos,
    COUNT(order_approved_at) AS pedidos_com_aprovacao,
    COUNT(order_delivered_customer_date) AS pedidos_com_entrega,
    COUNT(*) - COUNT(order_approved_at) AS sem_aprovacao,
    COUNT(*) - COUNT(order_delivered_customer_date) AS sem_entrega
FROM olist_orders_dataset;

-- =====================================================
-- 3. Tempo médio de entrega dos pedidos
-- Objetivo: calcular o tempo médio entre a aprovação
-- do pedido e a entrega ao cliente.
-- =====================================================

SELECT
    COUNT(*) AS total_pedidos,
    ROUND(AVG(DATEDIFF(
        order_delivered_customer_date,
        order_approved_at
    )), 2) AS media_dias_entrega,
    MIN(DATEDIFF(
        order_delivered_customer_date,
        order_approved_at
    )) AS menor_tempo_entrega,
    MAX(DATEDIFF(
        order_delivered_customer_date,
        order_approved_at
    )) AS maior_tempo_entrega
FROM olist_orders_dataset
WHERE order_approved_at IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL;

-- =====================================================
-- 4. Identificação de pedidos com tempo de entrega negativo
-- Objetivo: identificar possíveis inconsistências entre
-- a data de aprovação e a data de entrega do pedido.
-- =====================================================

SELECT
    COUNT(*) AS pedidos_com_tempo_negativo
FROM olist_orders_dataset
WHERE order_approved_at IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND DATEDIFF(
      order_delivered_customer_date,
      order_approved_at
  ) < 0;

-- =====================================================
-- 5. Detalhamento dos pedidos com tempo de entrega negativo
-- Objetivo: identificar os pedidos que apresentam
-- inconsistências entre a data de aprovação e a data de entrega.
-- =====================================================

SELECT
    order_id,
    order_approved_at,
    order_delivered_customer_date,
    DATEDIFF(
        order_delivered_customer_date,
        order_approved_at
    ) AS dias_entrega
FROM olist_orders_dataset
WHERE order_approved_at IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND DATEDIFF(
      order_delivered_customer_date,
      order_approved_at
  ) < 0
ORDER BY dias_entrega;

-- =====================================================
-- 6. Distribuição dos tempos negativos
-- Objetivo: ver quantos pedidos apresentam cada valor
-- de tempo de entrega negativo.
-- =====================================================

SELECT
    DATEDIFF(
        order_delivered_customer_date,
        order_approved_at
    ) AS dias_entrega,
    COUNT(*) AS quantidade_pedidos
FROM olist_orders_dataset
WHERE order_approved_at IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND DATEDIFF(
      order_delivered_customer_date,
      order_approved_at
  ) < 0
GROUP BY DATEDIFF(
    order_delivered_customer_date,
    order_approved_at
)
ORDER BY dias_entrega;

-- =====================================================
-- 7. Tempo médio de entrega
-- Objetivo: calcular a média de dias de entrega,
-- desconsiderando os pedidos com tempo negativo.
-- =====================================================

SELECT
    COUNT(*) AS total_pedidos_validos,
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_approved_at
            )
        ),
        2
    ) AS media_dias_entrega
FROM olist_orders_dataset
WHERE order_approved_at IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND DATEDIFF(
      order_delivered_customer_date,
      order_approved_at
  ) >= 0;


-- =====================================================
-- 8. Verificação das datas dos pedidos
-- Objetivo: verificar a sequência das datas de compra,
-- aprovação, envio e entrega e investigar possíveis
-- inconsistências nos registros.
-- =====================================================

SELECT
    order_id,
    order_purchase_timestamp AS data_compra,
    order_approved_at AS data_aprovacao,
    order_delivered_carrier_date AS data_envio,
    order_delivered_customer_date AS data_entrega,
    order_estimated_delivery_date AS data_entrega_estimada,

    DATEDIFF(
        order_approved_at,
        order_purchase_timestamp
    ) AS dias_compra_aprovacao,

    DATEDIFF(
        order_delivered_carrier_date,
        order_approved_at
    ) AS dias_aprovacao_envio,

    DATEDIFF(
        order_delivered_customer_date,
        order_delivered_carrier_date
    ) AS dias_envio_entrega,

    DATEDIFF(
        order_delivered_customer_date,
        order_approved_at
    ) AS dias_entrega

FROM olist_orders_dataset

WHERE order_approved_at IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND DATEDIFF(
      order_delivered_customer_date,
      order_approved_at
  ) < 0

ORDER BY dias_entrega;

-- =====================================================
-- 9. Teste da possível inversão das datas
-- Objetivo: verificar se a inversão entre as datas
-- de aprovação e entrega corrige os tempos negativos.
-- =====================================================

SELECT
    order_id,
    order_purchase_timestamp AS data_compra,
    order_approved_at AS aprovacao_registrada,
    order_delivered_carrier_date AS envio_transportadora,
    order_delivered_customer_date AS entrega_registrada,

    order_delivered_customer_date AS aprovacao_corrigida,
    order_approved_at AS entrega_corrigida,

    DATEDIFF(
        order_delivered_customer_date,
        order_purchase_timestamp
    ) AS dias_compra_entrega_corrigidos

FROM olist_orders_dataset

WHERE order_approved_at IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND DATEDIFF(
      order_delivered_customer_date,
      order_approved_at
  ) < 0

ORDER BY dias_compra_entrega_corrigidos;

-- =====================================================
-- 10. Verificação da hipótese de inversão das datas
-- Objetivo: verificar quantos casos são compatíveis
-- com a possível inversão entre aprovação e entrega.
-- =====================================================

SELECT
    COUNT(*) AS total_inconsistencias,

    SUM(
        CASE
            WHEN order_purchase_timestamp <= order_delivered_customer_date
             AND (
                    order_delivered_carrier_date IS NULL
                    OR order_delivered_customer_date <= order_delivered_carrier_date
                 )
             AND (
                    order_delivered_carrier_date IS NULL
                    OR order_delivered_carrier_date <= order_approved_at
                 )
            THEN 1
            ELSE 0
        END
    ) AS casos_compativeis_com_inversao

FROM olist_orders_dataset

WHERE order_approved_at IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND DATEDIFF(
      order_delivered_customer_date,
      order_approved_at
  ) < 0;

-- =====================================================
-- 11. Verificação da sequência das datas
-- Objetivo: verificar se os pedidos com tempo negativo
-- apresentam uma sequência de datas compatível com
-- a possível inversão da aprovação e da entrega.
-- =====================================================

SELECT
    COUNT(*) AS total_inconsistencias,

    SUM(
        CASE
            WHEN order_purchase_timestamp <= order_delivered_customer_date
             AND order_delivered_customer_date <= order_approved_at
            THEN 1
            ELSE 0
        END
    ) AS casos_compativeis_com_inversao

FROM olist_orders_dataset

WHERE order_approved_at IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND DATEDIFF(
      order_delivered_customer_date,
      order_approved_at
  ) < 0;

-- =====================================================
-- 12. Verificação da sequência de envio e entrega
-- Objetivo: verificar se a sequência entre compra,
-- envio e entrega permanece correta nos pedidos
-- com inconsistências nas datas.
-- =====================================================

SELECT
    COUNT(*) AS total_inconsistencias,

    SUM(
        CASE
            WHEN order_purchase_timestamp <= order_delivered_carrier_date
             AND order_delivered_carrier_date <= order_delivered_customer_date
            THEN 1
            ELSE 0
        END
    ) AS sequencia_compra_envio_entrega,

    SUM(
        CASE
            WHEN order_delivered_carrier_date < order_purchase_timestamp
            THEN 1
            ELSE 0
        END
    ) AS envio_antes_da_compra

FROM olist_orders_dataset

WHERE order_approved_at IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND DATEDIFF(
      order_delivered_customer_date,
      order_approved_at
  ) < 0;


WITH tempos_entrega AS (
    SELECT
        DATEDIFF(
            order_delivered_customer_date,
            order_approved_at
        ) AS dias_entrega
    FROM olist_orders_dataset
    WHERE order_approved_at IS NOT NULL
      AND order_delivered_customer_date IS NOT NULL
      AND DATEDIFF(
          order_delivered_customer_date,
          order_approved_at
      ) >= 0
),
ordenados AS (
    SELECT
        dias_entrega,
        ROW_NUMBER() OVER (ORDER BY dias_entrega) AS linha,
        COUNT(*) OVER () AS total_linhas
    FROM tempos_entrega
)
SELECT
    ROUND(AVG(dias_entrega), 2) AS mediana_dias_entrega
FROM ordenados
WHERE linha IN (
    FLOOR((total_linhas + 1) / 2),
    CEIL((total_linhas + 1) / 2)
);

-- =====================================================
-- 13. Pedidos entregues no prazo e com atraso
-- Objetivo: comparar os pedidos entregues no prazo
-- com os pedidos que foram entregues com atraso.
-- =====================================================

SELECT
    COUNT(*) AS total_pedidos,

    SUM(
        CASE
            WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS entregues_no_prazo,

    SUM(
        CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS entregues_com_atraso,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS percentual_atraso

FROM olist_orders_dataset

WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

DESCRIBE olist_order_reviews_dataset;

-- =====================================================
-- 14. Distribuição das avaliações dos clientes
-- Objetivo: ver a quantidade e o percentual de cada
-- nota dada pelos clientes.
-- =====================================================

SELECT
    review_score AS nota_avaliacao,
    COUNT(*) AS quantidade_avaliacoes,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentual
FROM olist_order_reviews_dataset
WHERE review_score IS NOT NULL
GROUP BY review_score
ORDER BY review_score;


-- =====================================================
-- 15. Relação entre atraso e avaliação
-- Objetivo: comparar a nota média dos clientes entre
-- pedidos entregues no prazo e pedidos entregues com atraso.
-- =====================================================
SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'No prazo'
        ELSE 'Com atraso'
    END AS status_entrega,

    COUNT(r.review_score) AS quantidade_avaliacoes,

    ROUND(
        AVG(r.review_score),
        2
    ) AS nota_media

FROM olist_orders_dataset AS o

INNER JOIN olist_order_reviews_dataset AS r
    ON o.order_id = r.order_id

WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
  AND r.review_score IS NOT NULL

GROUP BY
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'No prazo'
        ELSE 'Com atraso'
    END

ORDER BY nota_media DESC;

-- =====================================================
-- 16. Avaliações baixas em pedidos com e sem atraso
-- Objetivo: comparar a quantidade de avaliações baixas
-- (notas 1 e 2) entre pedidos entregues no prazo
-- e pedidos entregues com atraso.
-- =====================================================

SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'No prazo'
        ELSE 'Com atraso'
    END AS status_entrega,

    COUNT(*) AS total_avaliacoes,

    SUM(
        CASE
            WHEN r.review_score IN (1, 2)
            THEN 1
            ELSE 0
        END
    ) AS avaliacoes_baixas,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN r.review_score IN (1, 2)
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS percentual_avaliacoes_baixas

FROM olist_orders_dataset AS o

INNER JOIN olist_order_reviews_dataset AS r
    ON o.order_id = r.order_id

WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
  AND r.review_score IS NOT NULL

GROUP BY
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'No prazo'
        ELSE 'Com atraso'
    END

ORDER BY percentual_avaliacoes_baixas DESC;

-- =====================================================
-- 17. Avaliações por faixa de atraso
-- Objetivo: analisar as notas dos clientes de acordo
-- com a quantidade de dias de atraso na entrega.
-- =====================================================

SELECT
    CASE
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 1 AND 3 THEN '1 a 3 dias'
        
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 4 AND 7 THEN '4 a 7 dias'
        
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 8 AND 14 THEN '8 a 14 dias'
        
        ELSE '15 dias ou mais'
    END AS faixa_atraso,

    COUNT(r.review_score) AS quantidade_avaliacoes,

    ROUND(
        AVG(r.review_score),
        2
    ) AS nota_media,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN r.review_score IN (1, 2)
                THEN 1
                ELSE 0
            END
        ) / COUNT(r.review_score),
        2
    ) AS percentual_notas_baixas

FROM olist_orders_dataset AS o

INNER JOIN olist_order_reviews_dataset AS r
    ON o.order_id = r.order_id

WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
  AND r.review_score IS NOT NULL
  AND o.order_delivered_customer_date > o.order_estimated_delivery_date

GROUP BY
    CASE
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 1 AND 3 THEN '1 a 3 dias'
        
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 4 AND 7 THEN '4 a 7 dias'
        
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 8 AND 14 THEN '8 a 14 dias'
        
        ELSE '15 dias ou mais'
    END

ORDER BY
    CASE faixa_atraso
        WHEN '1 a 3 dias' THEN 1
        WHEN '4 a 7 dias' THEN 2
        WHEN '8 a 14 dias' THEN 3
        ELSE 4
    END;

-- =====================================================
-- 18. Tempo de atraso nas entregas
-- Objetivo: identificar o maior, o menor e a média
-- de dias de atraso nas entregas.
-- =====================================================

SELECT
    MAX(
        DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
    ) AS maior_atraso_dias,

    MIN(
        DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
    ) AS menor_atraso_dias,

    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_estimated_delivery_date
            )
        ),
        2
    ) AS media_dias_atraso

FROM olist_orders_dataset

WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date > order_estimated_delivery_date;

-- =====================================================
-- 19. Avaliações em atrasos acima de 15 dias
-- Objetivo: analisar as avaliações dos clientes
-- em diferentes faixas de atraso acima de 15 dias.
-- =====================================================

SELECT
    CASE
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 15 AND 30 THEN '15 a 30 dias'

        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 31 AND 60 THEN '31 a 60 dias'

        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 61 AND 90 THEN '61 a 90 dias'

        ELSE 'Mais de 90 dias'
    END AS faixa_atraso,

    COUNT(r.review_score) AS quantidade_avaliacoes,

    ROUND(AVG(r.review_score), 2) AS nota_media,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN r.review_score IN (1, 2)
                THEN 1
                ELSE 0
            END
        ) / COUNT(r.review_score),
        2
    ) AS percentual_notas_baixas

FROM olist_orders_dataset AS o

INNER JOIN olist_order_reviews_dataset AS r
    ON o.order_id = r.order_id

WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
  AND r.review_score IS NOT NULL
  AND DATEDIFF(
      o.order_delivered_customer_date,
      o.order_estimated_delivery_date
  ) >= 15

GROUP BY
    CASE
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 15 AND 30 THEN '15 a 30 dias'

        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 31 AND 60 THEN '31 a 60 dias'

        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 61 AND 90 THEN '61 a 90 dias'

        ELSE 'Mais de 90 dias'
    END

ORDER BY
    CASE faixa_atraso
        WHEN '15 a 30 dias' THEN 1
        WHEN '31 a 60 dias' THEN 2
        WHEN '61 a 90 dias' THEN 3
        ELSE 4
    END;


DESCRIBE olist_order_items_dataset;

DESCRIBE olist_products_dataset;



-- =====================================================
-- 20. Categorias de produtos mais vendidos
-- Objetivo: identificar as categorias com maior
-- quantidade de itens vendidos.
-- =====================================================

SELECT
    p.product_category_name AS categoria,
    COUNT(*) AS quantidade_itens_vendidos
FROM olist_order_items_dataset AS i
INNER JOIN olist_products_dataset AS p
    ON i.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY quantidade_itens_vendidos DESC
LIMIT 10;

-- =====================================================
-- 21. Faturamento por categoria de produtos
-- Objetivo: identificar as categorias que geram
-- maior faturamento com a venda dos produtos.
-- =====================================================

SELECT
	p.product_category_name AS categoria,
	COUNT(*) AS quantidade_itens_vendidos,
	ROUND(SUM(i.price), 2) AS faturamento
FROM
	olist_order_items_dataset AS i
INNER JOIN olist_products_dataset AS p
    ON
	i.product_id = p.product_id
WHERE
	p.product_category_name IS NOT NULL
GROUP BY
	p.product_category_name
ORDER BY
	faturamento DESC
LIMIT 10;

-- =====================================================
-- 22. Preço médio por categoria de produtos
-- Objetivo: comparar o preço médio dos produtos
-- entre as diferentes categorias.
-- =====================================================

SELECT
    p.product_category_name AS categoria,
    COUNT(*) AS quantidade_itens_vendidos,
    ROUND(SUM(i.price), 2) AS faturamento,
    ROUND(AVG(i.price), 2) AS preco_medio
FROM olist_order_items_dataset AS i
INNER JOIN olist_products_dataset AS p
    ON i.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(*) >= 100
ORDER BY preco_medio DESC
LIMIT 10;


-- =====================================================
-- 23. Vendedores com maior faturamento
-- Objetivo: identificar os vendedores que tiveram
-- maior faturamento com as vendas.
-- =====================================================

SELECT
    seller_id AS vendedor,
    COUNT(*) AS quantidade_itens_vendidos,
    ROUND(SUM(price), 2) AS faturamento,
    ROUND(AVG(price), 2) AS preco_medio
FROM olist_order_items_dataset
GROUP BY seller_id
ORDER BY faturamento DESC
LIMIT 10;


-- =====================================================
-- 24. Avaliação média dos pedidos por vendedor
-- Objetivo: analisar a nota média das avaliações
-- de cada vendedor.
-- =====================================================

SELECT
    i.seller_id AS vendedor,

    COUNT(DISTINCT i.order_id) AS quantidade_pedidos,

    COUNT(r.review_score) AS quantidade_avaliacoes,

    ROUND(AVG(r.review_score), 2) AS nota_media

FROM olist_order_items_dataset AS i

INNER JOIN olist_order_reviews_dataset AS r
    ON i.order_id = r.order_id

WHERE r.review_score IS NOT NULL

GROUP BY i.seller_id

HAVING COUNT(r.review_score) >= 50

ORDER BY nota_media DESC
LIMIT 10;

-- =====================================================
-- 25. Faturamento e avaliação média por vendedor
-- Objetivo: comparar o faturamento dos vendedores
-- com a nota média das avaliações.
-- =====================================================

SELECT
    i.seller_id AS vendedor,

    COUNT(*) AS quantidade_itens_vendidos,

    ROUND(SUM(i.price), 2) AS faturamento,

    ROUND(AVG(r.review_score), 2) AS nota_media

FROM olist_order_items_dataset AS i

INNER JOIN olist_order_reviews_dataset AS r
    ON i.order_id = r.order_id

WHERE r.review_score IS NOT NULL

GROUP BY i.seller_id

HAVING COUNT(r.review_score) >= 50

ORDER BY faturamento DESC

LIMIT 10;


-- =====================================================
-- 26. Categorias com maior faturamento
-- Objetivo: identificar as categorias de produtos
-- que geram maior faturamento na plataforma.
-- =====================================================

SELECT
    p.product_category_name AS categoria,

    COUNT(*) AS quantidade_itens_vendidos,

    ROUND(SUM(i.price), 2) AS faturamento,

    ROUND(AVG(i.price), 2) AS preco_medio

FROM olist_order_items_dataset AS i

INNER JOIN olist_products_dataset AS p
    ON i.product_id = p.product_id

WHERE p.product_category_name IS NOT NULL

GROUP BY p.product_category_name

ORDER BY faturamento DESC

LIMIT 10;

-- =====================================================
-- 27. Resumo geral da operação
-- Objetivo: reunir os principais indicadores da
-- plataforma em uma única consulta.
-- =====================================================

SELECT
    COUNT(DISTINCT o.order_id) AS total_pedidos,

    COUNT(DISTINCT o.customer_id) AS total_clientes,

    COUNT(i.order_id) AS total_itens_vendidos,

    ROUND(SUM(i.price), 2) AS faturamento_produtos,

    ROUND(AVG(i.price), 2) AS preco_medio_item,

    ROUND(AVG(
        CASE
            WHEN o.order_delivered_customer_date IS NOT NULL
            AND o.order_approved_at IS NOT NULL
            AND DATEDIFF(
                o.order_delivered_customer_date,
                o.order_approved_at
            ) >= 0
            THEN DATEDIFF(
                o.order_delivered_customer_date,
                o.order_approved_at
            )
        END
    ), 2) AS media_dias_entrega

FROM olist_orders_dataset AS o

INNER JOIN olist_order_items_dataset AS i
    ON o.order_id = i.order_id;