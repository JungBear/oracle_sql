-- 서브쿼리
-- 인라인 뷰
-- FROM절에 사용하는 서브쿼리
-- 세미조인과 비슷하다

-- 메인쿼리 : 사원테이블에서 ID NAME 출력
--               부서테이블에서 ID NAME 출력
--               사원테이블의 급여가 기획부서의 평균급여보다 높은 사람
--               a.salary > d.avg_salary
-- 서브쿼리:  기획부서의 평균 급여
SELECT a.employee_id
    , a.emp_name
    , b.department_id
    , b.department_name
FROM employees a
    ,departments b
    , (SELECT AVG (c.salary) AS avg_salary
      FROM departments b
                ,employees c
      WHERE b.parent_id=90
      AND b.department_id = c.department_id ) d
WHERE a.department_id = b.department_id
AND a.salary > d.avg_salary;


-- 2000년 이탈리아 평균매출액 보다 큰 월의 평균 매출액 구하기
SELECT a.*
FROM (SELECT a.sales_month
        , ROUND(AVG(a.amount_sold)) AS month_avg
    FROM sales a
        , customers b
        , countries c
    WHERE a.sales_month BETWEEN '200001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID
    AND c.COUNTRY_NAME = 'Italy'
    GROUP BY a.sales_month
    )
    a
    , (SELECT ROUND(AVG(a.amount_sold)) AS year_avg
    FROM sales a
        , customers b
        , countries c
    WHERE a.sales_month BETWEEN '200001' AND '200012'
    AND a.cust_id = b.CUST_ID
    AND b.COUNTRY_ID = c.COUNTRY_ID
    AND c.COUNTRY_NAME = 'Italy')
    b
WHERE a.month_avg > b.year_avg;

-- 복잡한 쿼리를 작성해야 할 때 
-- 분할을 한 후에 작은단위부터 한다

-- 계층형 쿼리
-- START WITH 조건 & CONNECT BY 조건
-- CONNECT BY PRIOR 

SELECT
    department_id
    , LPAD( ' ',3*(LEVEL -1)) || department_name, LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- 사원테이블에 있는 manager_id, employee_id
SELECT                                                              -- print
    a.employee_id
    ,LPAD(' ',3*(LEVEL-1))||a.emp_name
    ,LEVEL
    ,b.department_name
FROM employees a                                               -- a = employees
    , departments b                                                -- b = departments
WHERE a.department_id = b.department_id                 -- if 
START WITH a.manager_id IS NULL                           
CONNECT BY PRIOR a.employee_id = a.manager_id;

SELECT 
    a.employee_id
    ,LPAD(' ',3*(LEVEL-1))||a.emp_name
    ,LEVEL
    ,b.department_name
    ,a.department_id
FROM employees a
    , departments b
WHERE a.department_id = b.department_id
AND a.department_id = 30
START WITH a.manager_id IS NULL
CONNECT BY NOCYCLE PRIOR a.employee_id = a.manager_id;

-- 계층형 쿼리 심화학습
-- 계층형 쿼리 정렬
-- ORDER SIBLINGS BY 
SELECT 
    department_id
    , LPAD(' ', 3*(LEVEL -1)) || department_name
    ,LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name;

-- 연산자
-- CONNECT BY ROOT
-- 최상위 로우를 반환하는 연산자
SELECT 
    department_id
    , LPAD(' ', 3*(LEVEL-1))|| department_name
    , LEVEL
    , CONNECT_BY_ROOT department_name AS root_name
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;


-- CONNECT_BY_ISCYCLE
-- 무한루프에 들어갔을 때 오류의 원인을 찾을때 NOCYCLE과 함께 사용

-- 계층형 쿼리 응용
CREATE TABLE ex7_1 AS
SELECT ROWNUM seq
    ,'2014' ||  LPAD(CEIL(ROWNUM/1000),2,'0') month
    , ROUND(DBMS_RANDOM.VALUE(100,1000)) amt
FROM DUAL
CONNECT BY LEVEL <= 12000;

SELECT * FROM ex7_1;

SELECT month, SUM(AMT)
FROM ex7_1
GROUP BY month
ORDER BY month;




-- WITH 절
-- 서브쿼리의 가독성 향상
-- 연도별, 최종, 월별
WITH b2 AS (
    SELECT 
        period
        , region
        , sum(loan_jan_amt) jan_amt
    FROM kor_loan_status
    GROUP BY period, region)

SELECT b2.* FROM b2;

-- 순환 서브 쿼리
-- SERACH
-- ORDER SIBLINGS BY와 같은 기능
-- DEPTH FIRST BY : 형제로우보다 자식로우가 먼저 조회
-- BREADTH FIRST BY : 자식로우보다 형제로우가 먼저 조회
WITH  
    recur( 
        department_id
        , parent_id
        , department_name
        , lvl)
    AS(
        SELECT 
            department_id
            ,parent_id
            ,department_name
            , 1 AS lvl
        FROM departments
        WHERE parent_id IS NULL
        UNION ALL
        SELECT 
            a.department_id
            , a.parent_id
            , a.department_name
            , b.lvl+1
        FROM departments a, recur b
        WHERE a.parent_id = b.department_id)
SEARCH DEPTH FIRST BY department_id SET order_seq
SELECT 
    department_id
    , LPAD(' ',3*(lvl-1))||department_name
    , lvl
    , order_seq
FROM recur;

-- WINDOW 함수
-- 행이 삭제되지않고 유지
-- Ranking, 누적계산, 이동평균계산 시 주로 사용
-- 분석함수(매개변수) OVER (PARTITION BY ...)

-- 분석함수
-- ROW_NUMBER() 
-- ROWNUM과 비슷
SELECT
    department_id
    , emp_name
    , ROW_NUMBER() OVER(PARTITION BY department_id
                                    ORDER BY department_id, emp_name)dep_rows
FROM employees;

-- RANK(), DENSE_RANK()
SELECT 
    department_id
    , emp_name
    , salary
    , RANK() OVER( PARTITION BY department_id
                         ORDER BY salary) dep_rank
FROM employees;                         

-- DENSE_RANK는 같은 순위가 나오면 건너뛰지않고 매겨진다
SELECT 
    department_id
    , emp_name
    , salary
    , DENSE_RANK() OVER( PARTITION BY department_id
                         ORDER BY salary) dep_rank
FROM employees;    

WITH  pre AS (
    SELECT 
        department_id
        , emp_name
        , salary
        , DENSE_RANK() OVER(PARTITION BY department_id
                                      ORDER BY salary) dep_rank
    FROM employees)
SELECT pre.* FROM pre
WHERE dep_rank <= 3;

-- CUME_DIST() : 상대적인 누적분포도 값을 반환
SELECT
    department_id
    , emp_name
    ,salary
    , CUME_DIST() OVER(PARTITION BY department_id
                                ORDER BY salary) dep_dist
FROM employees;

-- PERCENT_RANK() : 해당 그룹 내의 백분위 순위를 반환
SELECT 
    department_id
    , emp_name
    , salary
    , rank()OVER(PARTITION BY department_id
                        ORDER BY salary) raking
    ,CUME_DIST()OVER(PARTITION BY department_id
                                ORDER BY salary)cume_dist_value
    ,PERCENT_RANK() OVER( PARTITION BY department_id
                                        ORDER BY salary) percentile
FROM employees
WHERE department_id = 60;

--NTILE(숫자) : 파티션별로 명시된 값만큼 분할한 결과를 반환
SELECT  
    department_id
    , emp_name
    , salary
    , NTILE(4) OVER (PARTITION BY department_id
                            ORDER BY salary) NTILES
FROm employees
WHERE department_id IN (30,60);

-- LAG :  선행로우의 값을 반환한다.
-- LEAD : 후행로우의 값을 반환한다
SELECT 
    emp_name
    , hire_date
    , salary
    , LAG(salary, 1, 0) OVER (ORDER BY hire_date) AS prev_sal
    , LEAD(salary,1,0) OVER (ORDER BY hire_date) AS next_sal
FROM employees
WHERE department_id = 30;

-- WINDOW 절

-- 정렬은 입사일자 순으로 처리
-- 급여, UNBOUNDED PRECENDING 부서별 입사일자가 가장 빠른 사원
--        UNBOUNDED FOLLOWING 부서별 입사일자가 가장 늦은 사원
-- 누적합계
SELECT 
    department_id
    , emp_name
    , hire_date
    , salary
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS all_salary
                                -- 총합계
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_current_sal
                               -- 누적합계
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                               ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS current_end_sal
                               -- 누적합계 역순
FROM employees
WHERE department_id IN (30,90);
                                
--WINDOW 함수


