
create table countries(
  id_country serial primary key,
  name varchar(50) not null  
);

create table users(
 id_users serial primary key, --serial is for postgrest, mysql equivalent of AUTO_INCREMENT
 id_country integer not null,
 email varchar(100) not null,
 name varchar (50) not null,
 foreign key (id_country) references countries (id_country)   
);

-- create
insert into countries (name) values ('argentina') , ('colombia'),('chile');
select * from countries;


insert into users (id_country, email, name) 
  values (2, 'foo@foo.com', 'fooziman'), (3, 'bar@bar.com', 'barziman'); 
select * from users;

-- delete
delete from users where email = 'bar@bar.com';

-- update
update users set email = 'foo@foo.foo', name = 'fooz' where id_users = 1;
select * from users;

-- select
select * from users inner join  countries on users.id_country = countries.id_country;

select u.id_users as id, u.email, u.name as fullname, c.name 
 from users u inner join  countries c on u.id_country = c.id_country;
 
 
 -- HACK 3
 -- design contact databasecountries
 Create table priorities(
   id_priority serial PRIMARY KEY,
   type_name VARCHAR(30) not null
 );
 
 CREATE TABLE contact_request(
   id_email serial Primary Key,
   id_priority integer not null,
   id_country integer not null,
   name varchar(40) not null,
   detail varchar(100) not null,
   physical_address varchar(100) not null,
   FOREIGN key(id_priority) references priorities (id_priority),
   FOREIGN KEY(id_country) REFERENCES countries (id_country)
   
 );
 
 -- HACK 4
 -- insert into countries, priorities and contact_requestcontact_request
 insert into countries (name) 
  values ('venezuela'), ('portugal'), ('bolivia'), ('brazil'), ( 'mexico'); 
    
  insert into priorities (type_name) 
  values ('low'), ('medium'), ('high'); 

  insert into contact_request (id_priority,id_country,name,detail,physical_address) 
  VALUES('1', '1', 'Ana Pérez', 'Consulta sobre precios bajos.', 'Calle Falsa 123, Buenos Aires, Argentina'),
    ('2', '4', 'Carlos Rodríguez', 'Solicitud de información adicional.', 'Avenida Principal, Edificio XYZ, Caracas, Venezuela'),
    ('3', '6', 'Sofía Mamani', 'Urgente: Necesita asistencia inmediata.', 'Calle Bolívar N° 456, La Paz, Bolivia');
    
    SELECT * from contact_request;
    

 --hay solo un usuario entonces creo uno primero
 INSERT into users (id_country, email, name) 
 VALUES(2, 'user@example.com', 'ultimo usuario');

--delete last user
DELETE FROM users
WHERE id_users = (SELECT MAX(id_users) FROM users);

--update first user
UPDATE users
SET email = 'modificado@hotmail.com'
WHERE id_users = 1;

-- HACK 5
-- NOTA: en la imagen del HACK se indica que la primary key de la tabla customer es email* entonces, id_customer como foreign key en el resto de tablas
---- se implementan haciendo referencia al campo customers.email

-- Table: countries
CREATE TABLE countries (
    id_country SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Table: roles
CREATE TABLE roles (
    id_role SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Table: taxes
CREATE TABLE taxes (
    id_tax SERIAL PRIMARY KEY,
    percentage DECIMAL(5, 2) NOT NULL
);

-- Table: offers
CREATE TABLE offers (
    id_offer SERIAL PRIMARY KEY,
    status VARCHAR(20)
);

-- Table: discounts
CREATE TABLE discounts (
    id_discount SERIAL PRIMARY KEY,
    status VARCHAR(20),
  	percentage DECIMAL(5, 2) NOT NULL
);

-- Table: payments
CREATE TABLE payments (
    id_payment SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL
);

-- Table: customers
CREATE TABLE customers (
    email VARCHAR(255) PRIMARY KEY,
    id_country INTEGER REFERENCES countries(id_country),
    id_role INTEGER REFERENCES roles(id_role), -- No DEFAULT clause here
    name VARCHAR(100) NOT NULL,
    age INTEGER,
    password VARCHAR(255) NOT NULL,
    physical_address TEXT
);

-- Table: invoice_status
CREATE TABLE invoice_status (
    id_invoice_status SERIAL PRIMARY KEY,
    status VARCHAR(20) NOT NULL
);

-- Table: products
CREATE TABLE products (
    id_product SERIAL PRIMARY KEY,
    id_discount INTEGER REFERENCES discounts(id_discount),
    id_offer INTEGER REFERENCES offers(id_offer),
    id_tax INTEGER REFERENCES taxes(id_tax) NOT NULL,
    name VARCHAR(255) NOT NULL,
    details TEXT,
    minimum_stock INTEGER DEFAULT 0,
    maximum_stock INTEGER,
    current_stock INTEGER DEFAULT 0,
    price DECIMAL(10, 2) NOT NULL,
    price_with_tax DECIMAL(10, 2)
);

-- Table: product_customers (Many-to-Many)
CREATE TABLE product_customers (
    id_product INTEGER REFERENCES products(id_product) ON DELETE CASCADE,
    id_customer VARCHAR(255) REFERENCES customers(email) ON DELETE CASCADE,
    PRIMARY KEY (id_product, id_customer)
);

-- Table: invoices
CREATE TABLE invoices (
    id_invoice SERIAL PRIMARY KEY,
    id_customer VARCHAR REFERENCES customers(email) NOT NULL,
    id_payment INTEGER REFERENCES payments(id_payment) NOT NULL,
    id_invoice_status INTEGER REFERENCES invoice_status(id_invoice_status) NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_to_pay DECIMAL(10, 2) NOT NULL
);

-- Table: orders (Line items for each order/invoice)
CREATE TABLE orders (
    id_order SERIAL PRIMARY KEY,
    id_invoice INTEGER REFERENCES invoices(id_invoice) NOT NULL,
    id_product INTEGER REFERENCES products(id_product) NOT NULL,
    detail TEXT,
    quantity INTEGER NOT NULL DEFAULT 1,
    amount DECIMAL(10, 2) NOT NULL, -- Price per unit at the time of order
    price DECIMAL(10, 2) GENERATED ALWAYS AS (amount * quantity) STORED
);


-- HACK 5
-- Table: countries
CREATE TABLE countries (
    id_country SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Table: roles
CREATE TABLE roles (
    id_role SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Table: taxes
CREATE TABLE taxes (
    id_tax SERIAL PRIMARY KEY,
    percentage DECIMAL(5, 2) NOT NULL
);

-- Table: offers
CREATE TABLE offers (
    id_offer SERIAL PRIMARY KEY,
    status VARCHAR(20)
);

-- Table: discounts
CREATE TABLE discounts (
    id_discount SERIAL PRIMARY KEY,
    status VARCHAR(20),
  	percentage DECIMAL(5, 2) NOT NULL
);

-- Table: payments
CREATE TABLE payments (
    id_payment SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL
);

-- Table: customers
CREATE TABLE customers (
    email VARCHAR(255) PRIMARY KEY,
    id_country INTEGER REFERENCES countries(id_country),
    id_role INTEGER REFERENCES roles(id_role), -- No DEFAULT clause here
    name VARCHAR(100) NOT NULL,
    age INTEGER,
    password VARCHAR(255) NOT NULL,
    physical_address TEXT
);

-- Table: invoice_status
CREATE TABLE invoice_status (
    id_invoice_status SERIAL PRIMARY KEY,
    status VARCHAR(20) NOT NULL
);

-- Table: products
CREATE TABLE products (
    id_product SERIAL PRIMARY KEY,
    id_discount INTEGER REFERENCES discounts(id_discount),
    id_offer INTEGER REFERENCES offers(id_offer),
    id_tax INTEGER REFERENCES taxes(id_tax) NOT NULL,
    name VARCHAR(255) NOT NULL,
    details TEXT,
    minimum_stock INTEGER DEFAULT 0,
    maximum_stock INTEGER,
    current_stock INTEGER DEFAULT 0,
    price DECIMAL(10, 2) NOT NULL,
    price_with_tax DECIMAL(10, 2)
);

-- Table: product_customers (Many-to-Many)
CREATE TABLE product_customers (
    id_product INTEGER REFERENCES products(id_product) ON DELETE CASCADE,
    id_customer VARCHAR(255) REFERENCES customers(email) ON DELETE CASCADE,
    PRIMARY KEY (id_product, id_customer)
);

-- Table: invoices
CREATE TABLE invoices (
    id_invoice SERIAL PRIMARY KEY,
    id_customer VARCHAR REFERENCES customers(email) NOT NULL,
    id_payment INTEGER REFERENCES payments(id_payment) NOT NULL,
    id_invoice_status INTEGER REFERENCES invoice_status(id_invoice_status) NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_to_pay DECIMAL(10, 2) NOT NULL
);

-- Table: orders (Line items for each order/invoice)
CREATE TABLE orders (
    id_order SERIAL PRIMARY KEY,
    id_invoice INTEGER REFERENCES invoices(id_invoice) NOT NULL,
    id_product INTEGER REFERENCES products(id_product) NOT NULL,
    detail TEXT,
    quantity INTEGER NOT NULL DEFAULT 1,
    amount DECIMAL(10, 2) NOT NULL, -- Price per unit at the time of order
    price DECIMAL(10, 2) GENERATED ALWAYS AS (amount * quantity) STORED
);

--HACK 6:

-- Table: countries
INSERT INTO countries (name) VALUES ('Venezuela'), ('Canada'), ('UK');

-- Table: roles
INSERT INTO roles (name) VALUES ('customer'), ('admin'), ('editor');

-- Table: taxes
INSERT INTO taxes (percentage) VALUES (8.25), (5.00), (0.00);

-- Table: offers
INSERT INTO offers (status) VALUES ('active'), ('inactive'), ('pending');

-- Table: discounts
INSERT INTO discounts (status, percentage) VALUES ('active', 10.00), ('inactive', 0.00), ('special', 15.00);

-- Table: payments
INSERT INTO payments (type) VALUES ('Credit Card'), ('PayPal'), ('Bank Transfer');

-- Table: customers
INSERT INTO customers (email, id_country, id_role, name, age, password, physical_address)
VALUES
    ('john.doe@example.com', 1, 1, 'John Doe', 30, 'password123', '123 Main St'),
    ('jane.smith@example.com', 2, 1, 'Jane Smith', 25, 'password456', '456 Oak Ave'),
    ('robert.jones@example.com', 3, 2, 'Robert Jones', 40, 'password789', '789 Pine Ln');

-- Table: invoice_status
INSERT INTO invoice_status (status) VALUES ('pending'), ('paid'), ('shipped');

-- Table: products
INSERT INTO products (id_discount, id_offer, id_tax, name, details, price)
VALUES
    (1, 1, 1, 'Laptop', 'Powerful laptop for work and play', 1200.00),
    (2, 2, 1, 'Mouse', 'Ergonomic wireless mouse', 25.00),
    (NULL, NULL, 3, 'Keyboard', 'Mechanical keyboard for gaming', 75.00);

-- Table: product_customers
INSERT INTO product_customers (id_product, id_customer)
VALUES
    (1, 'john.doe@example.com'),
    (2, 'john.doe@example.com'),
    (3, 'jane.smith@example.com');

-- Table: invoices
INSERT INTO invoices (id_customer, id_payment, id_invoice_status, total_to_pay)
VALUES
    ('john.doe@example.com', 1, 1, 1225.00),  -- Laptop + Mouse
    ('jane.smith@example.com', 2, 1, 75.00),   -- Keyboard
    ('robert.jones@example.com', 3, 1, 2400.00); -- Two Laptops

-- Table: orders
INSERT INTO orders (id_invoice, id_product, quantity, amount)
VALUES
    (1, 1, 1, 1200.00), -- Laptop
    (1, 2, 1, 25.00),  -- Mouse
    (2, 3, 1, 75.00),  -- Keyboard
     (3,1,2,1200.00);

-- delete last user?
-- en el ecommerce crud no hay "users" si suponemos que los users son los de la tabla customers
-- no hay forma de eliminar el ultimo usuario debido a que la primary key solicitada en la tabla es 'email'
-- es decir, no hay forma de reconocer cual fue el ultimo registro, solo se pueden eliminar registro por email


-- update last user? lo mismo aplica

--update all taxes:
-- ejemplo, incrementar todos los impuestos un 2%
UPDATE taxes
SET percentage = percentage + 2;

--update all prices
-- incrementar todos los precios un 10%
UPDATE products
SET price = price * 1.10;
