--see first 10 entries for customers, orders, and books tables
SELECT *
FROM customers
LIMIT 10; 

SELECT *
FROM orders
LIMIT 10; 

SELECT *
FROM books
LIMIT 10; 

--see existing indexes for customers, orders, and books
SELECT *
FROM pg_Indexes
WHERE tablename = 'customers'; 

SELECT *
FROM pg_Indexes
WHERE tablename = 'orders'; 

SELECT *
FROM pg_Indexes
WHERE tablename = 'books'; 

--create indexes
-- CREATE INDEX orders_customer_id_idx ON orders (customer_id); 

-- CREATE INDEX orders_book_id_idx ON orders (book_id);
-- takes .045 ms execution time
EXPLAIN ANALYZE SELECT original_language, title, sales_in_millions
FROM books
WHERE original_language = 'French'; 

--56 kB
SELECT pg_size_pretty (pg_total_relation_size('books'));

CREATE INDEX books_title_original_language_sales_in_millions_idx ON books (title, original_language, sales_in_millions); 

-- takes .024 ms execution time (1/2 the time)
EXPLAIN ANALYZE SELECT original_language, title, sales_in_millions
FROM books
WHERE original_language = 'French'; 

--88 kB (32 kB increase with the index)
SELECT pg_size_pretty (pg_total_relation_size('books'));

--delete index 
DROP INDEX books_title_original_language_sales_in_millions_idx; 

--takes roughly 1 second with indexes existing
SELECT NOW();
 
\COPY orders FROM 'orders_add.txt' DELIMITER ',' CSV HEADER;
 
SELECT NOW();

--recreate indexes after removing them, copying now takes roughly 1/2 the time
CREATE INDEX orders_customer_id_idx ON orders (customer_id); 

CREATE INDEX orders_book_id_idx ON orders (book_id);
