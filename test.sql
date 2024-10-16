--
-- File generated with SQLiteStudio v3.4.4 on Wed Oct 16 15:02:23 2024
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: test_table
CREATE TABLE IF NOT EXISTS test_table (ROWID INTEGER PRIMARY KEY ASC AUTOINCREMENT NOT NULL, NAME TEXT NOT NULL, SURNAME TEXT NOT NULL);
INSERT INTO test_table (ROWID, NAME, SURNAME) VALUES (1, 'Artem', 'Babichenko');
INSERT INTO test_table (ROWID, NAME, SURNAME) VALUES (2, 'Boghdan', 'Yarovoi');
INSERT INTO test_table (ROWID, NAME, SURNAME) VALUES (3, 'Yehor', 'Sivak');

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
