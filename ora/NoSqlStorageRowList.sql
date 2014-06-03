DROP TYPE NoSqlStorageRowList;

CREATE OR REPLACE TYPE NoSqlStorageRowList
AS VARRAY (4000) OF NoSqlStorageRow
/
