/*
    <SUBQUERY (서브쿼리)>
    
    하나의 주된 SQL(SELCT, CREAT, INSERT, UPDATE)안에 포함된 또 하나의 SELECT문
    메인 SQL문을 위해 보조 역할을 수행한다.
*/
--노옹철 사원과 같은 부서인 사원들
--1)노옹철 사원의 부서코드를 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME='노옹철'; --D9

--2)노옹철 사원의 부서코드를 알아냈으니 해당 D9코드를 가진 사원들을 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE='D9';

--위에 2단계를 하나로 합쳐보자
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_DODE=(SELECT DEPT_CODE 
                 FROM EMPLOYEE 
                 WHERE EMP_NAME='노옹철');
                 
--전체 사원의 평균 급여보다 더 많은 급여를 받고 있는 사원들의 사번, 이름, 직급코드 조회
--1)전체 사원 평균 급여 조회
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

--2)평균 급여보다 더 많이 받는 사원 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY > 3047663;

--3)하나로 합치기 
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SALARY > (SELECT ROUND(AVG(SALARY))
                FROM EMPLOYEE);
                
/*
    서브쿼리 구분
    서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라 분류된다.
    
    -단일행(단일열) 서브쿼리: 서브쿼리를 수행한 결과값이 오로지 1개일때 (한칸으로 조회)
    -다중행(단일열) 서브쿼리: 서브쿼리를 수행한 결과값이 여러 행일때
    -(단일행)다중열 서브쿼리: 서브쿼리를 수행한 결과값이 여러 열일때
    -다중행 다중열 서브쿼리: 서브쿼리를 수행한 결과값이 여러 행 여러 열 일때
    
    -서브쿼리를 수행한 겨로가가 몇 행 몇열이냐에 따라서 사용가능한 연산자가 달라진다.
*/

/*
    1.단일행(단일열): 서브쿼리
    서브쿼리의 조회 결과값이 오로지 1개일때
    
    일반 연산자 사용가능(=,!=,>=,<=,<,>,....)
    
*/

--전 직원의 평균 급여보다 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT ROUND(AVG(SALARY))
                FROM EMPLOYEE); --결과값이 1행 1열로 나온다
            
--최저급여를 받는 사원의 사번, 사원명, 직급코드, 급여, 입사일 조회
SELECT MIN(SALARY)
FROM EMPLOYEE; --1380000

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = 1380000;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);
--노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드 급여 조회
SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME='노옹철'; --3700000

SELECT EMP_ID, EMP_NAME,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3700000;

SELECT EMP_ID, EMP_NAME,DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME='노옹철');

--노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서명, 급여 조회(JOIN활용)
SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME='노옹철'; --3700000

SELECT EMP_ID, EMP_NAME,DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME='노옹철')
AND DEPT_CODE = DEPT_ID(+);

SELECT EMP_ID, EMP_NAME,DEPT_TITLE, SALARY
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME='노옹철');
                
--부서별 급여 합이 가장 큰 부서 하나만을 조회, 부서코드, 부서명, 급여의 합(서브쿼리+GROUP BY+HAVING)
--각 부서별 급여 합 구하기 + 가장 큰 합 구하기
SELECT DEPT_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--위에 작업을 토대로 서브쿼리 작성하기
SELECT DEPT_CODE, DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
GROUP BY DEPT_CODE, DEPT_TITLE --조회하고자 하는 대상 같이 묶어주기(그룹화)
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE); --조건에 조회해올 대상 서브쿼리로 작성하기
                      
/*
    2. 다중행 서브쿼리
    서브쿼리의 조회 결과값이 여러행일 경우
    
    -IN(10,20,30) 서브쿼리: 여러개의 결과값 중에서 하나라도 일치하는 것이 있다면 /NOT IN없다면
    
    - > ANY(10,20,30) 서브쿼리: 여러개의 결과값 중에서 하나라도 클 경우
    - < ANY(10,20,30) 서브쿼리: 여러개의 결과값 중에서 하나라도 작을 경우
    
    - > ALL: 여러개의 결과값의 모든 값보다 클 경우
    - < ALL: 여러개의 결과값의 모든 값보다 작을 경우 
    
*/
                
--각 부서별 최고급여를 받는 사원의 이름, 직급코드, 급여 조회
--1)각 부서별 최고급여 조회(여러행, 단일열)
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; --289,366,800,376,390,249,255

--2)위의 급여를 받는 사원들 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (2890000,3660000,8000000,3760000,3800000,2490000,2550000);

--위의 두 쿼리문을 하나로 합치기
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                 FROM EMPLOYEE
                 GROUP BY DEPT_CODE);
                 
--선동일 또는 유재식 사원과 같은 부서인 사원들을 조회하시오(사원명, 부서코드, 급여)
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('선동일','유재식');

SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME IN('선동일','유재식'));

--이오리 또는 하동운 사원과 같은 직급인 사원들을 조회하시오(사원명, 직급코드, 부서코드, 급여)
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('이오리','하동운');

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME IN ('이오리','하동운'));

--대리 직급임에도 불구하고 과장 직급보다 급여를 많이 받는 사원들 조회(사번, 이름, 직급명, 급여)
--1) 과장 직급의 급여들을 조회
SELECT SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND JOB_NAME='과장';

--2)위의 급여들보다 하나라도 더 높은 급여를 받는 사원 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB USING(JOB_CODE)
WHERE SALARY >= ANY(2200000, 2500000, 3760000)
AND JOB_NAME = '사원';

--하나로 합치기
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB USING(JOB_CODE)
WHERE SALARY >= ANY(SELECT SALARY
                    FROM EMPLOYEE E
                    JOIN JOB J USING(JOB_CODE)
                    WHERE JOB_NAME='과장')
AND JOB_NAME='사원';

--오라클 구문으로 작성
SELECT EMP_ID, EMP_NAME,JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
WHERE SALARY >= ANY(SELECT SALARY
                FROM EMPLOYEE E, JOB J
                WHERE E.JOB_CODE = J.JOB_CODE
                AND JOB_NAME='과장')
AND JOB_NAME = '대리';

--과장직급임에도 불구하고 모든 차장직급의 급여보다 많은 급여를 받는 직원(사번, 이름, 직급명, 급여) 조회
--ANSI
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME ='차장';

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY > ALL(SELECT SALARY
                   FROM EMPLOYEE
                   JOIN JOB USING(JOB_CODE)
                   WHERE JOB_NAME ='차장')
AND JOB_NAME = '과장';


--ORACLE
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND SALARY > ALL(SELECT SALARY
                 FROM EMPLOYEE E, JOB J
                 WHERE E.JOB_CODE = J.JOB_CODE
                 AND JOB_NAME ='차장')
AND JOB_NAME = '과장';

/*
    3.(단일행) 다중열 서브쿼리
    
    서브쿼리 조회 결과가 값은 한 행이지만 나열된 컬럼의 개수가 여러개일 경우
    
*/
--하이유 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들 조회(사원명, 부서코드, 직급콛, 고용일)
--1)하이유 사원의 부서코드와 직급코드 먼저 조회 - 단일행 다중열
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하이유'; --D5/J5

--2)부서코드가 D5이고 직급코드가 J5인 사원들 조회
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
AND JOB_CODE = 'J5';

--3)하나로 합치기
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE, JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '하이유')
AND JOB_CODE = (SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_CODE
                FROM EMPLOYEE
                WHERE DEPT_CODE = 'D5'
                AND JOB_CODE = 'J5');
                
--다중열 서브쿼리를 이용해보자(비교할 값의 순서를 맞춰야한다.)
--(비교대상컬럼1, 비교대상컬럼2) = (비교할 값1, 비교할 값2): 서브쿼리 형식으로 제시해야한다.
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                               FROM EMPLOYEE
                               WHERE EMP_NAME = '하이유');

--박나라 사원과 같은 직급코드, 같은 사수 사번을 가진 사원들의 사번, 이름, 직급코드, 사수사번 조회
--다중열 서브쿼리를 이용하시오
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE(JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '박나라');
                                
/*
    4.다중행 다중열 서브쿼리
    서브쿼리 조회결과가 여러행 여러열일 경우
*/

--각 직급별 최소급여를 받는 사원들 조회(사번, 이름, 직급코드, 급여)
--1)각 직급별 최소 급여를 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

--2)위의 목록들 중에 일치하는 사원
--조건 나열 OR
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE(JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                            FROM EMPLOYEE
                            GROUP BY JOB_CODE);

--각 부서별 최고 급여를 받는 사원들 조회(사번, 이름, 부서코드, 급여)
--부서가 없을 경우 NULL - NULL처리 함수사용하여 '없음'으로 조회하기
SELECT NVL(DEPT_CODE,'없음'), MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE,'없음'), SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE,'없음'), SALARY) IN (SELECT NVL(DEPT_CODE,'없음'), MAX(SALARY)
                                         FROM EMPLOYEE
                                         GROUP BY DEPT_CODE);

-------------------------------------------------------------
/*
    5.인라인 뷰
    FROM절에 서브쿼리를 제시하는 것
    서브쿼리를 수행한 결과(RESULT SET)을 테이블 대신 사용하겠다
    
*/

--보너스 포함 연봉이 3000만원 이상인 사원들의 사번, 이름, 보너스 포함 연봉, 부서코드 조회
SELECT EMP_ID 사번, EMP_NAME 이름, ((SALARY+(SALARY*NVL(BONUS,0)))*12) "보너스 포함 연봉",DEPT_CODE 부서코
FROM EMPLOYEE 
WHERE ((SALARY+(SALARY*NVL(BONUS,0)))*12) >= 30000000;

--인라인 뷰
SELECT 사번, 이름, "보너스 포함 연봉", 부서코드
FROM (SELECT EMP_ID 사번, EMP_NAME 이름, 
      ((SALARY+(SALARY*NVL(BONUS,0)))*12) "보너스 포함 연봉",
      DEPT_CODE 부서코드
     FROM EMPLOYEE 
     WHERE ((SALARY+(SALARY*NVL(BONUS,0)))*12) >= 30000000);
--인라인뷰에서 작성한 별칭을 메인 SELECT절에서 사용할 수 있다.

--인라인뷰를 주로 사용하는 예
--TOP-N 분석: 데이터베이스 상에 있는 자료중 최상위 N개의 자료를 보기위해 사용하는 기능

--전 직원 중에 급여가 가장 높은 상위 5명을 순위, 사원명, 급여 조회해보기
--ROWNUM: 오라클에서 제공해주는 컬럼, 조회된 순서대로 1번부터 순번을 부여한다
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY; 
--ORDER BY 절이 가장 마지막에 수행되기 때문에 ROWNUM이 이미 등록된 상태로 정렬기준에 의해 정렬되어버린다

--인라인뷰를 이용하여 이미 정렬된 상태로 순번 매기기
SELECT ROWNUM, EMP_NAME, SALARY
FROM(SELECT*
     FROM EMPLOYEE
     ORDER BY SALARY)
WHERE ROWNUM <= 5;

--가장 최근에 입사한 사원 5명 조회 (사원명, 급여, 입사일)
SELECT ROWNUM, EMP_NAME, SALARY, HIRE_DATE
--SELECT ROWNUM, E.*
FROM(SELECT EMP_NAME, SALARY, HIRE_DATE
     FROM EMPLOYEE
     ORDER BY HIRE_DATE DESC) E
WHERE ROWNUM <= 5;

/*
    6.순위 매기는 함수
    RANK() OVER(정렬기준)
    DENSE_RANK() OVER(정렬기준)
    
    -RANK() OVER(정렬기준): 공동 1위가 3명이라고 한다면 그 다음 순위는 4위로 하겠다.
    -DENSE_RANK() OVER(정렬기준): 공동 1위가 3명이라해도 다음 순위는 2위로 하겠다.
    정렬기준: ORDER BY절 (정렬기준 컬럼이름, 오름차순/내림차순), NULLSFIRST/NULLSLAST는 기술불가)
    
    SELECT절에서만 사용가능하다.
*/

--사원들의 급여가 높은 순서대로 사원명 급여 순위 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE; --공동 19위 2명이기 때문에 다음 순위는 21위가 됨

--DENSE_RANK() OVER
SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE; --공동 19의 2명이여도 다음 순위 20위

--5위까지만 
--WHERE절에 기술 불가
--인라인뷰 사용하기
SELECT E.*
FROM (SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "순위"
      FROM EMPLOYEE) E
WHERE 순위 <= 5;

















