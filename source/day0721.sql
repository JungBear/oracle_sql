-- 기본 집계 함수
-- count

SELECT COUNT(*)
FROM employees;

SELECT COUNT(employee_id)
FROM employees;

SELECT COUNT(department_id)
FROM employees;

-- DISTINCT 
-- 종류추출
SELECT COUNT(DISTINCT department_id)
FROM employees;

SELECT DISTINCT department_id
FROM employees
ORDER BY 1;

-- 기초통계량
-- SQL 
--> 통계도구 & 머신러닝, 데이터과학 도구로 사용

-- SUM
-- 합계
SELECT SUM(salary)
FROM employees;

SELECT SUM(salary), SUM(DISTINCT salary)
FROM employees;

-- AVG
-- 평균
SELECT AVG(salary), AVG(DISTINCT salary)
FROM employees;

-- MIN,MAX
-- 최소, 최대
SELECT MIN(salary), MAX(salary)
FROM employees;
-- DISTINCT를 사용가능하지만
-- 최소값과 최댓값을 똑같이 출력
SELECT MIN(DISTINCT salary), MAX(DISTINCT salary)
FROM employees;

-- VARIANCE, STDDEV
-- 분산        , 표준편차
SELECT VARIANCE(salary), STDDEV(salary)
FROM employees;


-- GROUP BY절과 HAVING절
-- GROUP BY : 특정그룹으로 묶어 데이터를 집계할때 사용
--> WHERE와 ORDER BY절 사이에 위치

SELECT department_id,  SUM(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;

SELECT * FROM kor_loan_status;

-- 2013년 지역별 가계대출 총 잔액
SELECT period
           ,region
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, region
ORDER BY period, region

-- 2013년 11월 총 잔액
SELECT period
           ,region
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY region
ORDER BY region;

-- HAVING절
-- GROUP BY 다음에 위치
-- GROUP BY로 필터링된 결과를 대상으로 다시 필터를 건다
SELECT period
           ,region
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY period, region
HAVING SUM(loan_jan_amt) > 100000
ORDER BY region;

-- ROLLUP절 
-- expr로 명시한 표현식을 기준으로 집계한 결과
-- 추가적인 집계 정보를 보여줌
-- 명시한 표현식 수와 순서에 따라 레벨별로 집계한 결과가 반환


-- 2013년도 대출 종류별 총 잔액
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, gubun
ORDER BY period;

-- rollup 사용
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period, gubun);

-- 분할 ROLLUP
-- period -> gubun 순으로 정렬
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, ROLLUP(gubun );

-- gubun -> period 순으로 정렬
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP (period),gubun;

-- CUBE 
-- 명시한 표현식 개수에 따라 가능한 모든 조합별로 집계한 결과를 반환
-- 2^(expr의 수)
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY CUBE(period, gubun);
-- expr의 수가 2이므로 총 4가지의 유형으로 집계가 된다
-- 결과를 보면 전체, 대출 종류별, 월별, 월별 대출 종류별로 집계가 되었다.

-- 분할 CUBE
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, CUBE(gubun);

-- 집합 연산자
-- UNION
-- 합칩합
CREATE TABLE exp_goods_asia(
    country VARCHAR2(10),
    seq NUMBER,
    goods VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('한국',1,'원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국',2,'자동차');
INSERT INTO exp_goods_asia VALUES ('한국',3,'전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국',4,'선박');
INSERT INTO exp_goods_asia VALUES ('한국',5,'LCD');
INSERT INTO exp_goods_asia VALUES ('한국',6,'자동차 부품');
INSERT INTO exp_goods_asia VALUES ('한국',7,'선박');
INSERT INTO exp_goods_asia VALUES ('한국',8,'환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국',9,'무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국',10,'철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본',1,'자동차');
INSERT INTO exp_goods_asia VALUES ('일본',2,'자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본',3,'전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본',4,'선박');
INSERT INTO exp_goods_asia VALUES ('일본',5,'반도체워이퍼');
INSERT INTO exp_goods_asia VALUES ('일본',6,'화물차');
INSERT INTO exp_goods_asia VALUES ('일본',7,'원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본',8,'건설기계');
INSERT INTO exp_goods_asia VALUES ('일본',9,'다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본',10,'기계류');
commit;

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
ORDER BY seq;

-- 두 국가가 겹치는 수출품목은 한번만 조회되도록 할때 사용
SELECT goods
FROM exp_goods_asia
WHERE country='한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country='일본';

-- UNION ALL
-- 중복된 항목도 모두 조회
SELECT goods
FROM exp_goods_asia
WHERE country='한국'
UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country='일본';

-- MINUS
-- 차집합

SELECT goods
FROM exp_goods_asia
WHERE country='한국'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country='일본';

-- 집합연산자의 제한사항
-- 집합연산자로 연결되는 각 SELECT문의 리스트개수와 데이터타입은 일치해야한다
SELECT goods
FROM exp_goods_asia
WHERE country='한국'
UNION
SELECT seq,goods
FROm exp_goods_asia
WHERE country = '일본';
-- 리스트의 갯수가 맞지않아 에러발생

SELECT seq,goods
FROM exp_goods_asia
WHERE country='한국'
UNION
SELECT seq,goods
FROm exp_goods_asia
WHERE country = '일본';
-- seq와 goods모두 중복

-- 집합연산자로 SELECT문을 연결할때 ORDER BY는 맨 마지막 문장에서만 사용 가능
SELECT goods
FROM exp_goods_asia
WHERE country='한국'
ORDER BY goods
UNION
SELECT goods
FROM exp_goods_asia
WHERE country='일본';
-- ORDER BY가 중간에 들어가서 오류

SELECT goods
FROM exp_goods_asia
WHERE country='한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country='일본';
ORDER BY goods;

-- BLOB, CLOB, BFILE 타입의 컬럼에 대해서는 집합 연산자 사용 불가능
-- UNION, INTERSECT, MINUS 연산자는 LONG형 컬럼에 사용 불가능

-- GROUPING SET
-- ROLLUP이나 CUBE처럼 GROUP BY에 사용해서  그룹쿼리에 사용
-- UNION ALL개념 포함
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY GROUPING SETS(period, gubun);
-- GROUPING SETS에 period와 gubun을 명시해서 월별합계, 대출 졸유별 합계만 집계

SELECT period
           ,gubun
           ,region
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
AND region IN ('서울','경기')
GROUP BY GROUPING SETS (period, (gubun,region));
-- period와 (gubun,region)으로 집계되었다

-- 조인
-- 동등 조인(=)
-- WHERE절에 기술한 조건
-- 두 컬럼 값이 같은 행을 추출
SELECT a.employee_id
           ,a.emp_name
           ,a.department_id
           ,b.department_name
FROM employees a
          ,departments b
WHERE a.department_id = b.department_id;

-- 세미조인
-- 서브쿼리를 이용해 서브쿼리에 존재하는 데이터만 메인 쿼리에서 추출

-- EXISTS 사용
SELECT department_id
           ,department_name
FROM departments a
WHERE EXISTS( SELECT *
                      FROM employees b
                      WHERE a.department_id = b.department_id
                      AND b.salary > 3000)
ORDER BY a.department_name;

-- IN 사용
-- 서브쿼리 내 두테이블의 조인X
SELECT department_id
           , department_name
FROM departments a
WHERE a.department_id IN (SELECT b.department_id
                                     FROM employees b
                                     WHERE b.salary > 3000)
ORDER BY department_name;            

-- 안티조인
-- 세미조인의 반대 개념
-- NOT IN, NOT EXISTS 사용
SELECT a.employee_id
           ,a.emp_name
           ,a.department_id
           ,b.department_name
FROM employees a
         ,departments b
WHERE a.department_id = b.department_id
AND a.department_id NOT IN (SELECT department_id
                                         FROM departments
                                         WHERE manager_id IS NULL);

SELECT count(*)
FROM employees a
WHERE NOT EXISTS( SELECT 1
                             FROM departments c
                             WHERE a.department_id = c.department_id
                             AND manager_id IS NULL);
-- 셀프조인
-- 테이블을 자기자신과 연결

-- 같은 부서 번호를 가진 사원 중 A사원번호가 B사원번호보다 작은 건 조회
SELECT a.employee_id
           ,a.emp_name
           ,b.employee_id
           ,b.emp_name
           ,a.department_id
FROM employees a
         ,employees b
WHERE a.employee_id < b.employee_id
AND a.department_id = b.department_id
AND a.department_id = 20;

-- 외부조인
-- 어느 한쪽 테이블에 조인 조건에 명시된 컬럼에 값이 없거나 해당 로우가 아예 없더라도 데이터를 모두 추출
-- 어느 테이블을 기준으로 하냐에 따라 데이터값이 다름

-- 일반조인
SELECT a.department_id
           , a.department_name
           , b.job_id
           , b.department_id
FROM departments a
          ,job_history b
WHERE a.department_id = b.department_id;
-- job_history에 없는 부서는 볼 수 없다

-- 외부조인
SELECT a.department_id
           , a.department_name
           , b.job_id
           , b.department_id
FROM departments a
         , job_history b
WHERE a.department_id = b.department_id(+);
-- job_history에 없는 부서도 모두 조회되었다
-- 조인 조건에서 데이터가 없는 테이블의 컬럼에 +를 붙힌다


SELECT a.employee_id
           , a.emp_name
           , b.job_id
           , b.department_id
FROM employees a
          , job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id;
-- 외부조인은 조건에 해당하는 조인 조건 모두 (+)를 붙혀야한다
SELECT a.employee_id
           , a.emp_name
           , b.job_id
           , b.department_id
FROM employees a
          , job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id(+);

SELECT a.employee_id
           , a.emp_name
           , b.job_id
           , b.department_id
FROM employees a
          ,job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id(+);
-- (+)연산자가 붙은 조건과 OR을 같이 사용할 수 없다
-- (+)연산자가 붙은 조건에는 IN연산자를 같이 사용할 수 없다

-- 카타시안 조인
-- WHERE절에 조인 조건이 없는 조인
-- FROM절에 테이블을 명시했으나, 두 테이블 간 조인 조건이 없는 조인
-- 결과는 두 테이블 건수의 곱
SELECT a.employee_id
           ,a.emp_name
           ,b.department_id
           ,b.department_name
FROM employees a
         ,departments b;

-- ANSI 조인
-- ANSI SQL 문법을 사용
-- ANSI 내부조인
SELECT a.employee_id
           ,a.emp_name
           ,b.department_id
           ,b.department_name
FROM employees a
INNER JOIN departments b
ON (a.department_id = b.department_id)
WHERE a.hire_date >=TO_DATE('2003-01-01','YYYY-MM-DD');
-- ON 다음에 기본키나 외래키가 들어와야한다

-- ANSI 외부조인
-- LEFT OUTER JOIN
SELECT a.employee_id
           ,a.emp_name
           ,b.job_id
           ,b.department_id
FROM employees a
RIGHT OUTER JOIN job_history b
ON (a.employee_id = b.employee_id
      and a.department_id = b.department_id);
-- RIGHT OUTER JOIN
SELECT a.employee_id
           ,a.emp_name
           ,b.job_id
           ,b.department_id
FROM job_history b
RIGHT OUTER JOIN employees a  
ON (a.employee_id = b.employee_id
      and a.department_id = b.department_id);

-- 서브쿼리
-- SELECT, FROM, WHERE
-- 연관성 없는 서브커리
SELECT COUNT(*)
FROM employees
WHERe salary >=(SELECT AVG(salary)
                        FROM employees);
                        -- 단일 행

SELECT COUNT(*)
FROM employees
WHERE department_id IN (SELECT department_id
                                   FROM departments
                                   WHERE parent_id IS NULL);
                                   -- 복수 행
                              -- in(복수행)
SELECT employee_id, emp_name, job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT employee_id,job_id
                                           FROM job_history);
-- UPDATE,DELETE문 사용 가능

-- 연관성있는 서브커리
SELECT 
    a.employee_id
    ,(SELECT b.emp_name
        FROM employees b
        WHERE a.employee_id = b.employee_id) AS emp_name
    ,a.department_id
    ,(SELECT b.department_name
        FROM departments b
        WHERE a.department_id = b.department_id) AS dep_name
FROM job_history a;

-- 메인쿼리 
-- 서브쿼리 특정 조건
-- 분할하고 다시합치기
SELECT
FROM
WHERE(서브쿼리1
                (서브쿼리2));
                
SELECT 
    a.department_id
    , a.department_name
FROM departments a
WHERE EXISTS (SELECT 1  -- EXISTS를 쓰기위해 1을 사용
                        FROM employees b
                        WHERE a.department_id = b.department_id
                        AND b.salary > (SELECT AVG(salary)
                                                FROM employees));

-- 메인쿼리: 사원테이블의 사원들의 부서별 평균 급여를 조회
-- 서브쿼리 : 상위부서가 기획부에 속함
SELECT department_id, AVG(salary)
FROM employees
WHERE department_id IN (SELECT department_id
                                    FROM departments
                                    WHERE parent_id = 90)
GROUP BY department_id;



