CREATE SCHEMA users;
CREATE SCHEMA store;
CREATE SCHEMA buys;
CREATE SCHEMA promotion;
CREATE SCHEMA sale;

CREATE TABLE sale.sale(
	id SERIAL,
	id_user INTEGER NOT NULL,
	id_client INTEGER NOT NULL,
	id_detail INTEGER NOT NULL,
	date_sale DATE DEFAULT CURRENT_TIMESTAMP,
	stock INTEGER NULL,

	CONSTRAINT pk_sale PRIMARY KEY(id),
	CONSTRAINT fk_users_user FOREIGN KEY(id_user) REFERENCES users.users(id),
	CONSTRAINT fk_sale_client FOREIGN KEY(id_client) REFERENCES sale.client(id),
	CONSTRAINT fk_sale_detail FOREIGN KEY(id_detail) REFERENCES sale.sale_detail(id),
	CONSTRAINT stock_valid CHECK (stock>=0)
);
CREATE INDEX idx_sale_id_user ON sale.sale(id_user);
CREATE INDEX idx_sale_date_sale ON sale.sale(date_sale);
CREATE INDEX idx_sale_id_client ON sale.sale(id_client);

CREATE TABLE sale.client(
	id SERIAL,
	name_client TEXT NOT NULL,

	CONSTRAINT pk_client PRIMARY KEY(id)
);
CREATE INDEX idx_client_id ON sale.client(id);

CREATE TABLE sale.sale_detail(
	id SERIAL,
	id_item INTEGER NOT NULL,
	cost_detail INTEGER NOT NULL,
	amount INTEGER NULL,

	CONSTRAINT pk_detail PRIMARY KEY(id),
	CONSTRAINT fk_store_item FOREIGN KEY(id_item) REFERENCES store.item(id),
	CONSTRAINT amount_valid CHECK (amount>=0)
);
CREATE INDEX idx_sale_detail_id_item ON sale.sale_detail(id_item);
CREATE INDEX idx_sale_detail_id ON sale.sale_detail(id);

CREATE TABLE store.store(
	id SERIAL,
	id_user INTEGER NOT NULL,
	id_item INTEGER NOT NULL,
	date_store DATE DEFAULT CURRENT_TIMESTAMP,
	motion CHAR(1) NOT NULL,
	amount_store INTEGER NULL,
	final_amount INTEGER NULL,

	CONSTRAINT pk_store PRIMARY KEY(id),
	CONSTRAINT fk_users_user FOREIGN KEY(id_user) REFERENCES users.users(id),
	CONSTRAINT fk_store_item FOREIGN KEY(id_item) REFERENCES store.item(id),
	CONSTRAINT motion_valid CHECK (motion IN ('i', 's')),
	CONSTRAINT amount_valid CHECK (amount_store>=0)
);
CREATE INDEX idx_store_id_item ON store.store(id_item);

CREATE TABLE store.item(
	id SERIAL,
	name_item TEXT NOT NULL,
	description_item TEXT NOT NULL,

	CONSTRAINT pk_item PRIMARY KEY(id)
);
CREATE INDEX idx_item_id ON store.item(id);

CREATE TABLE users.users(
	id SERIAL,
	name_user TEXT NOT NULL,
	password_user TEXT NOT NULL,

	CONSTRAINT pk_user PRIMARY KEY(id)
);

CREATE TABLE users.employee (
    id SERIAL,
    id_users INTEGER NOT NULL,
    name_employee TEXT NOT NULL,
    ap_paterno TEXT NULL,
    ap_materno TEXT NULL,

    CONSTRAINT pk_users_employee PRIMARY KEY(id),
    CONSTRAINT fk_users_user FOREIGN KEY(id_users) REFERENCES users.users(id)
);

CREATE TABLE users.contrat(
	id SERIAL,
	id_employee INTEGER NOT NULL,
	id_position INTEGER NOT NULL,
	date_contract DATE DEFAULT CURRENT_TIMESTAMP,
	type_contract TEXT NOT NULL,
	time_contrat INTEGER,
	
	CONSTRAINT pk_users_contract PRIMARY KEY(id),
	CONSTRAINT fk_uers_employee FOREIGN KEY(id_employee) REFERENCES users.employee(id),
	CONSTRAINT fk_uers_position FOREIGN KEY(id_position) REFERENCES users.position(id),
	CONSTRAINT time_valid CHECK (time_contrat>0)
);
CREATE INDEX idx_contrat_id_employee ON users.contrat(id_employee);
CREATE INDEX idx_contrat_id_position ON users.contrat(id_position);

CREATE TABLE users.position(
	id SERIAL,
	name_position TEXT,
	description_position TEXT,

	CONSTRAINT pk_users_position PRIMARY KEY(id)
);
CREATE INDEX idx_position_id ON users.position(id);

CREATE TABLE users.area (
    id SERIAL,
    id_users_employee INTEGER NOT NULL,
    id_users_area INTEGER NOT NULL,

    CONSTRAINT pk_users_assing_area PRIMARY KEY(id),
    CONSTRAINT fk_users_employee FOREIGN KEY(id_users_employee) REFERENCES users.employee(id),
    CONSTRAINT fk_users_area FOREIGN KEY(id_users_area) REFERENCES users.area(id)
);

CREATE TABLE users.control_access(
	id SERIAL,
	id_user INTEGER NOT NULL,
	admin_control_access TEXT NULL,
	buys_control_access TEXT NULL,
	sale_control_access TEXT NULL,
	store_control_access TEXT NULL,

	CONSTRAINT pk_users_control_access PRIMARY KEY(id),
	CONSTRAINT fk_users_user FOREIGN KEY(id_user) REFERENCES users.users(id)
);

CREATE TABLE buys.buys(
	id SERIAL,
	id_user INTEGER NOT NULL,
	id_buys_detail INTEGER NOT NULL,
	id_buys_supplier INTEGER NOT NULL,
	date_buys DATE DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT pk_buys PRIMARY KEY(id),
	CONSTRAINT fk_users_user FOREIGN KEY(id_user) REFERENCES users.users(id),
	CONSTRAINT fk_buys_detail FOREIGN KEY(id_buys_detail) REFERENCES buys.buys_detail(id),
	CONSTRAINT fk_buys_supplier FOREIGN KEY(id_buys_supplier) REFERENCES buys.buys_supplier(id)
);

CREATE TABLE buys.buys_detail(
	id SERIAL,
	id_item INTEGER NOT NULL,
	cost_detail INTEGER NOT NULL,
	amount_detail INTEGER NULL,

	CONSTRAINT pk_detail PRIMARY KEY(id),
	CONSTRAINT fk_store_item FOREIGN KEY(id_item) REFERENCES store.item(id),
	CONSTRAINT cost_valid CHECK (cost_detail>=0),
	CONSTRAINT amount_valid CHECK (amount_detail>=0)
);
CREATE INDEX idx_buys_detail_id_item ON buys.buys_detail(id_item);

CREATE TABLE buys.buys_supplier(
	id SERIAL,
	supplier_name TEXT NOT NULL,
	company_name TEXT NOT NULL,
	email TEXT NOT NULL,
	number_phone TEXT NOT NULL,

	CONSTRAINT pk_buys_supplier PRIMARY KEY(id)
);

CREATE TABLE promotion.promotion(
	id SERIAL,
	id_item INTEGER NOT NULL,
	date_promotion DATE DEFAULT CURRENT_TIMESTAMP,
	amount_promotion INTEGER NULL,
	discount INTEGER NULL,
	
	CONSTRAINT pk_promotion PRIMARY KEY(id),
	CONSTRAINT fk_store_item FOREIGN KEY(id_item) REFERENCES store.item(id),
	CONSTRAINT amount_valid CHECK (amount_promotion>=0),
	CONSTRAINT discount_valid CHECK (discount>0)
);
CREATE INDEX idx_promotion_id_item ON promotion.promotion(id_item);

INSERT INTO users.users (name_user, password_user) VALUES
('user1', 'password1'),
('user2', 'password2'),
('user3', 'password3'),
('user4', 'password4'),
('user5', 'password5'),
('user6', 'password6'),
('user7', 'password7'),
('user8', 'password8'),
('user9', 'password9'),
('user10', 'password10');

INSERT INTO users.employee (id_users, name_employee, ap_paterno, ap_materno) VALUES
(1, 'John', 'Doe', 'Smith'),
(2, 'Jane', 'Doe', 'Johnson'),
(3, 'Jake', 'Smith', 'Brown'),
(4, 'Emily', 'Davis', 'Wilson'),
(5, 'Michael', 'Jones', 'Taylor'),
(6, 'Sarah', 'Brown', 'Lee'),
(7, 'David', 'Johnson', 'Harris'),
(8, 'Laura', 'Moore', 'Martin'),
(9, 'James', 'Taylor', 'Clark'),
(10, 'Olivia', 'Lewis', 'Walker');

INSERT INTO users.position (name_position, description_position) VALUES
('Manager', 'Responsible for overseeing operations'),
('Employee', 'Works under management, handles day-to-day tasks'),
('Admin', 'Has system administrator access'),
('HR', 'Handles human resources and staffing'),
('Salesperson', 'Sells products to customers'),
('Cashier', 'Handles cash register and transactions'),
('Supervisor', 'Oversees the work of employees'),
('Technician', 'Handles maintenance and repair of systems'),
('Marketing', 'Handles advertising and customer engagement'),
('Support', 'Provides customer service and support');

INSERT INTO store.item (name_item, description_item) VALUES
('Laptop', 'High-performance laptop for professionals'),
('Smartphone', 'Latest model smartphone with advanced features'),
('Tablet', 'Portable tablet for entertainment and work'),
('Headphones', 'Noise-cancelling wireless headphones'),
('Monitor', '24-inch LED monitor for home office'),
('Mouse', 'Wireless mouse with ergonomic design'),
('Keyboard', 'Mechanical keyboard with backlight'),
('Smartwatch', 'Fitness tracking and notifications smartwatch'),
('Camera', 'Digital camera for photography enthusiasts'),
('Speaker', 'Bluetooth speaker with deep bass');

INSERT INTO store.store (id_user, id_item, motion, amount_store, final_amount) VALUES
(1, 1, 'i', 10, 50),
(2, 2, 'i', 20, 40),
(3, 3, 'i', 15, 35),
(4, 4, 'i', 25, 75),
(5, 5, 's', 5, 15),
(6, 6, 's', 10, 30),
(7, 7, 's', 5, 15),
(8, 8, 'i', 50, 100),
(9, 9, 'i', 30, 90),
(10, 10, 's', 8, 24);

INSERT INTO sale.client (name_client) VALUES
('Client A'),
('Client B'),
('Client C'),
('Client D'),
('Client E'),
('Client F'),
('Client G'),
('Client H'),
('Client I'),
('Client J');

INSERT INTO sale.sale_detail (id_item, cost_detail, amount) VALUES
(1, 1000, 2),
(2, 800, 1),
(3, 500, 3),
(4, 200, 4),
(5, 300, 2),
(6, 150, 5),
(7, 250, 1),
(8, 150, 6),
(9, 120, 3),
(10, 100, 4);

INSERT INTO sale.sale (id_user, id_client, id_detail, stock) VALUES
(1, 1, 1, 5),
(2, 2, 2, 10),
(3, 3, 3, 4),
(4, 4, 4, 8),
(5, 5, 5, 6),
(6, 6, 6, 3),
(7, 7, 7, 2),
(8, 8, 8, 7),
(9, 9, 9, 9),
(10, 10, 10, 1);
SELECT * FROM sale.sale; ---te muestra las tablas

INSERT INTO buys.buys_supplier (supplier_name, company_name, email, number_phone) VALUES
('Supplier 1', 'Company A', 'supplier1@company.com', '123456789'),
('Supplier 2', 'Company B', 'supplier2@company.com', '234567890'),
('Supplier 3', 'Company C', 'supplier3@company.com', '345678901'),
('Supplier 4', 'Company D', 'supplier4@company.com', '456789012'),
('Supplier 5', 'Company E', 'supplier5@company.com', '567890123'),
('Supplier 6', 'Company F', 'supplier6@company.com', '678901234'),
('Supplier 7', 'Company G', 'supplier7@company.com', '789012345'),
('Supplier 8', 'Company H', 'supplier8@company.com', '890123456'),
('Supplier 9', 'Company I', 'supplier9@company.com', '901234567'),
('Supplier 10', 'Company J', 'supplier10@company.com', '012345678');
SELECT * FROM buys.buys_supplier;

INSERT INTO buys.buys_detail (id_item, cost_detail, amount_detail) VALUES
(1, 900, 5),
(2, 700, 8),
(3, 450, 10),
(4, 180, 12),
(5, 220, 15),
(6, 120, 20),
(7, 230, 6),
(8, 140, 25),
(9, 100, 30),
(10, 90, 7);

SELECT * FROM buys.buys_detail;

INSERT INTO buys.buys (id_user, id_buys_detail, id_buys_supplier) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10);


INSERT INTO promotion.promotion (id_item, amount_promotion, discount) VALUES
(1, 10, 5),
(2, 15, 10),
(3, 20, 5),
(4, 30, 15),
(5, 25, 10),
(6, 35, 20),
(7, 40, 10),
(8, 50, 25),
(9, 60, 30),
(10, 70, 20);
INSERT INTO buys.buys_detail (id_item, cost_detail, amount_detail) VALUES
(1, 900, 5),
(2, 700, 8),
(3, 450, 10),
(4, 180, 12),
(5, 220, 15),
(6, 120, 20),
(7, 230, 6),
(8, 140, 25),
(9, 100, 30),
(10, 90, 7);
INSERT INTO buys.buys (id_user, id_buys_detail, id_buys_supplier) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10);

--1.-¿Que promociones ha tenido un producto x ?
SELECT p.id, p.date_promotion, p.amount_promotion, p.discount
FROM promotion.promotion p
JOIN store.item i ON p.id_item = i.id
WHERE i.id = 1;


--2.- mostrar  las ventas realizadas por un usuario x
SELECT s.id, s.date_sale, sd.amount, sd.cost_detail
FROM sale.sale s
JOIN sale.sale_detail sd ON s.id_detail = sd.id
WHERE s.id_user = 1;


--3.- mostrar la lista de empleados en un cargo x 
SELECT e.id, e.name_employee, e.ap_paterno, e.ap_materno
FROM users.employee e
JOIN users.contrat c ON e.id = c.id_employee
JOIN users.position p ON c.id_position = p.id
WHERE p.id = 1;


--4.-mostar una lista de empleados que alla realizado una compra y saber el cargo 
SELECT e.id, e.name_employee, e.ap_paterno, e.ap_materno, p.name_position
FROM users.employee e
JOIN users.contrat c ON e.id = c.id_employee
JOIN users.position p ON c.id_position = p.id
JOIN sale.sale s ON s.id_user = e.id
WHERE s.id_detail IS NOT NULL;

--5.- saber cuanto queda de un producto x 
SELECT i.name_item, (s.amount_store - s.final_amount) AS remaining_stock
FROM store.store s
JOIN store.item i ON s.id_item = i.id
WHERE i.id = 1
ORDER BY s.date_store DESC
LIMIT 1;

--6.- mostrar la lista de proveedores que venden un producto x 
SELECT DISTINCT bs.supplier_name, bs.company_name, bs.email
FROM buys.buys b
JOIN buys.buys_supplier bs ON b.id_buys_supplier = bs.id
JOIN buys.buys_detail bd ON b.id_buys_detail = bd.id
WHERE bd.id_item = 1;


--7.- saber cuanto hacido el ingreso por ventas realizadas por un mes x 
SELECT SUM(sd.amount * sd.cost_detail) AS total_income
FROM sale.sale s
JOIN sale.sale_detail sd ON s.id_detail = sd.id
WHERE EXTRACT(MONTH FROM s.date_sale) = 1
AND EXTRACT(YEAR FROM s.date_sale) = 2025;


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
SELECT i.name_item, SUM(s.amount_store - s.final_amount) AS remaining_stock
FROM store.store s
JOIN store.item i ON s.id_item = i.id
GROUP BY i.id
HAVING SUM(s.amount_store - s.final_amount) < 10;

TRUNCATE TABLE buys.buys RESTART IDENTITY CASCADE;
TRUNCATE TABLE buys.buys_detail RESTART IDENTITY CASCADE;
TRUNCATE TABLE buys.buys_supplier RESTART IDENTITY CASCADE;
TRUNCATE TABLE sale.sale RESTART IDENTITY CASCADE;
TRUNCATE TABLE sale.sale_detail RESTART IDENTITY CASCADE;
TRUNCATE TABLE sale.client RESTART IDENTITY CASCADE;
TRUNCATE TABLE store.store RESTART IDENTITY CASCADE;
TRUNCATE TABLE store.item RESTART IDENTITY CASCADE;
TRUNCATE TABLE users.users RESTART IDENTITY CASCADE;
TRUNCATE TABLE users.employee RESTART IDENTITY CASCADE;
TRUNCATE TABLE users.contrat RESTART IDENTITY CASCADE;
TRUNCATE TABLE users.position RESTART IDENTITY CASCADE;
TRUNCATE TABLE users.area RESTART IDENTITY CASCADE;
TRUNCATE TABLE users.control_access RESTART IDENTITY CASCADE;
TRUNCATE TABLE promotion.promotion RESTART IDENTITY CASCADE;

