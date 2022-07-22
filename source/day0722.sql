-- ��������
-- �ζ��� ��
-- FROM���� ����ϴ� ��������
-- �������ΰ� ����ϴ�

-- �������� : ������̺��� ID NAME ���
--               �μ����̺��� ID NAME ���
--               ������̺��� �޿��� ��ȹ�μ��� ��ձ޿����� ���� ���
--               a.salary > d.avg_salary
-- ��������:  ��ȹ�μ��� ��� �޿�
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


-- 2000�� ��Ż���� ��ո���� ���� ū ���� ��� ����� ���ϱ�
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

-- ������ ������ �ۼ��ؾ� �� �� 
-- ������ �� �Ŀ� ������������ �Ѵ�

-- ������ ����
-- START WITH ���� & CONNECT BY ����
-- CONNECT BY PRIOR 

SELECT
    department_id
    , LPAD( ' ',3*(LEVEL -1)) || department_name, LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;

-- ������̺� �ִ� manager_id, employee_id
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

-- ������ ���� ��ȭ�н�
-- ������ ���� ����
-- ORDER SIBLINGS BY 
SELECT 
    department_id
    , LPAD(' ', 3*(LEVEL -1)) || department_name
    ,LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name;

-- ������
-- CONNECT BY ROOT
-- �ֻ��� �ο츦 ��ȯ�ϴ� ������
SELECT 
    department_id
    , LPAD(' ', 3*(LEVEL-1))|| department_name
    , LEVEL
    , CONNECT_BY_ROOT department_name AS root_name
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;


-- CONNECT_BY_ISCYCLE
-- ���ѷ����� ���� �� ������ ������ ã���� NOCYCLE�� �Բ� ���

-- ������ ���� ����
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




-- WITH ��
-- ���������� ������ ���
-- ������, ����, ����
WITH b2 AS (
    SELECT 
        period
        , region
        , sum(loan_jan_amt) jan_amt
    FROM kor_loan_status
    GROUP BY period, region)

SELECT b2.* FROM b2;

-- ��ȯ ���� ����
-- SERACH
-- ORDER SIBLINGS BY�� ���� ���
-- DEPTH FIRST BY : �����ο캸�� �ڽķο찡 ���� ��ȸ
-- BREADTH FIRST BY : �ڽķο캸�� �����ο찡 ���� ��ȸ
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

-- WINDOW �Լ�
-- ���� ���������ʰ� ����
-- Ranking, �������, �̵���հ�� �� �ַ� ���
-- �м��Լ�(�Ű�����) OVER (PARTITION BY ...)

-- �м��Լ�
-- ROW_NUMBER() 
-- ROWNUM�� ���
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

-- DENSE_RANK�� ���� ������ ������ �ǳʶ����ʰ� �Ű�����
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

-- CUME_DIST() : ������� ���������� ���� ��ȯ
SELECT
    department_id
    , emp_name
    ,salary
    , CUME_DIST() OVER(PARTITION BY department_id
                                ORDER BY salary) dep_dist
FROM employees;

-- PERCENT_RANK() : �ش� �׷� ���� ����� ������ ��ȯ
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

--NTILE(����) : ��Ƽ�Ǻ��� ��õ� ����ŭ ������ ����� ��ȯ
SELECT  
    department_id
    , emp_name
    , salary
    , NTILE(4) OVER (PARTITION BY department_id
                            ORDER BY salary) NTILES
FROm employees
WHERE department_id IN (30,60);

-- LAG :  ����ο��� ���� ��ȯ�Ѵ�.
-- LEAD : ����ο��� ���� ��ȯ�Ѵ�
SELECT 
    emp_name
    , hire_date
    , salary
    , LAG(salary, 1, 0) OVER (ORDER BY hire_date) AS prev_sal
    , LEAD(salary,1,0) OVER (ORDER BY hire_date) AS next_sal
FROM employees
WHERE department_id = 30;

-- WINDOW ��

-- ������ �Ի����� ������ ó��
-- �޿�, UNBOUNDED PRECENDING �μ��� �Ի����ڰ� ���� ���� ���
--        UNBOUNDED FOLLOWING �μ��� �Ի����ڰ� ���� ���� ���
-- �����հ�
SELECT 
    department_id
    , emp_name
    , hire_date
    , salary
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS all_salary
                                -- ���հ�
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS first_current_sal
                               -- �����հ�
    , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                               ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS current_end_sal
                               -- �����հ� ����
FROM employees
WHERE department_id IN (30,90);
                                
--WINDOW �Լ�


