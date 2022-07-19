select table_name FROM user_tables;

-- SQL vs PL/SQL
-- SQL (분석가90% + 개발자 30%)
    ---- 프로그래밍 성격이 얕다
-- PL/SQL (분석가10% + 개발자70% +DBA)

-- 입문 : SQL테이블, 뷰 --> PL/SQL함수, 프로시저

-- 테이블 생성
/*
CREATE TABLE 테이블명(
    컬럼1 컬럼1_데이터타입 [결측치허용유무],
    
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

INSERT INTO ex2_2 VALUES('홍길동','홍길동','홍길동');
INSERT INTO ex2_2 (column3) VALUES ('홍길동');
SELECT column3, LENGTH(column3) AS len3, LENGTH(column3) AS bytelen
 FROM ex2_2;
 
CREATE TABLE ex2_3(
    COL_INT INTEGER,
    COL_DEC DECIMAL,
    COL_NUM NUMBER
);

/*
R -> dplyr 패키지
SELECT 컬럼명
FROM 테이블명
WHERE 조건식
ORDER BY 정렬기준
*/

SELECT column_id
       , column_name
       , data_type
       , data_length
 FROM user_tab_cols
 WHERE table_name = 'EX2_3'
 ORDER BY column_id;
-- 사용자가 생성한 제약조건 확인(user_constraints) 
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

-- 결측치 허용 X : NOT NULL

CREATE TABLE ex2_6(
    COL_NULL VARCHAR2(10),
    COL_NOT_NULL VARCHAR2(10) Not NULL
);

INSERT INTO ex2_6 VALUES('AA','');

INSERT INTO ex2_6 VALUES('','BB');

SELECT * FROM ex2_6;

-- UNIQUE (중복값 허용 X)
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
-- 기본키
-- UNIQUE, NOT NULL
-- 테이블당 1개의 기본키만 가능

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

-- 외래키
-- 테이블간의 참조 데이터 무결성 위한 제약 조건
-- 참조 무결성을 보장한다 -> 잘못된 정보가 입력되는 것을 방지

-- Check
-- 컬럼에 입력되는 데이터를 체크해 특정 조건에 맞는 데이터만 입력
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

-- 컬럼명 변경
ALTER TABLE ex2_10 RENAME COLUMN Col1 TO Col11;
DESC ex2_10;

-- 타입변경
ALTER TABLE ex2_10 MODIFY col2 VARCHAR2(30);
DESC ex2_10;

-- 컬럼 추가
ALTER TABLE ex2_10 ADD Col3 NUMBER;
DESC ex2_10;

-- 컬럼 삭제
ALTER TABLE ex2_10 DROP COLUMN COL3;
DESC ex2_10;

-- 제약조건 추가하기
ALTER TABLE ex2_10 ADD CONSTRAINTS pk_ex2_10 PRIMARY KEY (Col11);
SELECT constraint_name
       , constraint_type
       , table_name
       ,search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';

-- 제약조건 삭제
ALTER TABLE ex2_10 DROP CONSTRAINTS pk_ex2_10;
SELECT constraint_name
       , constraint_type
       , table_name
       ,search_condition
FROM user_constraints
WHERE table_name = 'EX2_10';

-- 테이블 복사
CREATE TABLE ex2_9_1 AS
SELECT * FROM ex2_9;
DESC ex2_9_1;
-- 뷰 생성
-- 테이블이나 또다른 뷰를 참조하는 객체
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

-- 뷰 삭제
DROP VIEW emp_dept_v1;



