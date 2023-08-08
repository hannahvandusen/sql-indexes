SELECT *
FROM customers;

-- shows existing customers index table
SELECT *
FROM pg_Indexes
WHERE tablename = 'customers';

-- search on a column without an index
EXPLAIN ANALYZE SELECT *
FROM customers
WHERE first_name = 'David'; 

-- search on a column with an index
EXPLAIN ANALYZE SELECT *
FROM customers
WHERE last_name = 'Jones'; 

-- create a customers index on the customers table for the city column 
CREATE INDEX customers_city_idx ON customers (city);

SELECT *
FROM pg_indexes
WHERE tablename = 'customers'; 

-- much longer execution time to search database without index
EXPLAIN ANALYZE SELECT *
FROM customers 
WHERE last_name = 'Jones' AND first_name = 'David'; 

CREATE INDEX customers_last_name_first_name_idx ON customers (last_name, first_name); 

-- speed after creating index much faster
EXPLAIN ANALYZE SELECT *
FROM customers 
WHERE last_name = 'Jones' AND first_name = 'David'; 

-- dropping index from customers table
SELECT *
FROM pg_Indexes
WHERE tablename = 'customers'; 

DROP INDEX IF EXISTS customers_last_name_idx; 

SELECT *
FROM pg_Indexes
WHERE tablename = 'customers'; 

--13mb table size
SELECT pg_size_pretty (pg_total_relation_size('customers'));

CREATE INDEX customers_last_name_idx ON customers(last_name); 

--15mb now just adding 1 index 
SELECT pg_size_pretty (pg_total_relation_size('customers'));

