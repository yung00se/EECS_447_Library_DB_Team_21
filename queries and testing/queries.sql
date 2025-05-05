-- 1. List all books
SELECT m.media_id, m.title, b.author, m.genre, m.publication_year
FROM Media m
JOIN Book b ON m.media_id = b.media_id;;

-- 2. List all magazines
SELECT m.media_id, m.title, mag.issue_number, m.genre, m.publication_year
FROM Media m
JOIN Magazine mag ON m.media_id = mag.media_id;;

-- 3. Find books by a specific author
SELECT m.media_id, m.title, b.author, m.genre, m.publication_year
FROM Media m
JOIN Book b ON m.media_id = b.media_id
WHERE b.author = 'Author Name';;

-- 4. Search media by title keyword
SELECT media_id, title, genre, publication_year
FROM Media
WHERE title LIKE '%keyword%';;

-- 5. Media published before/after year
SELECT media_id, title, genre, publication_year
FROM Media
WHERE publication_year > 2020;;

-- 6. Media by genre
SELECT media_id, title, genre, publication_year
FROM Media
WHERE genre = 'Science';;

-- 7. Available copies of a media item
SELECT copy_id, branch_id
FROM Copy
WHERE media_id = 123 AND available = TRUE;;

-- 8. Checked-out copies of books
SELECT c.copy_id, c.branch_id, m.title, b.author
FROM Copy c
JOIN Media m ON c.media_id = m.media_id
JOIN Book b ON m.media_id = b.media_id
WHERE c.available = FALSE;;

-- 9. List all clients
SELECT client_id, first_name, last_name, membership
FROM Client;;

-- 10. Find client by name/email/ID
SELECT *
FROM Client
WHERE first_name LIKE '%John%'
   OR last_name LIKE '%John%'
   OR email LIKE '%john@example.com%'
   OR client_id = '1001';;

-- 11. Clients with overdue books
SELECT c.client_id, c.first_name, c.last_name, bt.copy_id, bt.due_date
FROM Borrow_Transaction bt
JOIN Client c ON bt.client_id = c.client_id
WHERE bt.return_date IS NULL AND bt.due_date < CURDATE();;

-- 12. Items currently borrowed by a client
SELECT bt.copy_id, bt.due_date
FROM Borrow_Transaction bt
WHERE bt.client_id = 1001 AND bt.return_date IS NULL;;

-- 13. Client transaction history
SELECT *
FROM Borrow_Transaction
WHERE client_id = 1001;;

-- 14. Clients with unpaid fines
SELECT client_id, SUM(overdue_fine) AS total_due
FROM Borrow_Transaction
WHERE return_date IS NULL AND overdue_fine > 0
GROUP BY client_id;;

-- 15. Top 10 active borrowers
SELECT client_id, COUNT(*) AS total_borrows
FROM Borrow_Transaction
GROUP BY client_id
ORDER BY total_borrows DESC
LIMIT 10;;

-- 16. List all staff
SELECT *
FROM Staff;;

-- 17. Find staff by branch
SELECT *
FROM Staff
WHERE branch_id = 1;;

-- 18. List all branches
SELECT *
FROM Branch;;

-- 19. Media count per branch
SELECT branch_id, COUNT(*) AS total_items
FROM Copy
GROUP BY branch_id;;

-- 20. Availability per branch
SELECT branch_id,
       SUM(CASE WHEN available THEN 1 ELSE 0 END) AS available,
       SUM(CASE WHEN NOT available THEN 1 ELSE 0 END) AS checked_out
FROM Copy
GROUP BY branch_id;;

-- 21. Copies of a media item
SELECT *
FROM Copy
WHERE media_id = 123;;

-- 22. Branches with most overdue items
SELECT c.branch_id, COUNT(*) AS overdue_count
FROM Borrow_Transaction bt
JOIN Copy c ON bt.copy_id = c.copy_id
WHERE bt.return_date IS NULL AND bt.due_date < CURDATE()
GROUP BY c.branch_id
ORDER BY overdue_count DESC;;

-- 23. All current borrow transactions
SELECT *
FROM Borrow_Transaction
WHERE return_date IS NULL;;

-- 24. Completed transactions
SELECT *
FROM Borrow_Transaction
WHERE return_date IS NOT NULL;;

-- 25. Transactions in date range
SELECT *
FROM Borrow_Transaction
WHERE borrow_date BETWEEN '2024-01-01' AND '2024-12-31';;

-- 26. Overdue transactions
SELECT *
FROM Borrow_Transaction
WHERE return_date IS NULL AND due_date < CURDATE();;

-- 27. Total fines collected in period
SELECT SUM(overdue_fine) AS total_collected
FROM Borrow_Transaction
WHERE return_date BETWEEN '2024-01-01' AND '2024-12-31';;

-- 28. Longest borrow durations
SELECT copy_id,
       DATEDIFF(IFNULL(return_date, CURDATE()), borrow_date) AS duration
FROM Borrow_Transaction
ORDER BY duration DESC
LIMIT 10;;

-- 29. All current reservations
SELECT *
FROM Reservation
WHERE return_date IS NULL;;

-- 30. Reservations by client
SELECT *
FROM Reservation
WHERE client_id = 1001;;

-- 31. Reserved items now available
SELECT r.*
FROM Reservation r
JOIN Copy c ON r.copy_id = c.copy_id
WHERE c.available = TRUE AND r.return_date IS NULL;;

-- 32. Reservations at a branch
SELECT r.*
FROM Reservation r
JOIN Copy c ON r.copy_id = c.copy_id
WHERE c.branch_id = 1;;

-- 33. Most frequent reservers
SELECT client_id, COUNT(*) AS reservation_count
FROM Reservation
GROUP BY client_id
ORDER BY reservation_count DESC
LIMIT 10;;

-- 34. Fines per client
SELECT client_id, SUM(overdue_fine) AS total_due
FROM Borrow_Transaction
WHERE overdue_fine > 0
GROUP BY client_id;;

-- 35. Clients with fines above threshold
SELECT client_id, SUM(overdue_fine) AS total_due
FROM Borrow_Transaction
WHERE overdue_fine > 25
GROUP BY client_id;;

-- 36. Total outstanding fines
SELECT SUM(overdue_fine) AS total_outstanding
FROM Borrow_Transaction
WHERE return_date IS NULL;;

-- 37. Fines paid in date range
SELECT client_id, SUM(overdue_fine) AS paid_fines
FROM Borrow_Transaction
WHERE return_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY client_id;;


