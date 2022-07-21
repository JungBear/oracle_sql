select table_name FROM user_tables;

-- SQL vs PL/SQL
-- SQL (?¬Þ???90% + ?????? 30%)
    ---- ???¥á???? ?????? ???
-- PL/SQL (?¬Þ???10% + ??????70% +DBA)

-- ??? : SQL?????, ?? --> PL/SQL???, ???¥í???

-- ????? ????
/*
CREATE TABLE ???????(
    ?¡À?1 ?¡À?1_????????? [????????????],
    
)
*/

CREATE TABLE ex2_1(
    COLUMN1 CHAR(10),
    COLUMN2 VARCHAR2(10),
    COLUMB3 NVARCHAR2(10),
    COLUMB4 NUMBER
);

INSERT INTO ex2_1(Column1,column2) VALUES('abc','abc');
SELECT column1, LENGTH(column1)as len1,
       column2, LENGTH(column2)as len2
       FROM ex2_1;

CREATE TABLE ex2_2(
    COLUMN1 VARCHAR2(3),
    COLUMN2 VARCHAR2(3 byte),
    COLUMN3 VARCHAR2(3 char)
);

INSERT INTO ex2_2 VALUES('abc','abc','abc');

SELECT column1, LENGTH(column1) As len1,
       column2, LENGTH(column2) AS len2,
       column3, LENGTH(column3) AS len3
FROM ex2_2;

INSERT INTO ex2_2 VALUES('??øª','??øª','??øª');
INSERT INTO ex2_2 (column3) VALUES ('??øª');
SELECT column3, LENGTH(column3) AS len3, LENGTH(column3) AS bytelen
 FROM ex2_2;
 
CREATE TABLE ex2_3(
    COL_INT INTEGER,
    COL_DEC DECIMAL,
    COL_NUM NUMBER
);

/*
R -> dplyr ?????
SELECT ?¡À???
FROM ???????
WHERE ?????
ORDER BY ???©¥???
*/

SELECT column_id
       , column_name
       , data_type
       , data_length
 FROM user_tab_cols
 WHERE table_name = 'EX2_3'
 ORDER BY column_id;
-- ?????? ?????? ???????? ???(user_constraints) 
 SELECT constraint_name
        , constraint_type
        , table_name
        , search_condition
FROM user_constraints
WHERE table_name = 'EX2_6';

CREATE TABLE ex2_4(
    COL_FLOT1 FLOAT(32),
    COL_FLOT2 FLOAT
);

INSERT INTO ex2_4(col_flot1, col_flot2) VALUES(1234567891234,1234567891234);
SELECT col_flot1, LENGTH(col_flot1) AS len1,
       col_flot2, LENGTH(col_flot2) AS len2
FROM ex2_4;

CREATE TABLE ex2_5(
    COL_DATE DATE,
    COL_TIMESTaMP TIMESTaMP
);

INSERT INTO ex2_5 VALUES(SYSDATE,SYSTIMESTAMP);
SELECT * 
FROM ex2_5;

-- ????? ??? X : NOT NULL

CREATE TABLE ex2_6(
    COL_NULL VARCHAR2(10),
    COL_NOT_NULL VARCHAR2(10) Not NULL
);

INSERT INTO ex2_6 VALUES('AA','');

INSERT INTO ex2_6 VALUES('','BB');

SELECT * FROM ex2_6;

-- UNIQUE (????? ??? X)
CREATE TABLE ex2_7(
    COL_UNIQUE_NULL VARCHAR2(10) UNIQUE,
    COL_UNIQUE_NNULL VARCHAR2(10) UNIQUE NOT NULL,
    COL_UNIQUE VARCHAR(10),
CONSTRAINTS UNIQUE_NM1 UNIQUE (COL_UNIQUE)
);

SELECT constraint_name
       , constraint_type
       , table_name
       ,search_condition
FROM user_constraints
WHERE table_name = 'EX2_7';

INSERT INTO ex2_7 VALUES('AA','AA','AA');
INSERT INTO ex2_7 VALUES('AA','AA','AA');
INSERT INTO ex2_7 VAlUES('','BB','BB');
INSERT INTO ex2_7 VALUES('','CC','CC');
SELECT * FROM ex2_7;

-- Primary Key
-- ???
-- UNIQUE, NOT NULL
-- ??????? 1???? ????? ????

CREATE TABLE ex2_8(
    COL1 VARCHAR2(10) PRIMARY KEY,
    COL2 VARCHAR2(10)
);
DROP TABLE EX2_8;
SELECT * FROM user_constraints;
SELECT constraint_name
       , constraint_type
       , table_name
       ,search_condition
FROM user_constraints
WHERE table_name = 'EX2_8';

INSERT INTO ex2_8 VALUES('AA','AA');

-- ????
-- ????????? ???? ?????? ???? ???? ???? ????
-- ???? ?????? ??????? -> ????? ?????? ????? ???? ????

-- Check
-- ?¡À??? ????? ??????? ???? ??? ????? ?¢¥? ??????? ???
DROP TABLE ex2_9;
CREATE TABLE ex2_9(
    num1 NUMBER
    CONSTRAINTS check1 CHECK ( num1 BETWEEN 1 AND 9),
    gender VARCHAR2(10)
    CONSTRAINTS check2 CHECK (gender IN ('MALE','FEMALE'))
);

INSERT INTO ex2_9 VALUES (5, 'FEMALE');

SELECT constraint_name
       , constraint_type
       , table_name
       ,search_condition
FROM user_constraints
WHERE table_name = 'EX2_9';  

-- Default
CREATE TABLE ex2_10(
    Col1 VARCHAR2(10) NoT NULL,
    Col2 VARCHAR2(10) NULL,
    Create_date DATE DEFAULT SYSDATE);  
    
INSERT INTO ex2_10(col1, col2) VALUES('AA','BB');
SELECT * FROM ex2_10;
alter session set nls_date_format='YYYY/MM/DD HH24:MI:SS';
DROP TABLE ex2_10;

CREATE TABLE ex2_10(
    Col1 VARCHAR2(10) NOT NULL,
    Col2 VARCHAR2(10) NULL,
    Create_date DATE DEFAULT SYSDATE);

-- ?¡À??? ????
ALTER TABLE ex2_10 RENAME COLUMN Col1 TO Col11;
DESC ex2_10;

-- ??????
ALTER TABLE ex2_10 MODIFY col2 VARCHAR2(30);
DESC ex2_10;

-- ?¡À? ???
ALTER TABLE ex2_10 ADD Col3 NUMBER;
DESC ex2_10;

-- ?¡À? ????
ALTER TABLE ex2_10 DROP COLUMN COL3;
DESC ex2_10;

-- ???????? ??????
ALTER TABLE ex2_10 ADD CONSTRAINTS pk_ex2_10 PRIMARY KEY (Col11);
SELECT constraint_name
       , constraint_type
       , table_name
       ,search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';

-- ???????? ????
ALTER TABLE ex2_10 DROP CONSTRAINTS pk_ex2_10;
SELECT constraint_name
       , constraint_type
       , table_name
       ,search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';

-- ????? ????
CREATE TABLE ex2_9_1 AS
SELECT * FROM ex2_9;
DESC ex2_9_1;
-- ?? ????
-- ???????? ???? ?? ??????? ???
SELECT a.employee_id
       , a.emp_name
       , a.department_id
       , b.department_name
FROM employees a
     , departments b
WHERE a.department_id = b.department_id;

CREATE OR REPLACE VIEW emp_dept_v1 AS
SELECT a.employee_id
       , a.emp_name
       , a.department_id
       , b.department_name
FROM employees a
     , departments b
WHERE a.department_id = b.department_id;

SELECT * FROM emp_dept_v1;

-- ?? ????
DROP VIEW emp_dept_v1;



