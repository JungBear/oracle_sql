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
