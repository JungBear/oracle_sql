SELECT * FROM populations;
SELECT * FROM cities;
SELECT * FROM economies;
SELECT * FROM summer_medals;
SELECT * FROM subquery_countries;

-- ���� 1. 2015�� ��� �������� ���� ��� ������ ��ȸ
SELECT *
FROM populations
WHERE life_expectancy >(SELECT AVG(life_expectancy)
                                            FROM populations
                                            WHERE year = '2015')
ORDER BY year desc, country_code;

-- ���� 2. subquery_countries ���̺� �ִ� capital��
--           ��Ī�Ǵ� cities ���̺��� ������ ��ȸ�ϼ���
--           ��ȸ�� �÷����� name, country_code, urbanarea_pop
SELECT 
    a.name
    , a.country_code
    , a.urbanarea_pop
FROM cities a
    , subquery_countries b
WHERE a.name = b.capital
ORDER BY urbanarea_pop desc;

-- ���� 3
-- ���� 1. economies ���̺��� country code, inflation rate, unemployment rate�� ��ȸ
-- ���� 2. inflation rate �������� ����
-- ���� 3. subquery_countries ���̺� �� gov_form �÷����� Consitutional Monarchy �Ǵ� 'Republic'�� �� ������ ����

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