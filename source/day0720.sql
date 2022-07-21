-- SELECT 문
-- p.92 
-- 급여가 5000이 넘는 사원번호와 사원명 조회 
SELECT * FROM employees;  -- 107개 데이터

SELECT 
    employee_id
    , emp_name
    , salary
FROM employees
WHERE salary < 3000
ORDER BY employee_id;

-- 급여가 5000 이상, job_id, IT_PROG 사원 조회
SELECT employee_id
             , emp_name
             , job_id
             , salary
FROM employees
WHERE salary > 5000 
            OR job_id = 'IT_PROG'
ORDER BY employee_id;

-- 테이블에 별칭 줄 수 있음
SELECT 
    -- a 테이블에서 옴 (=employees)
    a.employee_id, a.emp_name, a.department_id,
    -- b 테이블에서 옴 (=departments)
    b.department_name
FROM 
    employees a,
    departments b 
WHERE a.department_id = b.department_id;

-- INSERT문 & UPDATE문
-- 4교시에 실습

-- p101 
-- Merge, 데이터를 합치다 또는 추가하다
-- 조건을 비교해서 테이블에 해당 조건에 맞는 데이터 없으면 추가
-- 있으면 UPDATE문을 수행하다. 

DROP TABLE ex3_3;
CREATE TABLE ex3_3(
    employee_id   NUMBER
    , bonus_amt   NUMBER DEFAULT 0 
);

INSERT INTO ex3_3 (employee_id)
SELECT 
    e.employee_id
FROM employees e, sales s
WHERE e.employee_id = s.employee_id
    AND s.SALES_MONTH BETWEEN '200010' AND '200012'
GROUP BY e.employee_id;

SELECT * FROM ex3_3 ORDER BY employee_id;

-- 103p
-- 서브쿼리
SELECT 
    employee_id
    , manager_id
    , salary
    , salary * 0.01 
FROM employees
WHERE employee_id IN (SELECT employee_id FROM ex3_3);

SELECT 
    employee_id
    , manager_id
    , salary
    , salary * 0.001 
FROM employees
WHERE employee_id NOT IN (SELECT employee_id FROM ex3_3) 
    AND manager_id = 146;

-- MERGE를 통해서 작성
-- 관리자 사번 146인 것 중, ex3_3 테이블에 없는 
-- 사원의 사번, 관리자 사번, 급여, 급여 * 0.001 조회
-- ex3_3 테이블의 160번 사원의 보너스 금액은 7.5로 신규 입력 

SELECT * FROM ex3_3;

SELECT employee_id, salary, manager_id
                  FROM employees 
                  WHERE manager_id = 146;

-- 서브쿼리 개념 : 메인 쿼리 안에 추가된 쿼리
-- UPDATE & INSERT 구문
-- 두개의 테이블 조인

MERGE INTO ex3_3 d 
    USING (SELECT employee_id, salary, manager_id
                  FROM employees 
                  WHERE manager_id = 146) b
    ON (d.employee_id = b.employee_id)
WHEN MATCHED THEN 
    UPDATE SET d.bonus_amt = d.bonus_amt + b.salary * 0.01 
    -- DELETE WHERE (B.employee_id = 161)
WHEN NOT MATCHED THEN
    INSERT (d.employee_id, d.bonus_amt) VALUES (b.employee_id, b.salary * .001)
    WHERE (b.salary < 8000);
    
SELECT * FROM ex3_3 ORDER BY employee_id;

-- p.106 
-- 테이블 삭제
DELETE ex3_3;
SELECT * FROM ex3_3 ORDER BY employee_id;

-- p107 
-- commit & rollback
-- Commit은 변경한 데이터를 데이터베이스에 마지막으로 반영
-- Rollback은 그 반대로 변경한 데이터를 변경하기 이전 상태로 되돌리는 역할

CREATE TABLE ex3_4(
    employee_id   NUMBER
);

INSERT INTO ex3_4 VALUES (100);
SELECT * FROM ex3_4;

commit;

-- p.109
TRUNCATE TABLE ex3_4;

-- p110 
SELECT 
    ROWNUM, employee_id
FROM employees
WHERE ROWNUM < 5;

-- ROWID, 주소 값 
-- DBA, DB모델링 (쿼리속도 측정 --> 특징)
SELECT 
    ROWNUM
    , employee_id
    , ROWID 
FROM employees
WHERE ROWNUM < 5;

-- 연산자
-- Operator 연산 수행
-- 수식 연산자 & 문자 연산자
-- `||` 두 문자를 붙이는 연결 연산자
-- 'Alias' 약어
SELECT 
    employee_id || '-' || emp_name AS employee_info
FROM employees
WHERE ROWNUM < 5;

-- 표현식
-- 조건문, if 조건문 (PL/SQL)
-- CASE 표현식
SELECT 
    employee_id 
    , salary
    , CASE WHEN salary <= 5000 THEN 'C등급' 
               WHEN salary > 5000 AND salary <= 15000 THEN 'B등급' 
               ELSE 'A등급'
    END AS salary_grade
FROM employees;

-- 조건식
-- TRUE, FALSE, UNKNOWN 세가지 타입으로 반환
-- 비교 조건식
-- 분석가, DB 데이터를 추출할 시, 서브쿼리

SELECT 
    employee_id
    , salary
FROM employees
WHERE salary = ANY(2000, 3000, 4000)
ORDER BY employee_id;

-- ANY --> OR 연산자 변환
SELECT 
    employee_id
    , salary
FROM employees
WHERE salary = 2000 OR salary = 3000 OR salary = 4000
ORDER BY employee_id;

SELECT 
    employee_id
    , salary
FROM employees
WHERE salary = ALL(2000, 3000, 4000) -- <- AND 
ORDER BY employee_id;

-- SOME 
SELECT 
    employee_id
    , salary
FROM employees
WHERE salary = SOME(2000, 3000, 4000)
ORDER BY employee_id;

-- NOT 조건식
SELECT 
    employee_id
    , salary
FROM employees
WHERE NOT(salary >= 2500)
ORDER BY employee_id;

-- NULL 조건식**

-- IN 조건식
-- 조건절에 명시한 값이 포함된 건을 반환하는데 앞에서 배웠던 ANY
SELECT 
    employee_id
    , salary
FROM employees
WHERE salary IN (2000, 3000, 4000)
ORDER BY employee_id;

-- NOT IN 
SELECT 
    employee_id
    , salary
FROM employees
WHERE salary NOT IN (2000, 3000, 4000)
ORDER BY employee_id;

-- EXISTS 조건식
-- "서브쿼리"만 올 수 있음. 
-- 네카라쿠배토당야.. 
개발자들, 코딩 테스트 (알고리즘) / 기술면접 / 임원면접
분석가들, SQL / 분석과제, 조이시티 게임사 (초봉 4000만원)
-- SQL 테스트 / 분석과제 / 수습3개월 분석과제 / 입사 6개월 그만둠
-- 
-- 영어교육학사

-- Like 조건식
-- 문자열으 패턴을 검색해서 사용하는 조건식
SELECT 
    emp_name 
FROM employees
WHERE emp_name LIKE 'Al%'
ORDER BY emp_name;

-- 4장 숫자 함수
-- p.126
SELECT ABS(10), ABS(-10), ABS(-10.123)
FROM DUAL;

-- 정수 반환
-- 올림
SELECT CEIL(10.123), CEIL(10.541), CEIL(11.001)
FROM DUAL;

-- 내림
SELECT FLOOR(10.123), FLOOR(10.541), FLOOR(11.001)
FROM DUAL;

SELECT ROUND(10.123), ROUND(10.541), ROUND(11.001)
FROM DUAL;

SELECT ROUND(10.123, 2), ROUND(10.541, 2), ROUND(11.001, 2)
FROM DUAL;

-- TRUNC
-- 반올림 안함. 소수점 절삭, 자리수 지정 가능
SELECT TRUNC(115.155), TRUNC(115.155, 1), TRUNC(115.155, 2), TRUNC(115.155, -2)
FROM DUAL;

-- POWER 
-- POWER 함수, SQRT 
SELECT POWER(3, 2), POWER(3, 3), POWER(3, 3.001)
FROM DUAL;

-- 제곱근 반환
SELECT SQRT(2) , SQRT(5), SQRT(9)
FROM DUAL;

-- 과거 : SQL, DB에서 자료를 조회 하는 용
-- 현재 : SQL --> 수학 & 통계 도구처럼 진화
-- 오라클 19c 부터 머신러닝 지원, 

-- 문자열 데이터 전처리
-- 게임사, 
-- 채팅 --> 문자 데이터 
-- 텍스트 마이닝 (빈도, 워드클라우드)
-- 100GB / RAM 32GB, 64GBㅇ

SELECT INITCAP('never say goodbye'), INITCAP('never6say*good가bye')
FROM DUAL;

-- LOWER함수
-- 매개변수로 들어오는 문자를 모두 소문자로, UPPDER 함수는 대문자로 반환
SELECT LOWER('NEVER SAY GOODBYE'), UPPER('never say goodbye')
FROM DUAL;

-- CONCAT(char1, char2), '||' 연산자와 비슷
SELECT CONCAT('I Have', ' A Dream'), 'I Have' || ' A Dream'
FROM DUAL;

-- SUBSTR 
-- 문자열 자르기
SELECT SUBSTR('ABDCEFG', 1, 4), SUBSTR('ABDCEFG', -1, 4)
FROM DUAL;

-- 글자 1개당 3Byte씩 인식 (교재는 2Byte씩 인식)
SELECT SUBSTRB('ABDCEFG', 1, 6), SUBSTRB('가나다라마바사', 1, 6)
FROM DUAL;

-- LTRIM, RTRIM 함수
SELECT 
    LTRIM('ABCDEFGABC', 'ABC')
    , RTRIM('ABCDEFGABC', 'ABC')
FROM DUAL;

-- LPAD, RPAD

-- 날짜 함수(p.138)
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

-- ADD_MONTHS 
-- ADD_MONTHS 함수, 매개변수로 들어온 날짜, integer 만큼 월을 더함 
SELECT ADD_MONTHS(SYSDATE, -1) FROM DUAL;

SELECT MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE,1)) mon1
FROM DUAL;

-- LAST_DATE
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- NEXT_DAY
SELECT NEXT_DAY(SYSDATE, '금요일')
FROM DUAL;

-- p.141 형변환
-- TO_CHAR(숫자 혹은 날짜, format)
SELECT TO_CHAR(123456789, '999,999,999')
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'D') FROM DUAL;

-- 문자를 숫자로 변환
SELECT TO_NUMBER('123456')
FROM DUAL;

-- NULL 관련 함수
SELECT manager_id, employee_id FROM employees;

-- NVL : 표현식1이 NULL일 때, 표현식 2를 반환함
SELECT NVL(manager_id, employee_id)
FROM employees
WHERE manager_id IS NULL;

-- NVL2 : 표현식1이 NULL이 아니면, 표현식2 출력, 
--             표현식2가 NULL이면, 표현식3을 출력
SELECT employee_id, commission_pct, salary FROM employees;

SELECT employee_id
                , salary
                , commission_pct
                , NVL2(commission_pct, salary + (salary * commission_pct), salary) AS salary2
FROM employees
WHERE employee_id IN (118, 179);

-- COALESCE(expr1, expr2) 
-- 매개변수로 들어오는 표현식에서 NULL이 아닌 첫 번째 표현식 반환
SELECT 
    employee_id
    , salary
    , commission_pct
    , COALESCE(salary * commission_pct, salary) as salary2
FROM employees;

-- DECODE
-- IF-ELIF-ELIF-ELIF-ELSE 

SELECT * FROM sales;

SELECT prod_id
                , DECODE(channel_id, 3, 'Direct', 
                                                      9, 'Direct',
                                                      5, 'Indirect',
                                                      4, 'Indirect',
                                                          'Others') decodes
FROM sales 
WHERE rownum < 10;

