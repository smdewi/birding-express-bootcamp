DROP TABLE IF EXISTS tubes CASCADE;
DROP TABLE IF EXISTS tests CASCADE;
DROP TABLE IF EXISTS tests_tubes CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS orders_tests CASCADE;
DROP TABLE IF EXISTS users;

CREATE TABLE tubes (
  id SERIAL PRIMARY KEY,
  color TEXT,
  info TEXT,
  order_of_draw INTEGER
);

CREATE TABLE tests (
  id SERIAL PRIMARY KEY,
  name TEXT,
  info TEXT
);

CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  name TEXT,
  street TEXT,
  city TEXT,
  postal INTEGER,
  country TEXT,
  email TEXT,
  phone INTEGER
);

CREATE TABLE patients (
  id SERIAL PRIMARY KEY,
  patient_name TEXT,
  patient_nric TEXT,
  patient_dob TEXT,
  patient_address TEXT,
  patient_city TEXT,
  patient_country TEXT,
  patient_postal TEXT,
  patient_email TEXT,
  patient_phone INTEGER
);

CREATE TABLE tests_tubes (
  id SERIAL PRIMARY KEY,
  test_id SERIAL,
  tube_id SERIAL,
  CONSTRAINT fk_test FOREIGN KEY(test_id) REFERENCES tests(id),
  CONSTRAINT fk_tube FOREIGN KEY(tube_id) REFERENCES tubes(id)
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  customer_id SERIAL,
  username TEXT UNIQUE,
  password TEXT,
  first_name TEXT,
  last_name TEXT,
  email TEXT,
  CONSTRAINT fk_customer FOREIGN KEY(customer_id) REFERENCES customers(id)
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id SERIAL,
  patient_id SERIAL,
  order_date TEXT,
  order_status TEXT,
  CONSTRAINT fk_customer FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT fk_patient FOREIGN KEY(patient_id) REFERENCES patients(id)
);

CREATE TABLE orders_tests (
  id SERIAL PRIMARY KEY,
  order_id SERIAL,
  orderedtest_id SERIAL,
  isAccepted BOOLEAN,
  comment TEXT,
  CONSTRAINT fk_order FOREIGN KEY(order_id) REFERENCES orders(id),
  CONSTRAINT fk_test FOREIGN KEY(orderedtest_id) REFERENCES tests(id)
);



INSERT INTO tubes (color, info, order_of_draw) VALUES ('light blue', 'Sodium Citrate', 1);
INSERT INTO tubes (color, info, order_of_draw) VALUES ('red', 'Plain', 2);
INSERT INTO tubes (color, info, order_of_draw) VALUES ('gold', 'GEL', 3);
INSERT INTO tubes (color, info, order_of_draw) VALUES ('royal blue', 'Trace Element', 4);
INSERT INTO tubes (color, info, order_of_draw) VALUES ('green', 'Heparin', 5);
INSERT INTO tubes (color, info, order_of_draw) VALUES ('lavender', 'EDTA', 6);
INSERT INTO tubes (color, info, order_of_draw) VALUES ('grey', 'Sodium Fluoride', 7);

INSERT INTO tests (name, info) VALUES ('HBA', 'Glycated Haemoglobin (HbA1c)');
INSERT INTO tests (name, info) VALUES ('GLU', 'Glucose (fasting)');
INSERT INTO tests (name, info) VALUES ('HY01', 'Hypertension profile');
INSERT INTO tests (name, info) VALUES ('DFS1', 'Dengue fever profile');

INSERT INTO customers (name, street, city, postal, country, email, phone) VALUES ('Sunshine Family Clinic', 'Blk 491 Jurong West', 'Singapore', 648161, 'Singapore', 'sunshine_clinic@gmail.com', 63982258);
INSERT INTO customers (name, street, city, postal, country, email, phone) VALUES ('Mount Sinai Hospital', '3 Mount Sinai Road', 'Singapore', 228510, 'Singapore', 'mtsinai@gmail.com', 67312218);
INSERT INTO customers (name, street, city, postal, country, email, phone) VALUES ('National Dialysis Centre', '825 Woodlands', 'Singapore', 730825, 'Singapore', 'ndc@gmail.com', 63651810);

INSERT INTO patients (patient_name, patient_nric, patient_dob, patient_address, patient_city, patient_country, patient_postal, patient_email, patient_phone) VALUES ('Tan Tjie Kiong', 'B19492010', '20/01/1949', 'Ploso Baru 75', 'Surabaya', 'Indonesia', 206254, 'ttk@gmail.com', 7341628);
INSERT INTO patients (patient_name, patient_nric, patient_dob, patient_address, patient_city, patient_country, patient_postal, patient_email, patient_phone) VALUES ('Denyse Lim', 'S444444', '20/05/1940', 'Jalan Seroja 28', 'Johor Bahru', 'Malaysia', 814000, 'dlim@gmail.com', 60235689);
INSERT INTO patients (patient_name, patient_nric, patient_dob, patient_address, patient_city, patient_country, patient_postal, patient_email, patient_phone) VALUES ('John Barry', 'X55544', '31/10/1941', '44 Main St', 'Providence', 'USA', 211444, 'jbarry@conspiracy.com', 44444444);
INSERT INTO patients (patient_name, patient_nric, patient_dob, patient_address, patient_city, patient_country, patient_postal, patient_email, patient_phone) VALUES ('Mary Koh', 'P777777', '07/07/1987', 'Blk 480 Jurong West 41', 'Singapore', 'Singapore', 648162, 'mkoh@gmail.com', 15973684);
INSERT INTO patients (patient_name, patient_nric, patient_dob, patient_address, patient_city, patient_country, patient_postal, patient_email, patient_phone) VALUES ('Roshni Patel', 'A123456', '14/02/1996', '47 Gardner Street', 'Boston', 'USA', 617845, 'rpatel@gmail.com', 34256689);
INSERT INTO patients (patient_name, patient_nric, patient_dob, patient_address, patient_city, patient_country, patient_postal, patient_email, patient_phone) VALUES ('Ismail Hasan', 'B232323', '07/06/2000', '40 Bukit Batok St 21', 'Singapore', 'Singapore', 588187, 'ismail@gmail.com', 78453625);

INSERT INTO tests_tubes (test_id, tube_id) VALUES (1, 6);
INSERT INTO tests_tubes (test_id, tube_id) VALUES (2, 7);
INSERT INTO tests_tubes (test_id, tube_id) VALUES (3, 2);
INSERT INTO tests_tubes (test_id, tube_id) VALUES (3, 6);
INSERT INTO tests_tubes (test_id, tube_id) VALUES (3, 7);
INSERT INTO tests_tubes (test_id, tube_id) VALUES (4, 2);
INSERT INTO tests_tubes (test_id, tube_id) VALUES (4, 6);

INSERT INTO users (customer_id, username, password, first_name, last_name, email) VALUES (1, 'betty','79a21f17d71da2c0e851479b36ab9db174df676ad36d479b3ba524b6343b3790f8295b0367d8f0e71f1254c1ab34b9f49e4d27197371a2cd6f531a4b1716b18a', 'Betty', 'Wong', 'bwong@sunshineclinic.com');
INSERT INTO users (customer_id, username, password, first_name, last_name, email) VALUES (2,'adam', '574e5555ff92d0acda78b4c8e89350486e7a0d6b943051a51f8a18651884bbf987bbd461e2f5a2e7f640f927dca9daf942cc29d0f9285d94265e711afdddd2d9', 'Adam', 'Smith', 'asmith@mtsinai.com');
INSERT INTO users (customer_id, username, password, first_name, last_name, email) VALUES (3,'ali','15235cf272b760adab86e7bd543d8da89898166c58ba40dd922cab4151a0919b01f6e51d22e06e3c182c2132115800158877539b2c06af21041caae86be1c354', 'Ali', 'Wibowo', 'ali@ndc.com');

INSERT INTO orders (user_id, patient_id, order_date, order_status) VALUES (1, 1, '1/2/2022', 'Ordered');
INSERT INTO orders (user_id, patient_id, order_date, order_status) VALUES (1, 2, '1/2/2022', 'Ordered');
INSERT INTO orders (user_id, patient_id, order_date, order_status) VALUES (2, 3, '2/2/2022', 'Ordered');
INSERT INTO orders (user_id, patient_id, order_date, order_status) VALUES (2, 4, '2/2/2022', 'Ordered');
INSERT INTO orders (user_id, patient_id, order_date, order_status) VALUES (3, 5, '3/2/2022', 'Ordered');
INSERT INTO orders (user_id, patient_id, order_date, order_status) VALUES (3, 6, '3/2/2022', 'Ordered');

INSERT INTO orders_tests (order_id, orderedtest_id) VALUES (1, 1);
INSERT INTO orders_tests (order_id, orderedtest_id) VALUES (1, 2);
INSERT INTO orders_tests (order_id, orderedtest_id) VALUES (2, 3);
INSERT INTO orders_tests (order_id, orderedtest_id) VALUES (3, 4);
INSERT INTO orders_tests (order_id, orderedtest_id) VALUES (4, 1);
INSERT INTO orders_tests (order_id, orderedtest_id) VALUES (4, 2);
INSERT INTO orders_tests (order_id, orderedtest_id) VALUES (5, 3);
INSERT INTO orders_tests (order_id, orderedtest_id) VALUES (6, 4);

