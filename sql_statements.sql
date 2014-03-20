SELECT books_authors.id, books.title, authors.name
FROM books_authors INNER JOIN books ON books.id = books_authors.book_id
                    INNER JOIN authors ON authors.id = books_authors.author_id;


SELECT books.title, authors.name FROM books_authors INNER JOIN books ON (books.id = books_authors.book_id) INNER JOIN authors ON (authors.id = books_authors.author_id) WHERE books.title LIKE '%#{search_term}%';
