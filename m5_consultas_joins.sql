USE Ventas_Tech_DB

--Consulta 1 - Se combina con INNER JOIN las tablas venta, cliente y producto.

SELECT *
FROM ventas AS v
INNER JOIN clientes AS c
ON v.id_cliente = c.id_cliente
INNER JOIN productos as p
ON v.id_producto = p.id_producto

--Consulta 2 — Se identifican clientes registrados que aún no han realizado ninguna compra (importante para CRM)

SELECT *
FROM ventas AS v
LEFT JOIN clientes AS c
ON v.id_cliente = c.id_cliente
WHERE v.id_cliente is NULL

--Hallazgo: No hay clientes registrados sin hacer compra

--Consulta 3 — Se identifican productos del catálogo que no tienen ninguna venta registrada (importante para área Productos)

SELECT *
FROM ventas AS v
LEFT JOIN productos AS p
ON v.id_producto = p.id_producto
WHERE v.id_producto is NULL

--Hallazgo: No hay productos sin venta registrada

--Consulta 4 — Consolidado por canal (UNION ALL)

SELECT canal, SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Online' AS canal
    FROM ventas WHERE cantidad = 1
    UNION ALL
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Presencial' AS canal
    FROM ventas WHERE cantidad != 1
) AS consolidado
GROUP BY canal;
