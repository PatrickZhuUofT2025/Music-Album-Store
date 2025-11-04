DROP TABLE IF EXISTS album;
CREATE TABLE album(
	album_id INT,	
	title VARCHAR(100),
	artist_id INT
);
DROP TABLE IF EXISTS artist;
CREATE TABLE artist(
	artist_id INT,
	name VARCHAR(100)
);
DROP TABLE IF EXISTS customer;
CREATE TABLE customer(
	customer_id INT,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	company VARCHAR(50),
	address VARCHAR(50),
	city VARCHAR(50),
	state VARCHAR(5),
	country VARCHAR(50),
	postal_code VARCHAR(50),
	phone VARCHAR(50),
	fax VARCHAR(50),
	email VARCHAR(50),
	support_rep_id INT
);
DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
	employee_id	INT,
	last_name VARCHAR(50),
	first_name VARCHAR(50),
	title VARCHAR(50),
	reports_to INT,
	levels VARCHAR(2),
	birthdate DATE,
	hire_date DATE,
	address VARCHAR(50),
	city VARCHAR(50),
	state VARCHAR(2),
	country VARCHAR(50),
	postal_code VARCHAR(50),
	phone VARCHAR(50),
	fax VARCHAR(50),
	email VARCHAR(50)
);
DROP TABLE IF EXISTS genre_id;
CREATE TABLE genre(
	genre_id INT,
	name VARCHAR(50)
);
DROP TABLE IF EXISTS invoice;
CREATE TABLE invoice (
	invoice_id INT,
	customer_id INT,
	invoice_date DATE,
	billing_address VARCHAR(50),
	billing_city VARCHAR(50),
	billing_state VARCHAR(5),
	billing_country VARCHAR(20),
	billing_postal_code VARCHAR(50),
	total numeric
);
DROP TABLE IF EXISTS invoice_line;
CREATE TABLE invoice_line (
	invoice_line_id	INT,
	invoice_id INT,
	track_id INT,
	unit_price numeric,
	quantity INT
);
DROP TABLE IF EXISTS media_type;
CREATE TABLE media_type (
	media_type_id INT,
	name VARCHAR(50)
);
DROP TABLE IF EXISTS playlist;
CREATE TABLE playlist (
	playlist_id INT,
	name VARCHAR(50)
);
DROP TABLE IF EXISTS playlist_track;
CREATE TABLE playlist_track (
	playlist_id INT,
	track_id INT
);
DROP TABLE IF EXISTS track;
CREATE TABLE track (
	track_id INT,
	name VARCHAR(200),
	album_id INT,
	media_type_id INT,
	genre_id INT,
	composer VARCHAR(200),
	milliseconds INT,
	bytes INT,
	unit_price numeric
);
