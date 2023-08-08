SELECT *
FROM customers
LIMIT 10; 

SELECT *
FROM orders
LIMIT 10; 

SELECT *
FROM books
LIMIT 10; 

-- primary key clearly deleted at some point
SELECT *
FROM pg_Indexes
WHERE tablename = 'customers'; 

SELECT *
FROM pg_Indexes
WHERE tablename = 'orders'; 

SELECT *
FROM pg_Indexes
WHERE tablename = 'books'; 

-- adding in primary key
ALTER TABLE customers
ADD PRIMARY KEY (customer_id); 

-- checking to ensure primary key index added into indexes
SELECT *
FROM pg_Indexes
WHERE tablename = 'customers'; 

-- takes 14.994 ms to execute
EXPLAIN ANALYZE SELECT customer_id, quantity
FROM orders
WHERE quantity > 18
ORDER BY customer_id
  ASC; 

-- creating index for only quantities > 18
CREATE INDEX orders_customer_id_quantity_more_than_18_idx ON orders (customer_id, quantity) 
  WHERE quantity > 18; 

-- takes 5.365 ms to execute, almost 1/3 the time without an index
EXPLAIN ANALYZE SELECT customer_id, quantity
FROM orders
WHERE quantity > 18
ORDER BY customer_id
  ASC; 
  
-- reclusters customers using the primary key (id) so it is now in order
CLUSTER customers USING customers_pkey; 
-- test to see that it worked with SELECT *
SELECT *
FROM customers
LIMIT 10;

-- create index on orders for customer_id and book_id
CREATE INDEX orders_customer_id_book_id_idx ON orders (customer_id, book_id); 
-- drop index to make new one
DROP INDEX orders_customer_id_book_id_idx; 
-- create new index including quantity
CREATE INDEX orders_customer_id_book_id_quantity_idx ON orders (customer_id, book_id, quantity); 

-- redo books indexes to optimize search
DROP INDEX books_title_idx;
DROP INDEX books_author_idx;
CREATE INDEX books_title_author_idx ON books (title, author); 

-- executes in 47.807 ms
EXPLAIN ANALYZE SELECT ( quantity * price_base ) 
FROM orders
WHERE (quantity * price_base) > 100; 

CREATE INDEX orders_total_price_idx ON orders ((quantity * price_base)); 

-- executes in 31.172 ms, so small time difference
EXPLAIN ANALYZE SELECT ( quantity * price_base ) 
FROM orders
WHERE (quantity * price_base) > 100; 

