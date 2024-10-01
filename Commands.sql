

                                 -- Data Definition Language (Create tables with constraints.)
                                 -------------------------------------------------------------

           --BOOKS

CREATE TABLE "BOOKS" (
    "BOOKID" NUMBER NOT NULL,
    "TITLE" VARCHAR2(100 BYTE) NOT NULL,
    "AUTHOR" VARCHAR2(100 BYTE) NOT NULL,
    "PUBLISHEDYEAR" DATE NOT NULL,
    CONSTRAINT "BOOKS_PK" PRIMARY KEY ("BOOKID")
) ;
           --LOANS
           
CREATE TABLE "LOANS" (
    "LOANID" NUMBER NOT NULL,
    "MEMBERID" NUMBER NOT NULL,
    "BOOKID" NUMBER NOT NULL,
    "LOANDATE" DATE NOT NULL,
    "RETURNDATE" DATE NOT NULL,
    CONSTRAINT "LOANS_PK" PRIMARY KEY ("LOANID"),
    CONSTRAINT "LOANS_FK1" FOREIGN KEY ("BOOKID") REFERENCES "BOOKS" ("BOOKID"),
    CONSTRAINT "LOANS_FK2" FOREIGN KEY ("MEMBERID") REFERENCES "MEMBERS" ("MEMBERID")
);
          -- MEMBERS

CREATE TABLE "MEMBERS" (
    "MEMBERID" NUMBER(20,0) NOT NULL,
    "FIRSTNAME" VARCHAR2(20 BYTE) NOT NULL,
    "LASTNAME" VARCHAR2(20 BYTE) NOT NULL,
    CONSTRAINT "MEMBERS_PK" PRIMARY KEY ("MEMBERID")
);

                              

                              --Data Manipulation Language(Insert, update, and delete data in the tables)
                           --------------------------------------------------------------------------------

            -- INSERT DATA
            ---------------
  -- BOOKS
INSERT INTO "BOOKS" ("BOOKID", "TITLE", "AUTHOR", "PUBLISHEDYEAR") VALUES (123, 'Half of a Yellow Sun', 'Chimamanda Adichie', TO_DATE('11-SEP-2003', 'DD-MON-YYYY'));
INSERT INTO "BOOKS" ("BOOKID", "TITLE", "AUTHOR", "PUBLISHEDYEAR") VALUES (12345, 'We Should All Be Feminists', 'Chimamanda Adichie', TO_DATE('23-SEP-2024', 'DD-MON-YYYY'));
INSERT INTO "BOOKS" ("BOOKID", "TITLE", "AUTHOR", "PUBLISHEDYEAR") VALUES (1234, 'Purple Hibiscus', 'Chimamanda Adichie', TO_DATE('18-MAY-2006', 'DD-MON-YYYY'));
  -- MEMBERS 
INSERT INTO "MEMBERS" ("MEMBERID", "FIRSTNAME", "LASTNAME") VALUES (456, 'Alice', 'Smith');
INSERT INTO "MEMBERS" ("MEMBERID", "FIRSTNAME", "LASTNAME") VALUES (654, 'Bob', 'Johnson');
INSERT INTO "MEMBERS" ("MEMBERID", "FIRSTNAME", "LASTNAME") VALUES (567, 'Uwayo', 'Olga');

  -- LOANS
INSERT INTO "LOANS" ("LOANID", "MEMBERID", "BOOKID", "LOANDATE", "RETURNDATE") VALUES (7655, 456, 123, TO_DATE('24-SEP-2024', 'DD-MON-YYYY'), TO_DATE('27-SEP-2024', 'DD-MON-YYYY'));
INSERT INTO "LOANS" ("LOANID", "MEMBERID", "BOOKID", "LOANDATE", "RETURNDATE") VALUES (234, 654, 1234, TO_DATE('24-SEP-2024', 'DD-MON-YYYY'), TO_DATE('28-SEP-2024', 'DD-MON-YYYY'));
INSERT INTO "LOANS" ("LOANID", "MEMBERID", "BOOKID", "LOANDATE", "RETURNDATE") VALUES (567, 654, 12345, TO_DATE('24-SEP-2024', 'DD-MON-YYYY'), TO_DATE('30-SEP-2024', 'DD-MON-YYYY'));


 --UPDATE ( LET'S UPDATE ONE OF THE LOANIDS)

UPDATE "LOANS"
SET "MEMBERID" = 654,
    "BOOKID" = 1234,
    "LOANDATE" = TO_DATE('25-SEP-2024', 'DD-MON-YYYY'),
    "RETURNDATE" = TO_DATE('29-SEP-2024', 'DD-MON-YYYY')
WHERE "LOANID" = 7655;


--DELETE
DELETE FROM "MEMBERS"
WHERE "MEMBERID" = 456;

--INNER JOIN ( display the MEMBERID, FIRSTNAME, LASTNAME, BOOKID, and TITLE of the books that were loaned)
SELECT M."MEMBERID", M."FIRSTNAME", M."LASTNAME", B."BOOKID", B."TITLE"
FROM "MEMBERS" M
JOIN "LOANS" L ON M."MEMBERID" = L."MEMBERID"
JOIN "BOOKS" B ON L."BOOKID" = B."BOOKID";

--LEFT JOIN (display all members and the books they've borrowed. If a member hasn't borrowed any books, still include their details.)

SELECT M."MEMBERID", M."FIRSTNAME", M."LASTNAME", B."TITLE"
FROM "MEMBERS" M
LEFT JOIN "LOANS" L ON M."MEMBERID" = L."MEMBERID"
LEFT JOIN "BOOKS" B ON L."BOOKID" = B."BOOKID";

--SUBQUERRIES ( Here the inner subquery calculates the total number of loans for each MEMBERID.
-- and The outer query displays the MEMBERID, FIRSTNAME, and TOTAL_LOANS for each member.)

SELECT M."MEMBERID", M."FIRSTNAME", 
    (SELECT COUNT(*)
     FROM "LOANS" L
     WHERE L."MEMBERID" = M."MEMBERID") AS "TOTAL_LOANS"
FROM "MEMBERS" M;

-- SELECT 
-----------

--BOOKS 

 SELECT BookID, Title, Author, PublishedYear
  FROM books;
-- LOANS

 SELECT LoanID, memberiD, BookID, loandate, returndate
   FROM loans;

-- MEMBERS

 SELECT MemberID, FirstName, LastName, JoinDate
 FROM members;

                                 --Data Control Language(Grant privileges to users)
                               ------------------------------------------------------
CREATE USER C##lIBRARIAN1 IDENTIFIED BY librarian123;
GRANT CONNECT, RESOURCE TO C##lIBRARIAN1;
                      
                                --Transaction Control Language(Use transactions to manage changes)
                              ---------------------------------------------------------------------

BEGIN
    INSERT INTO "BOOKS" ("BOOKID", "TITLE", "AUTHOR", "PUBLISHEDYEAR") 
    VALUES (3, 'Educated', 'Tara Westover', TO_DATE('20-JUL-2020', 'DD-MON-YYYY'));

    INSERT INTO "MEMBERS" ("MEMBERID", "FIRSTNAME", "LASTNAME") 
    VALUES (3, 'Alice', 'Smith');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Transaction failed: ' || SQLERRM);
END;
/


