-- �⺻ ���� �Լ�
-- count

SELECT COUNT(*)
FROM employees;

SELECT COUNT(employee_id)
FROM employees;

SELECT COUNT(department_id)
FROM employees;

-- DISTINCT 
-- ��������
SELECT COUNT(DISTINCT department_id)
FROM employees;

SELECT DISTINCT department_id
FROM employees
ORDER BY 1;

-- ������跮
-- SQL 
--> ��赵�� & �ӽŷ���, �����Ͱ��� ������ ���

-- SUM
-- �հ�
SELECT SUM(salary)
FROM employees;

SELECT SUM(salary), SUM(DISTINCT salary)
FROM employees;

-- AVG
-- ���
SELECT AVG(salary), AVG(DISTINCT salary)
FROM employees;

-- MIN,MAX
-- �ּ�, �ִ�
SELECT MIN(salary), MAX(salary)
FROM employees;
-- DISTINCT�� ��밡��������
-- �ּҰ��� �ִ��� �Ȱ��� ���
SELECT MIN(DISTINCT salary), MAX(DISTINCT salary)
FROM employees;

-- VARIANCE, STDDEV
-- �л�        , ǥ������
SELECT VARIANCE(salary), STDDEV(salary)
FROM employees;


-- GROUP BY���� HAVING��
-- GROUP BY : Ư���׷����� ���� �����͸� �����Ҷ� ���
--> WHERE�� ORDER BY�� ���̿� ��ġ

SELECT department_id,  SUM(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;

SELECT * FROM kor_loan_status;

-- 2013�� ������ ������� �� �ܾ�
SELECT period
           ,region
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, region
ORDER BY period, region

-- 2013�� 11�� �� �ܾ�
SELECT period
           ,region
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY region
ORDER BY region;

-- HAVING��
-- GROUP BY ������ ��ġ
-- GROUP BY�� ���͸��� ����� ������� �ٽ� ���͸� �Ǵ�
SELECT period
           ,region
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period = '201311'
GROUP BY period, region
HAVING SUM(loan_jan_amt) > 100000
ORDER BY region;

-- ROLLUP�� 
-- expr�� ����� ǥ������ �������� ������ ���
-- �߰����� ���� ������ ������
-- ����� ǥ���� ���� ������ ���� �������� ������ ����� ��ȯ


-- 2013�⵵ ���� ������ �� �ܾ�
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, gubun
ORDER BY period;

-- rollup ���
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period, gubun);

-- ���� ROLLUP
-- period -> gubun ������ ����
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, ROLLUP(gubun );

-- gubun -> period ������ ����
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP (period),gubun;

-- CUBE 
-- ����� ǥ���� ������ ���� ������ ��� ���պ��� ������ ����� ��ȯ
-- 2^(expr�� ��)
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY CUBE(period, gubun);
-- expr�� ���� 2�̹Ƿ� �� 4������ �������� ���谡 �ȴ�
-- ����� ���� ��ü, ���� ������, ����, ���� ���� �������� ���谡 �Ǿ���.

-- ���� CUBE
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, CUBE(gubun);

-- ���� ������
-- UNION
-- ��Ĩ��
CREATE TABLE exp_goods_asia(
    country VARCHAR2(10),
    seq NUMBER,
    goods VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('�ѱ�',1,'�������� ������');
INSERT INTO exp_goods_asia VALUES ('�ѱ�',2,'�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�ѱ�',3,'��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�ѱ�',4,'����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�',5,'LCD');
INSERT INTO exp_goods_asia VALUES ('�ѱ�',6,'�ڵ��� ��ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�',7,'����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�',8,'ȯ��źȭ����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�',9,'�����۽ű� ���÷��� �μ�ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�',10,'ö �Ǵ� ���ձݰ�');

INSERT INTO exp_goods_asia VALUES ('�Ϻ�',1,'�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�',2,'�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�',3,'��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�',4,'����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�',5,'�ݵ�ü������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�',6,'ȭ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�',7,'�������� ������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�',8,'�Ǽ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�',9,'���̿���, Ʈ��������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�',10,'����');
commit;

SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�'
ORDER BY seq;

-- �� ������ ��ġ�� ����ǰ���� �ѹ��� ��ȸ�ǵ��� �Ҷ� ���
SELECT goods
FROM exp_goods_asia
WHERE country='�ѱ�'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country='�Ϻ�';

-- UNION ALL
-- �ߺ��� �׸� ��� ��ȸ
SELECT goods
FROM exp_goods_asia
WHERE country='�ѱ�'
UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country='�Ϻ�';

-- MINUS
-- ������

SELECT goods
FROM exp_goods_asia
WHERE country='�ѱ�'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country='�Ϻ�';

-- ���տ������� ���ѻ���
-- ���տ����ڷ� ����Ǵ� �� SELECT���� ����Ʈ������ ������Ÿ���� ��ġ�ؾ��Ѵ�
SELECT goods
FROM exp_goods_asia
WHERE country='�ѱ�'
UNION
SELECT seq,goods
FROm exp_goods_asia
WHERE country = '�Ϻ�';
-- ����Ʈ�� ������ �����ʾ� �����߻�

SELECT seq,goods
FROM exp_goods_asia
WHERE country='�ѱ�'
UNION
SELECT seq,goods
FROm exp_goods_asia
WHERE country = '�Ϻ�';
-- seq�� goods��� �ߺ�

-- ���տ����ڷ� SELECT���� �����Ҷ� ORDER BY�� �� ������ ���忡���� ��� ����
SELECT goods
FROM exp_goods_asia
WHERE country='�ѱ�'
ORDER BY goods
UNION
SELECT goods
FROM exp_goods_asia
WHERE country='�Ϻ�';
-- ORDER BY�� �߰��� ���� ����

SELECT goods
FROM exp_goods_asia
WHERE country='�ѱ�'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country='�Ϻ�';
ORDER BY goods;

-- BLOB, CLOB, BFILE Ÿ���� �÷��� ���ؼ��� ���� ������ ��� �Ұ���
-- UNION, INTERSECT, MINUS �����ڴ� LONG�� �÷��� ��� �Ұ���

-- GROUPING SET
-- ROLLUP�̳� CUBEó�� GROUP BY�� ����ؼ�  �׷������� ���
-- UNION ALL���� ����
SELECT period
           ,gubun
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY GROUPING SETS(period, gubun);
-- GROUPING SETS�� period�� gubun�� ����ؼ� �����հ�, ���� ������ �հ踸 ����

SELECT period
           ,gubun
           ,region
           ,SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
AND region IN ('����','���')
GROUP BY GROUPING SETS (period, (gubun,region));
-- period�� (gubun,region)���� ����Ǿ���

-- ����
-- ���� ����(=)
-- WHERE���� ����� ����
-- �� �÷� ���� ���� ���� ����
SELECT a.employee_id
           ,a.emp_name
           ,a.department_id
           ,b.department_name
FROM employees a
          ,departments b
WHERE a.department_id = b.department_id;

-- ��������
-- ���������� �̿��� ���������� �����ϴ� �����͸� ���� �������� ����

-- EXISTS ���
SELECT department_id
           ,department_name
FROM departments a
WHERE EXISTS( SELECT *
                      FROM employees b
                      WHERE a.department_id = b.department_id
                      AND b.salary > 3000)
ORDER BY a.department_name;

-- IN ���
-- �������� �� �����̺��� ����X
SELECT department_id
           , department_name
FROM departments a
WHERE a.department_id IN (SELECT b.department_id
                                     FROM employees b
                                     WHERE b.salary > 3000)
ORDER BY department_name;            

-- ��Ƽ����
-- ���������� �ݴ� ����
-- NOT IN, NOT EXISTS ���
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
-- ��������
-- ���̺��� �ڱ��ڽŰ� ����

-- ���� �μ� ��ȣ�� ���� ��� �� A�����ȣ�� B�����ȣ���� ���� �� ��ȸ
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

-- �ܺ�����
-- ��� ���� ���̺� ���� ���ǿ� ��õ� �÷��� ���� ���ų� �ش� �ο찡 �ƿ� ������ �����͸� ��� ����
-- ��� ���̺��� �������� �ϳĿ� ���� �����Ͱ��� �ٸ�

-- �Ϲ�����
SELECT a.department_id
           , a.department_name
           , b.job_id
           , b.department_id
FROM departments a
          ,job_history b
WHERE a.department_id = b.department_id;
-- job_history�� ���� �μ��� �� �� ����

-- �ܺ�����
SELECT a.department_id
           , a.department_name
           , b.job_id
           , b.department_id
FROM departments a
         , job_history b
WHERE a.department_id = b.department_id(+);
-- job_history�� ���� �μ��� ��� ��ȸ�Ǿ���
-- ���� ���ǿ��� �����Ͱ� ���� ���̺��� �÷��� +�� ������


SELECT a.employee_id
           , a.emp_name
           , b.job_id
           , b.department_id
FROM employees a
          , job_history b
WHERE a.employee_id = b.employee_id(+)
AND a.department_id = b.department_id;
-- �ܺ������� ���ǿ� �ش��ϴ� ���� ���� ��� (+)�� �������Ѵ�
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
-- (+)�����ڰ� ���� ���ǰ� OR�� ���� ����� �� ����
-- (+)�����ڰ� ���� ���ǿ��� IN�����ڸ� ���� ����� �� ����

-- īŸ�þ� ����
-- WHERE���� ���� ������ ���� ����
-- FROM���� ���̺��� ���������, �� ���̺� �� ���� ������ ���� ����
-- ����� �� ���̺� �Ǽ��� ��
SELECT a.employee_id
           ,a.emp_name
           ,b.department_id
           ,b.department_name
FROM employees a
         ,departments b;

-- ANSI ����
-- ANSI SQL ������ ���
-- ANSI ��������
SELECT a.employee_id
           ,a.emp_name
           ,b.department_id
           ,b.department_name
FROM employees a
INNER JOIN departments b
ON (a.department_id = b.department_id)
WHERE a.hire_date >=TO_DATE('2003-01-01','YYYY-MM-DD');
-- ON ������ �⺻Ű�� �ܷ�Ű�� ���;��Ѵ�

-- ANSI �ܺ�����
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

-- ��������
-- SELECT, FROM, WHERE
-- ������ ���� ����Ŀ��
SELECT COUNT(*)
FROM employees
WHERe salary >=(SELECT AVG(salary)
                        FROM employees);
                        -- ���� ��

SELECT COUNT(*)
FROM employees
WHERE department_id IN (SELECT department_id
                                   FROM departments
                                   WHERE parent_id IS NULL);
                                   -- ���� ��
                              -- in(������)
SELECT employee_id, emp_name, job_id
FROM employees
WHERE (employee_id, job_id) IN (SELECT employee_id,job_id
                                           FROM job_history);
-- UPDATE,DELETE�� ��� ����

-- �������ִ� ����Ŀ��
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

-- �������� 
-- �������� Ư�� ����
-- �����ϰ� �ٽ���ġ��
SELECT
FROM
WHERE(��������1
                (��������2));
                
SELECT 
    a.department_id
    , a.department_name
FROM departments a
WHERE EXISTS (SELECT 1  -- EXISTS�� �������� 1�� ���
                        FROM employees b
                        WHERE a.department_id = b.department_id
                        AND b.salary > (SELECT AVG(salary)
                                                FROM employees));

-- ��������: ������̺��� ������� �μ��� ��� �޿��� ��ȸ
-- �������� : �����μ��� ��ȹ�ο� ����
SELECT department_id, AVG(salary)
FROM employees
WHERE department_id IN (SELECT department_id
                                    FROM departments
                                    WHERE parent_id = 90)
GROUP BY department_id;



