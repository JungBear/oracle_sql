SELECT * FROM populations;
SELECT * FROM cities;
SELECT * FROM economies;
SELECT * FROM summer_medals;
SELECT * FROM subquery_countries;

-- 문제 1. 2015년 평균 기대수명보다 높은 모든 정보를 조회
SELECT *
FROM populations
WHERE life_expectancy >(SELECT AVG(life_expectancy)
                                            FROM populations
                                            WHERE year = '2015')
ORDER BY year desc, country_code;

-- 문제 2. subquery_countries 테이블에 있는 capital과
--           매칭되는 cities 테이블의 정보를 조회하세여
--           조회할 컬럼명은 name, country_code, urbanarea_pop
SELECT 
    a.name
    , a.country_code
    , a.urbanarea_pop
FROM cities a
    , subquery_countries b
WHERE a.name = b.capital
ORDER BY urbanarea_pop desc;

-- 문제 3
-- 조건 1. economies 테이블에서 country code, inflation rate, unemployment rate를 조회
-- 조건 2. inflation rate 오름차순 정렬
-- 조건 3. subquery_countries 테이블 내 gov_form 컬럼에서 Consitutional Monarchy 또는 'Republic'이 들어간 국가는 제외

SELECT 
   a.code
    , a.inflation_rate
    , a.unemployment_rate
FROM economies a
WHERE  EXISTS ( SELECT 1
                            FROM subquery_countries b
                            WHERE (b.gov_form LIKE 'Constitutional%')
                            OR (b.gov_form LIKE 'Republic%'))
ORDER BY inflation_rate ;
SELECT 1 
                            FROM subquery_countries b
                            WHERE b.gov_form LIKE 'Constitutional%'
                            OR (b.gov_form LIKE 'Republic%') ;

SELECT 
    emp_name 
FROM employees
WHERE emp_name LIKE 'Al%'
ORDER BY emp_name;