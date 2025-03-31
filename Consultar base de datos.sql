--1.-¿Que promociones ha tenido un producto x ?
SELECT p.id, p.date_promotion, p.amount_promotion, p.discount
FROM promotion.promotion p
JOIN store.item i ON p.id_item = i.id
WHERE i.id = <id_producto_x>;

--2.- mostrar  las ventas realizadas por un usuario x
SELECT s.id, s.date_sale, sd.amount, sd.cost_detail
FROM sale.sale s
JOIN sale.sale_detail sd ON s.id_detail = sd.id
WHERE s.id_users = <id_usuario_x>;

--3.- mostrar la lista de empleados en un cargo x 
SELECT e.id, e.name_employee, e.ap_paterno, e.ap_materno
FROM users.employee e
JOIN users.contract c ON e.id = c.id_employee
JOIN users.position p ON c.id_position = p.id
WHERE p.id = <id_cargo_x>;

--4.-mostar una lista de empleados que alla realizado una compra y saber el cargo 
SELECT e.id, e.name_employee, e.ap_paterno, e.ap_materno, p.name_position
FROM users.employee e
JOIN users.contract c ON e.id = c.id_employee
JOIN users.position p ON c.id_position = p.id
JOIN sale.sale s ON s.id_users = e.id
WHERE s.id_detail IS NOT NULL;

--5.- saber cuanto queda de un producto x 
SELECT i.name_item, (s.amount_store - s.final_amount) AS remaining_stock
FROM store.store s
JOIN store.item i ON s.id_item = i.id
WHERE i.id = <id_producto_x>
ORDER BY s.date_store DESC
LIMIT 1;

--6.- mostrar la lista de proveedores que venden un producto x 
SELECT DISTINCT bs.supplier_name, bs.company_name, bs.email
FROM buys.buys b
JOIN buys.buys_supplier bs ON b.id_buys_supplier = bs.id
JOIN buys.buys_detail bd ON b.id_buys_detail = bd.id
WHERE bd.id_item = <id_producto_x>;

--7.- saber cuanto hacido el ingreso por ventas realizadas por un mes x 
SELECT SUM(sd.amount * sd.cost_detail) AS total_income
FROM sale.sale s
JOIN sale.sale_detail sd ON s.id_detail = sd.id
WHERE EXTRACT(MONTH FROM s.date_sale) = <mes_x>
AND EXTRACT(YEAR FROM s.date_sale) = <año_x>;

--8.-conocer el producto mas vendido 
SELECT i.name_item, SUM(sd.amount) AS total_sold
FROM sale.sale_detail sd
JOIN store.item i ON sd.id_item = i.id
GROUP BY i.id
ORDER BY total_sold DESC
LIMIT 1;

--9.- conocer al cliente que más productos ha comprado 
SELECT c.name_client, SUM(sd.amount) AS total_purchased
FROM sale.sale s
JOIN sale.sale_detail sd ON s.id_detail = sd.id
JOIN sale.client c ON s.id_client = c.id
GROUP BY c.id
ORDER BY total_purchased DESC
LIMIT 1;

--10.-Conocer al cliente  con el costo más alto de compra 
SELECT c.name_client, SUM(sd.amount * sd.cost_detail) AS total_spent
FROM sale.sale s
JOIN sale.sale_detail sd ON s.id_detail = sd.id
JOIN sale.client c ON s.id_client = c.id
GROUP BY c.id
ORDER BY total_spent DESC
LIMIT 1;

--11.-mostrar la cantidad de clientes que se tiene 
SELECT COUNT(*) AS total_clients
FROM sale.client;

--12.-mostrar los productos con un stock menor a 10
SELECT i.name_item, (s.amount_store - s.final_amount) AS remaining_stock
FROM store.store s
JOIN store.item i ON s.id_item = i.id
GROUP BY i.id
HAVING (s.amount_store - s.final_amount) < 10;
