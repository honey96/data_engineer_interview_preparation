-- Postgres Table Creation Script
--

--
-- Table structure for table departments
--

CREATE TABLE IF NOT EXISTS departments (
  department_id INT NOT NULL,
  department_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (department_id)
);

--
-- Table structure for table categories
--

CREATE TABLE IF NOT EXISTS categories (
  category_id INT NOT NULL,
  category_department_id INT NOT NULL,
  category_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (category_id)
); 

--
-- Table structure for table products
--

CREATE TABLE IF NOT EXISTS products (
  product_id INT NOT NULL,
  product_category_id INT NOT NULL,
  product_name VARCHAR(45) NOT NULL,
  product_description VARCHAR(255) NOT NULL,
  product_price FLOAT NOT NULL,
  product_image VARCHAR(255) NOT NULL,
  PRIMARY KEY (product_id)
);

--
-- Table structure for table customers
--

CREATE TABLE IF NOT EXISTS customers (
  customer_id INT NOT NULL,
  customer_fname VARCHAR(45) NOT NULL,
  customer_lname VARCHAR(45) NOT NULL,
  customer_email VARCHAR(45) NOT NULL,
  customer_password VARCHAR(45) NOT NULL,
  customer_street VARCHAR(255) NOT NULL,
  customer_city VARCHAR(45) NOT NULL,
  customer_state VARCHAR(45) NOT NULL,
  customer_zipcode VARCHAR(45) NOT NULL,
  PRIMARY KEY (customer_id)
); 

--
-- Table structure for table orders
--

CREATE TABLE IF NOT EXISTS orders (
  order_id INT NOT NULL,
  order_date TIMESTAMP NOT NULL,
  order_customer_id INT NOT NULL,
  order_status VARCHAR(45) NOT NULL,
  PRIMARY KEY (order_id)
);

--
-- Table structure for table order_items
--

CREATE TABLE IF NOT EXISTS order_items (
  order_item_id INT NOT NULL,
  order_item_order_id INT NOT NULL,
  order_item_product_id INT NOT NULL,
  order_item_quantity INT NOT NULL,
  order_item_subtotal FLOAT NOT NULL,
  order_item_product_price FLOAT NOT NULL,
  PRIMARY KEY (order_item_id)
);

CREATE TABLE IF NOT EXISTS user_activity (
  "date" TIMESTAMP NOT NULL ,
  user_id INT NOT NULL,
  activity VARCHAR(45) NOT NULL
)


create table if not EXISTS customers_iq( customer_id int, customer_name varchar(100), customer_email varchar(200), primary key (customer_id) );

create table if not exists  orders_iq ( order_id int, customer_id int, amount float, status varchar(50), primary key (order_id) );

create table if not exists warehouse_table (name varchar(50), product_id int, units int) ; 

create table if not exists product_table (product_id int, product_name varchar(50),width int, length int, height int) ; 

create table if not exists result_table (warehouse_name varchar(50), volume float) ; 

create table if not exists orders_table (order_number int , customer_number int ) ;

create table if not exists employee_table (id int ,salary float ) ; 

create table if not exists patient_table (patient_id int , patient_name varchar(50), conditions varchar(50)) ; 

create table if not exists customer_table (customer_id int ,product_key int ) ; 

create table if not exists products_table (products_key int ) ; 

create table if not exists scores_table (player_name varchar(50), gender varchar(50), day timestamp, score_points int) ;

create table if not exists my_numbers (num int ) ;

create table if not exists person_table(id int , email varchar(50)) ; 