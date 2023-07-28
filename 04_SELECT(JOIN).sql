/*
    <JOIN>
    
    두개이상의 테이블에서 테이터를 같이 조회하고자 할때 사용되는 구문 - SELECT문 이용
    조회 결과는 하나의 겨로가물 (RESULT SET)으로 나온다.
    
    JOIN을 사용하는 이유
    관계형 데이터베이스에서는 최소한의 데이터로 각각의 테이블에 데이터를 보관하고 있다.
    사원정보는 사원테이블, 직급정보는 직급테이블,... 등등 -> 중복을 최소화하기 위해
    -즉 JOIN구문을 이용하여 여러개 테이블간의 "관계"를 맺어서 같이 조회한다.
    -무작정 JOIN을 하는 것이 아니라 테이블간의 연결고리에 해당하는 컬럼을 매칭시켜 조회한다
    
    문법상 분류: JOIN은 크게 "오라클 전용 구문"과 "ANSI(미국 국립표준협회) 구문"으로 나눤다
    
    개념상 분류
    오라클 전용 구문                          ANSI구문(오라클 + 다른 DBMS)
    ===============================================================
    등가조인(EQUAL JOIN)                    내부조인(INNER JOIN)-> JOIN USING/ON
    ---------------------------------------------------------------
    포괄조인                                외부조인(OUTER JOIN) -> JOIN USING
    (LEET OUTER JOIN)                     왼쪽 외부조인(LEFT OUTER JOIN)
    (RIGHT OUTER JOIN)                    오른쪽 외부조인(RIGNT OUTER JOIN)
                                      전체 외부조인(FULL OUTER JOIN): 오라클에서는 불가능
    ---------------------------------------------------------------
    카테시안 곱(CARTESIAN PRODUCT)           교차조인(CROSS JOIN)
    ---------------------------------------------------------------
    자체조인(SELF JOIN)
    비등가 조인(NON EQUAL JOIN)
    ---------------------------------------------------------------
    +다중조인(테이블 3개이상 조인)
*/

--JOIN을 사용하지 않는 EX
--전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

--전체 사원들의 사번, 사원명, 직급코드, 직급명까지 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE;

SELECT JOB_CODE, JOB_NAME
FROM JOB;

/*
    1.등가조인(EQUAL JOIN)/ 내부조인(INNER JOIN)
    연결시키고자하는 컬럼의 값이 "일치하는 행들만" 조언
    (일치하지 않는 값은 결과에서 제외된다)
    -동등비교연산자를 제시
    
    [표현법]
    등가조인(오라클구문)
    SELECT 조회컬럼
    FROM 조인하고자하는 테이블명 나열
    WHERE 연결할 컬럼에 대한 조건제시(=)
    
    내부조인(ANSI 구문): ON구문
    SELECT 조회하고자하는 컬럼명 나열
    FROM 기준 테이블명
    JOIN 조인할 테이블명 ON (연결 컬럼 조건 제시(=) )
    
    내부조인(ANSI 구문): USING 구문
    SELECT 조회하고자하는 컬럼명 나열 
    FROM 기준 테이블명
    JOIN 조인할 테이블명 USING(연결컬럼)
*/

--오라클 전용 구문
--FROM절에 조회하고자 하는 테이블명을 나열, 를 이용하여
--WHERE절에 매칭시키고자하는 컬럼명에 대한 조건을 제시한다 (=)

--전체 사원들의 사번, 사원명, 부서코드, 부서명까지 조회해보자.
--1)연결할 두 컬럼이 다른 경우(EMPLOYEE = DEPT_CODE / DEPARTMENT = DEPT_ID)

SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

--전체 사원들의 사번, 사원명, 직급코드, 직급명까지 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE=JOB_CODE; --COLUNM AMBIGUOUSLY DEFINED: 컬럼이 모호하다는 의미
--명시적으로 어떤 테이블의 컬럼인지 작성하여야한다.

--방법1) 테이블명을 이용하는 방법 - 테이블명, 컬럼명
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

--방법2) 테이블에 별칭을 부여하여 별칭을 이용하는 방법 별칭.컬럼명
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE=J.JOB_CODE;

--ANIS 구문
--FROM 절에 테이블을 하나만 가술한 뒤
--아래 JOIN 구문에서 연결지을 테이블명을 기술 후 
--매칭 시킬 컬럼을 ON/USING 구문을 이용하여 기술한다.

--전체 사원들의 사번, 사원명, 부서코드, 부서명까지 조회해보자.
--서로 다른 컬럼명일 경우 (EMPLOYEE.DEPT_CODE / DEPARTMENT.DEPT_ID)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
INNER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
--INNER 값이 기본 (생략가능)

--전체 사원들의 사번, 사원명, 직급코드, 직급명까지 조회
--서로 같은 컬럼명을 연결짓고자 한다면. (EMPLOYEE.JOB_CODE / JOB.JOB_CODE)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);

--ON 구문으로: 동일한 컬럼명일 경우 모호하기 때문에 어떤 테이블의 컬럼명인지 명시하여야 한다.
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
--JOIN JOB USING (JOB_CODE)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

--직급이 대리인 사원들의 정보를 조회(사번, 사원명, 월급, 직급명)
--오라클전용 
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND JOB_NAME = '대리';

--ANSI
--USING 구문
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME='대리';

--ON 구문
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE=J.JOB_CODE)
WHERE JOB_NAME='대리';



--------------------------------------------
--오라클 구문과 ANSI 구문 모두 사용하세요. 
--1. 부서가 '인사관리부' 인 사원들의 사번, 사원명, 보너스를 조회
--ANSI
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE DEPT_TITLE = '인사관리부';

--오라클
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE = '인사관리부';

--2. 부서가 '총무부'가 아닌 사원들의 사원명, 급여, 입사일을 조회
--ANSI
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE ^= '총무부';

--오라클
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE ^= '총무부';

--3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
--ANSI
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE BONUS IS NOT NULL;

--오라클
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE=DEPT_ID
AND BONUS IS NOT NULL;

--4. 아래의 두 테이블을 참고해서 부서코드, 부서명, 지역코드, 지역명(LOCAL_NAME) 조회
--ANSI
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT 
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

--오라클
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

--SELECT * FROM DEPARTMENT; -- LOCATION_ID
--SELECT * FROM LOCATION; -- LOCAL_CODE

/*
    <다중 JOIN>
    3개 이상의 테이블을 조인하여 조회하겠다
    -주의: 조인 순서를 지켜야한다.
*/
--사번, 사원명, 부서명, 직급명
--일단 각 테일블별로 조회
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;

--오라클 전용구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE=D.DEPT_ID
AND E.JOB_CODE = J.JOB_CODE;

--ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E
/*LEFT*/ JOIN DEPARTMENT D ON (DEPT_CODE = DEPT_ID) --LEFT 사용시 null값도 가져옴 
JOIN JOB J USING(JOB_CODE);

SELECT * FROM EMPLOYEE;

--------------------------------------------------------------
--전체 사원들의 사원명 급여 부서명
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);

SELECT* FROM EMPLOYEE;
--DEPT_CODE가 NULL인 두명의 사원의 결과는 조회되지 않음
--부서에 배정되지 않은 사원의 데이터를 조회하려면?
--외부조인, 포괄조인을 사용해야한다.

/*
    2.포괄조인 / 외부조인(OUTER JOIN)
    
    테이블간의 JOIN시에 "일치하지 않는 행"도 포함시켜서 조회 가능하다/
    단, 반드시 LEFT / RIGHT를 지정해야한다 (기준테이블을 지정하는 것)
    일치하는 행 + 기준이 되는 테이블의 데이터 전부 포함시켜 조회
*/
--전체 사원들의 사원명, 급여, 부서명
--1) LEFT OUTER JOIN: 두 테이블 중 왼편에 기술된 테이블을 기준으로 JOIN

--ANSI
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
LEFT /*OUTER*/ JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);
--기준이 되고 있는 EMPLOYEE테이블의 데이터는 전부 조회가 된다.(일치하는 행이 없어도)

--ORACLE
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE=DEPT_ID(+);
--기준이 되는 테이블 컬럼명이 아닌 다른 테이블의 컬럼명에(+) 기호를 붙힌다
--또는 없는 데이터를 보여줘야하는 테이블 컬럼에 (+)를 붙인다고 생각하기

--2)RIGHT OUTER JOIN: 두테이블중 오른편에 기술된 테이블을 기준으로 JOIN
--ANSI
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);

--ORACLE
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
WHERE DEPT_CODE(+)=DEPT_ID;

--3)FULL OUTER JOIN: 두 테이블이 가진 모든 행을 조회
--일치하는 행들 + LEFT JOIN 기준 추가행 + RIGHT JOIN 기준 추가행
--ANSI 구문만 가능 (오라클 전용 구문은 없음)
--ANSI
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);

/*
    3.카테시안 곱(CARTESIAN PRODUCT) / 교차조인 (CROSS JOIN)
    모든 테이블의 각 행들이 서로 매핑된 데이터가 조회된다
    두 테이블의 행들이 모두 곱해진 행들의 조합 출력
    -N개,M개의 행을 가진 테이블들의 결과는 N*M이 된다
    -모든 경우의 수를 조회한다
    -과부화의 위험이 있음 (너무 많은 데이터 조회)
*/

--사원명, 부서명 
--오라클
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT; --207개 행 조회 23*9

--ANSI
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT; --CROSS JOIN

/*
    4.비등가 조인(NON EQUAL JOIN)
    
    등호를 이용하지 않는 조인 -> 다른 비교연산자를 사용하여 조인하겠다(>,<,>=,<=,BETWEEN A AND B)
    -지정한 컬럼 값들이 일치하는 경우가 아니라 "범위"에 포함되는 경우 매칭해서 조회하겠다
    
    -등가조인 - '='로 일치하는 경우만 조회
    -비등가조인 - '='가 아닌 다른 비교연산자를 통해 범위에 포함되는 경우 조회
    
*/
--사원명, 급여
SELECT EMP_NAME, SALARY
FROM EMPLOYEE;

--SAL_GRADE 테이블 
SELECT *
FROM SAL_GRADE;

--사원명, 급여, 급여등급(SAL_LEVEL)
--오라클
SELECT EMP_NAME, SALARY, E.SAL_LEVEL
FROM EMPLOYEE E, SAL_GRADE S
--WHERE SALARY>=MIN_SAL AND SALARY <=MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

--ANSI
SELECT EMP_NAME, SALARY, S.SAL_LEVEL
FROM EMPLOYEE E
JOIN SAL_GRADE S ON (SALARY >= MIN_SAL AND SALARY <= MAX_SAL);
--JOIN SAL_GRADE S ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

/*
    5.자체조인(SELF JOIN)
    같은 테이블끼리 조인하는 경우
    자신의 테이블과 다시 조인하겠다
    -자체 조인의 경우 테이블에 반드시 별칭을 부여해야한다(서로 다른 테이블처럼 다루겠다)
*/
SELECT * FROM EMPLOYEE E; --사원에 대한 정보도출용 테이블
SELECT * FROM EMPLOYEE M; --사우에 대한 정보 도출용 테이블

--사원의 사번, 사원명, 사수의 사번, 사원명
--오라클
SELECT E.EMP_ID "사원 사번", E.EMP_NAME "사원명", E.MANAGER_ID " 사번", M.EMP_NAME "사수명"
FROM EMPLOYEE E,EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID(+);

--ANSI
SELECT E.EMP_ID "사원 사번", E.EMP_NAME "사원명", E.MANAGER_ID " 사번", M.EMP_NAME "사수명"
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);















