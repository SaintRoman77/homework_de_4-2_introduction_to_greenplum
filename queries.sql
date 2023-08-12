CREATE TABLE public.books (
    book_id SERIAL PRIMARY KEY,
    book_name TEXT NOT NULL,
    book_price REAL NOT NULL
)
DISTRIBUTED BY (book_id);

CREATE TABLE public.books_sales (
    sales_id SERIAL,
    book_id INT NOT NULL,
    sales_date DATE NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books (book_id) ON DELETE SET NULL
)
DISTRIBUTED BY (sales_id)
PARTITION BY RANGE(sales_date)
(START(DATE '2023-01-01') INCLUSIVE
 END(DATE '2023-06-01') EXCLUSIVE
 EVERY(INTERVAL '1 month')
);

INSERT INTO public.books (book_name, book_price)
VALUES ('Евгений Онегин', 100.10),
       ('Капитанская дочка', 200.20),
       ('Кавказский пленник', 300.30),
       ('Война и мир, том 1', 400.40),
       ('Герой нашего времени', 500.50),
       ('Княгиня Лиговская', 600.60),
       ('Отцы и дети', 700.70),
       ('Муму', 800.80),
       ('Белая гвардия', 900.90),
       ('Собачье сердце', 1000.10),
       ('Руслан и Людмила', 1100.10);


INSERT INTO public.books_sales (book_id, sales_date)
VALUES (1, '2023-01-01'), (2, '2023-02-02'), (3, '2023-03-03'),
       (4, '2023-02-01'), (5, '2023-03-01'), (6, '2023-03-02'),
       (7, '2023-04-01'), (8, '2023-04-02'), (9, '2023-05-01'),
       (10, '2023-05-02'), (11, '2023-05-03'), (1, '2023-01-03'),
       (1, '2023-01-04'), (2, '2023-02-01'), (3, '2023-03-01'),
       (4, '2023-03-03'), (4, '2023-05-03'), (5, '2023-03-03'),
       (6, '2023-03-03'), (7, '2023-04-03'), (7, '2023-04-07');

SET optimizer = ON;

EXPLAIN
SELECT b.book_name, SUM(b.book_price) "TOTAL"
FROM books_sales bs
JOIN books b USING(book_id)
WHERE b.book_id = 4 AND bs.sales_date < '2023-04-01'
GROUP BY b.book_name;