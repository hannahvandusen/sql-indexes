-- TAKES 4.207 ms Execution time
EXPLAIN ANALYZE SELECT *
FROM customers
WHERE years_old BETWEEN 13 AND 19; 

CREATE INDEX customers_years_old_teen_idx ON customers (years_old) 
  WHERE years_old BETWEEN 13 AND 19; 

-- takes 2.815 ms Execution time with index created
EXPLAIN ANALYZE SELECT *
FROM customers
WHERE years_old BETWEEN 13 AND 19; 

CREATE INDEX customers_state_name_email_address_idx ON customers (state_name, email_address); 

-- takes .064 ms execution time
EXPLAIN ANALYZE SELECT state_name, email_address
FROM customers
WHERE state_name = 'California' OR state_name = 'Ohio'
  ORDER BY
    state_name DESC,
    email_address ASC; 

CREATE INDEX customers_state_name_email_address_ordered_idX ON customers (state_name DESC, email_address ASC); 

-- takes 0.040 ms execution time (so slightly faster)
EXPLAIN ANALYZE SELECT state_name, email_address
FROM customers
WHERE state_name = 'California' OR state_name = 'Ohio'
  ORDER BY
    state_name DESC,
    email_address ASC; 

    -- create clustered index on column in table
CLUSTER customers USING customers_last_name_idx; 

-- many changes made and need to recluster the index
CLUSTER customers; 

-- automatically defaults to non-clustered unless you specify the index as clustered
CREATE INDEX customers_state_name_idx ON customers (state_name); 

-- use new index to obtain last name of everyone from Texas
SELECT last_name, state_name
FROM customers
WHERE state_name = 'Texas'
ORDER BY last_name
  ASC; 

  -- takes 1.816 ms to execute
EXPLAIN ANALYZE SELECT first_name, last_name, email_address
FROM customers
WHERE last_name = 'Smith'; 

CREATE INDEX customers_last_name_first_name_email_address_idx ON customers (last_name, first_name, email_address); 

-- takes .951 ms to execute with index containing all selected columns
EXPLAIN ANALYZE SELECT first_name, last_name, email_address
FROM customers
WHERE last_name = 'Smith'; 

-- .070 ms execution
EXPLAIN ANALYZE SELECT *
FROM customers
WHERE last_name = 'Jones' AND first_name = 'Steve'; 

CREATE INDEX customers_last_name_first_name_idx ON customers (last_name, first_name); 

-- .048 ms execution 
EXPLAIN ANALYZE SELECT *
FROM customers
WHERE last_name = 'Jones' AND first_name = 'Steve'; 

-- create unique index where it's not case sensitive
CREATE UNIQUE INDEX customers_email_address_lower_unique_idx ON customers (LOWER(email_address)); 

-- returns error with unique email_address constraint
INSERT INTO customers (first_name, last_name, email_address) VALUES (
  'first',
  'last',
  'example@email.com'
), (
  'first',
  'last',
  'ExaMple@email.com'
); 

