-- Data Definition Language (DDL) - Creating tables with constraints.
-------------------------------------------------------------

-- BOOKS table definition: This table stores details of books with the columns BOOKID, TITLE, AUTHOR, and PUBLISHEDYEAR.
-- The primary key constraint ensures that BOOKID is unique and not null.
CREATE TABLE "BOOKS" (
    "BOOKID" NUMBER NOT NULL,                      -- BOOKID: A unique number for each book (cannot be null).
    "TITLE" VARCHAR2(100 BYTE) NOT NULL,           -- TITLE: The title of the book, up to 100 characters long (cannot be null).
    "AUTHOR" VARCHAR2(100 BYTE) NOT NULL,          -- AUTHOR: The name of the author (cannot be null).
    "PUBLISHEDYEAR" DATE NOT NULL,                 -- PUBLISHEDYEAR: The year the book was published (cannot be null).
    CONSTRAINT "BOOKS_PK" PRIMARY KEY ("BOOKID")   -- BOOKS_PK: Primary key constraint on BOOKID to ensure uniqueness.
);

-- LOANS table definition: Tracks loans of books to members.
-- The foreign key constraints link BOOKID and MEMBERID to the BOOKS and MEMBERS tables respectively.
CREATE TABLE "LOANS" (
    "LOANID" NUMBER NOT NULL,                      -- LOANID: A unique number for each loan (cannot be null).
    "MEMBERID" NUMBER NOT NULL,                    -- MEMBERID: References the member who borrowed the book.
    "BOOKID" NUMBER NOT NULL,                      -- BOOKID: References the book that was borrowed.
    "LOANDATE" DATE NOT NULL,                      -- LOANDATE: The date when the book was loaned.
    "RETURNDATE" DATE NOT NULL,                    -- RETURNDATE: The date when the book is due to be returned.
    CONSTRAINT "LOANS_PK" PRIMARY KEY ("LOANID"),  -- LOANS_PK: Primary key constraint on LOANID.
    CONSTRAINT "LOANS_FK1" FOREIGN KEY ("BOOKID") REFERENCES "BOOKS" ("BOOKID"),  -- LOANS_FK1: Foreign key constraint on BOOKID, linking to BOOKS table.
    CONSTRAINT "LOANS_FK2" FOREIGN KEY ("MEMBERID") REFERENCES "MEMBERS" ("MEMBERID") -- LOANS_FK2: Foreign key constraint on MEMBERID, linking to MEMBERS table.
);

-- MEMBERS table definition: This table stores details of library members.
-- The primary key constraint ensures that MEMBERID is unique.
CREATE TABLE "MEMBERS" (
    "MEMBERID" NUMBER(20,0) NOT NULL,              -- MEMBERID: A unique ID number for each member (cannot be null).
    "FIRSTNAME" VARCHAR2(20 BYTE) NOT NULL,        -- FIRSTNAME: The first name of the member (cannot be null).
    "LASTNAME" VARCHAR2(20 BYTE) NOT NULL,         -- LASTNAME: The last name of the member (cannot be null).
    CONSTRAINT "MEMBERS_PK" PRIMARY KEY ("MEMBERID") -- MEMBERS_PK: Primary key constraint on MEMBERID to ensure uniqueness.
);

-- Data Manipulation Language (DML) - Insert, update, and delete data in the tables.
------------------------------------------------------------------------------------

-- INSERT DATA
-- Inserting records into BOOKS, MEMBERS, and LOANS tables.
-- Inserting data into the BOOKS table:
INSERT INTO "BOOKS" ("BOOKID", "TITLE", "AUTHOR", "PUBLISHEDYEAR") 
VALUES (123, 'Half of a Yellow Sun', 'Chimamanda Adichie', TO_DATE('11-SEP-2003', 'DD-MON-YYYY')); -- Insert a book.

INSERT INTO "BOOKS" ("BOOKID", "TITLE", "AUTHOR", "PUBLISHEDYEAR") 
VALUES (12345, 'We Should All Be Feminists', 'Chimamanda Adichie', TO_DATE('23-SEP-2024', 'DD-MON-YYYY')); -- Insert another book.

INSERT INTO "BOOKS" ("BOOKID", "TITLE", "AUTHOR", "PUBLISHEDYEAR") 
VALUES (1234, 'Purple Hibiscus', 'Chimamanda Adichie', TO_DATE('18-MAY-2006', 'DD-MON-YYYY')); -- Insert a third book.

-- Inserting data into the MEMBERS table:
INSERT INTO "MEMBERS" ("MEMBERID", "FIRSTNAME", "LASTNAME") 
VALUES (456, 'Alice', 'Smith'); -- Insert a member.

INSERT INTO "MEMBERS" ("MEMBERID", "FIRSTNAME", "LASTNAME") 
VALUES (654, 'Bob', 'Johnson'); -- Insert another member.

INSERT INTO "MEMBERS" ("MEMBERID", "FIRSTNAME", "LASTNAME") 
VALUES (567, 'Uwayo', 'Olga'); -- Insert a third member.

-- Inserting data into the LOANS table:
INSERT INTO "LOANS" ("LOANID", "MEMBERID", "BOOKID", "LOANDATE", "RETURNDATE") 
VALUES (7655, 456, 123, TO_DATE('24-SEP-2024', 'DD-MON-YYYY'), TO_DATE('27-SEP-2024', 'DD-MON-YYYY')); -- Loan a book to a member.

INSERT INTO "LOANS" ("LOANID", "MEMBERID", "BOOKID", "LOANDATE", "RETURNDATE") 
VALUES (234, 654, 1234, TO_DATE('24-SEP-2024', 'DD-MON-YYYY'), TO_DATE('28-SEP-2024', 'DD-MON-YYYY')); -- Loan another book to a different member.

INSERT INTO "LOANS" ("LOANID", "MEMBERID", "BOOKID", "LOANDATE", "RETURNDATE") 
VALUES (567, 654, 12345, TO_DATE('24-SEP-2024', 'DD-MON-YYYY'), TO_DATE('30-SEP-2024', 'DD-MON-YYYY')); -- Loan a third book.

-- UPDATE DATA
-- Update an existing loan record by changing MEMBERID, BOOKID, LOANDATE, and RETURNDATE for LOANID = 7655.
UPDATE "LOANS"
SET "MEMBERID" = 654, 
    "BOOKID" = 1234, 
    "LOANDATE" = TO_DATE('25-SEP-2024', 'DD-MON-YYYY'), 
    "RETURNDATE" = TO_DATE('29-SEP-2024', 'DD-MON-YYYY')
WHERE "LOANID" = 7655;

-- DELETE DATA
-- Delete a member from the MEMBERS table where MEMBERID = 456.
DELETE FROM "MEMBERS"
WHERE "MEMBERID" = 456;

-- JOINS - Retrieving data from multiple tables using JOINs.
------------------------------------------------------------

-- INNER JOIN: Displays MEMBERID, FIRSTNAME, LASTNAME, BOOKID, and TITLE of books that were loaned.
SELECT M."MEMBERID", M."FIRSTNAME", M."LASTNAME", B."BOOKID", B."TITLE"
FROM "MEMBERS" M
JOIN "LOANS" L ON M."MEMBERID" = L."MEMBERID"  -- Join MEMBERS and LOANS on MEMBERID.
JOIN "BOOKS" B ON L."BOOKID" = B."BOOKID";     -- Join LOANS and BOOKS on BOOKID.

-- LEFT JOIN: Displays all members and the books they've borrowed. If a member hasn't borrowed any books, still include their details.
SELECT M."MEMBERID", M."FIRSTNAME", M."LASTNAME", B."TITLE"
FROM "MEMBERS" M
LEFT JOIN "LOANS" L ON M."MEMBERID" = L."MEMBERID"  -- Left join MEMBERS and LOANS.
LEFT JOIN "BOOKS" B ON L."BOOKID" = B."BOOKID";     -- Left join LOANS and BOOKS.

-- SUBQUERIES: Retrieves the total number of loans for each member using a subquery.
SELECT M."MEMBERID", M."FIRSTNAME",
    (SELECT COUNT(*) 
     FROM "LOANS" L 
     WHERE L."MEMBERID" = M."MEMBERID") AS "TOTAL_LOANS" -- Subquery to count loans per member.
FROM "MEMBERS" M;

-- SELECT - Simple queries to fetch data from individual tables.
------------------------------------------------------------

-- Select all books.
SELECT "BOOKID", "TITLE", "AUTHOR", "PUBLISHEDYEAR" 
FROM "BOOKS";

-- Select all loans.
SELECT "LOANID", "MEMBERID", "BOOKID", "LOANDATE", "RETURNDATE"
FROM "LOANS";

-- Select all members.
SELECT "MEMBERID", "FIRSTNAME", "LASTNAME"
FROM "MEMBERS";

-- Data Control Language (DCL) - Granting privileges to users.
-------------------------------------------------------------

-- Creating a new user and granting them privileges to connect and use resources in the database.
CREATE USER C##LIBRARIAN1 IDENTIFIED BY librarian123; -- Create a new user named LIBRARIAN1 with a password.
GRANT CONNECT, RESOURCE TO C##LIBRARIAN1;            -- Grant the user connection and resource usage privileges.

-- Transaction Control Language (TCL) - Managing transactions.
--------------------------------------------------------------

-- A transaction block that inserts data into the BOOKS and MEMBERS tables.
-- If any part of the transaction fails, it will roll back all changes.
BEGIN
   INSERT INTO "BOOKS" ("BOOKID", "TITLE", "AUTHOR", "PUBLISHEDYEAR") 
   VALUES (3, 'Educated', 'Tara Westover', TO_DATE('28-FEB-2018', 'DD-MON-YYYY'));
   
   INSERT INTO "MEMBERS" ("MEMBERID", "FIRSTNAME", "LASTNAME") 
   VALUES (4, 'James', 'Smith');
   
   COMMIT; -- Commit the transaction, saving changes.
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK; -- If an error occurs, roll back the transaction.
END;
