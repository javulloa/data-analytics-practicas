USE Ventas_Tech_DB

--Consulta 1 - Resumen ejecutivo mensual Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes. 

SELECT * FROM ventas

SELECT 
SUM(precio_unitario*cantidad) AS total_facturado, 
SUM(cantidad) AS cantidad_pedidos,
AVG(precio_unitario*cantidad) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

--Consulta 2 — Ranking de productos Top 5 de id_producto por total facturado, mostrando las unidades vendidas (SUM(cantidad)) y el total generado. 

SELECT TOP 5
id_producto,
SUM(cantidad) AS unidades_vendidas, 
SUM(precio_unitario*cantidad) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY (total_facturado) DESC;

--Consulta 3 — Clientes recurrentes id_cliente que hayan realizado más de un pedido, mostrando la cantidad de pedidos y el total gastado. 

SELECT 
id_cliente,
SUM(cantidad) AS cantidad_pedidos,
SUM(cantidad*precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;


--Consulta 4 — Productos por encima/por debajo del promedio Total facturado por id_producto, con una columna adicional que etiquete con CASE WHEN 
--si ese producto quedó 'Por encima' o 'Por debajo' del promedio de facturación por producto. 
--Ojo: es el promedio de los totales por producto, no el promedio de las filas de ventas. Resolvelo con WITH y una subconsulta, como en el ejemplo 
--de meses de la unidad "Ordenar, resumir y agrupar resultados".

;WITH conteo AS(
	SELECT
	id_producto, 
	SUM(cantidad) AS cantidad_vendidos
	FROM ventas
	GROUP BY id_producto
)
SELECT
id_producto, 
cantidad_vendidos,
CASE
	WHEN cantidad_vendidos > (SELECT AVG(cantidad_vendidos) FROM conteo) THEN 'por encima'
	ELSE 'por debajo'
END AS Estado
FROM conteo
ORDER BY id_producto;


--Bloque de cierre Al final del archivo agregá un bloque de comentarios 
-- con 3 hallazgos concretos que encontraste al revisar los resultados. Por ejemplo: "El producto 1 concentra el 40% de la facturación del trimestre."

--Hallazgos: 
--1. El producto 2 concentra la mayor parte de las ventas
--2. Los clientes 1 y 5 son los que más han gastado, ambos superando los 2.000 pesos en productos.
--3. Se debería enfocar en promocionar productos con mayor valor que están bajo el promedio de ventas, como el producto 1. 
