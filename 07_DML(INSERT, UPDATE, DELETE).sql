/*
    *DML (DATA MANIPULATION LANGUAGE)
    
    데이터 조작 언어
    테이블에 새로운 데이터를 삽입(INSERT), 기존 데이터를 수정(UPDATE), 삭제(DELETE)하는 구문
    
    1.INSERT: 테이블에 새로운 행을 추가하는 구문
    [표현법]
    *INSERT INTO 계열
    1)INSERT INTO 테이블명 VALUES(값1, 값2,....);
    -해당 테이블에 모든 컬럼에 대해 추가하고자 하는 값을 내가 직접 제시해서 "한 행"을 INSERT하고자 
    할때 사용하는 표현법
    주의) 컬럼의 순서, 자료형, 개수를 맞춰서 VALUES 괄호안에 값을 나열해야한다.
    -부족하게 값을 제시하는 경우: NOT ENOUGH VALUE 오류
    -값을 더 많이 제시했을 경우: TOO MANY VALUES 오류 발생 
*/
SELECT * FROM EMPLOYEE;
--EMPLOYEE 테이블에 사원 정보 추가
INSERT INTO EMPLOYEE VALUES(900,'김영호','770205-1234567','zerogh@naver.com','01055552222','D1','J2','S4',7600000,0.5,207,
                            SYSDATE, NULL,'N'); --ORA-12899: "KH"."EMPLOYEE"."PHONE" 열에 대한 값이 너무 큼(실제: 13, 최대값: 12)
                            
/*
    2) INSERT INTO 테이블명(컬럼명1, 컬럼명2,...) VALUES(값1, 값2,....);
    -해당 테이블에 특정 컬러만 설택하여 그 ㅓㄹ럼에 추가할 값만 제시하고자 할때 사용한다.
    -그래도 한 행 단위로 추가가 되기 때문에 선택이 되지 않는 컬럼은 기본적으로 NULL값이 들어가며
    -만약 DEFAULT 설정을 하였다면 해당 값이 기본값으로 들어가게 된다.
    
    주의 사항: NOT NULL 제약조건이 걸려있는 컬럼은 반드시 선택하여 직접 값을 제시해야한다
             다만 DEFAULT 설정이 되어 있다면 NOT NULL이라도 해도 선택하지 않아도 된다.
*/                           
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, SAL_LEVEL, HIRE_DATE)
VALUES(901,'김영철','860507-2233222','D9','J6','S5',SYSDATE);

SELECT * FROM EMPLOYEE WHERE EMP_ID= 901;

/*
    3) INSERT INTO 테이블명(서브쿼리);
    -VALUES()로 값을 직접 기입하는 것이 아니라
    -서브쿼리를 이용해 조회한 결과값을 INSERT하는 구문
    -여러 행을 한번에 INSERT할 수 있다.
*/
--새로운 테이블 만들기
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

--전체 사원들의 사번, 이름, 부서명을 조회한 결과를 EMP_01테이블에 통째로 추가해보세요
--1) 조회해오기
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

--2) 조회해온 데이터를 INSERT하기 (서브쿼리 이용)
INSERT INTO EMP_01
      (SELECT EMP_ID, EMP_NAME, DEPT_TITLE
       FROM EMPLOYEE, DEPARTMENT
       WHERE DEPT_CODE = DEPT_ID(+));
       
SELECT * FROM EMP_01;

--사원명, 부서명, 직급명을 가지고 있는 테이블을 생성한 뒤 기존 데이터에서 전체사원의 사원명, 부서명, 직급명을 조회하여
--데이터 넣어보기
CREATE TABLE EMP_02(
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(30),
    JOB_NAME VARCHAR2(35)
);
       
SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
JOIN JOB USING(JOB_CODE);

--조회한 데이터 서브쿼리를 이용하여 INSERT하기
INSERT INTO EMP_02 (SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
                    FROM EMPLOYEE
                    LEFT JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
                    JOIN JOB USING(JOB_CODE));
SELECT * FROM EMP_02;

/*
    *INSERT ALL 계열
    두개 이상의 테이블에 각각 INSERT할때 사용
    조건: 그때 사용되는 서브쿼리가 동일해야한다
    
    1) INSERT ALL
       INTO 테이블명1 VALUES(컬럼명, 컬럼명,....)
       INTO 테이블명2 VALUES(컬럼명, 컬럼명,....)
         서브쿼리;
*/

--테이블 생성
--첫번째 테이블: 급여가 300만원 이상인 사원들의 사번, 사원명, 직급명, 보관할 테이블
--테이블명: EMP_JOB / EMP_ID, EMP_NAME(30), JOB_NAME(20)
CREATE TABLE EMP_JOB(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    JOB_NAME VARCHAR2(20)
);

--두번째 테이블: 급여가 300만원 이상인 사원들의 사번, 사원명, 부서명, 보관할 테이블
--테이블명: EMP_DEPT / EMP_ID, EMP_NAME(30), DEPT_TITLE(30)
CREATE TABLE EMP_DEPT(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

--급여가 300만원 이상이 사원들의 사번, 사원명, 직급명, 부서명 조회해보기
SELECT EMP_ID, EMP_NAME, JOB_NAME,DEPT_TITLE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY >= 3000000;

--EMP_JOB 테이블엔 사번 사원명 직급명 넣기
--EMP_DEPT 테이블엔 사번, 사원명 부서명 넣기
INSERT ALL
INTO EMP_JOB VALUES(EMP_ID, EMP_NAME, JOB_NAME)
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_TITLE)
    SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    WHERE SALARY >= 3000000;

------------------연습 문제 2--------------------
--사원명, 부서명, 입사날짜를 가진 테이블
CREATE TABLE EMP_DEPT2(
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(30),
    HIRE_DATE DATE
);

--사원명, 직급명, 입사날짜를 가진 테이블
CREATE TABLE EMP_JOB2(
    EMP_NAME VARCHAR2(30),
    JOB_NAME VARCHAR2(30),
    HIRE_DATE DATE
);

--연봉이 3000만원 이상인 사원들을 넣어보세요
SELECT EMP_NAME, NVL(DEPT_TITLE,'부서없음') "DEPT_TITLE", JOB_NAME, HIRE_DATE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE SALARY*12 >= 30000000;

INSERT ALL
INTO EMP_DEPT2 VALUES(EMP_NAME, DEPT_TITLE, HIRE_DATE)
INTO EMP_JOB2 VALUES(EMP_NAME, JOB_NAME, HIRE_DATE)
    SELECT EMP_NAME, NVL(DEPT_TITLE,'부서없음') "DEPT_TITLE", JOB_NAME, HIRE_DATE
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    JOIN JOB USING(JOB_CODE)
    WHERE SALARY*12 >= 30000000;

/*
    INSERT ALL
    WHEN 조건1 THEN
        INTO 테이블명1 VALUES(컬럼명, 컬럼명,...)
    WHEN 조건2 THEN
        INTO 테이블명2 VALUES(컬럼명, 컬럼명,...)
    서브쿼리
    
    -조건에 맞는 값만 삽입하겠다
    
*/

--2010년도 기준으로 이전에 입사한 사원들의 사번, 사원명, 입사일, 급여를 담는 테이블(EMP_OLD)
CREATE TABLE EMP_OLD(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    HIRE_DATE DATE,
    SALARY NUMBER
);

--CREATE TABLE EMP_OLD
--AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
--   FROM EMPLOYEE
--   WHERE 1=0;

--2010년도 기준으로 이후(2010년포함)에 입사한 사원들의 사번, 사원명, 입사일, 급여를 담는 테이블(EMP_NEW)
CREATE TABLE EMP_NEW(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    HIRE_DATE DATE,
    SALARY NUMBER
);

--CREATE TABLE EMP_NEW
--AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
--   FROM EMPLOYEE
--   WHERE 1=0;

--위에 두 테이블을 CREATE 서브쿼리 구문을 이용하여 생성하시오.
--생성 후 해당 조건을 조회해보고 위에 구문을 사용하여 삽입까지 해보세요
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE
WHERE HIRE_DATE < '2010/01/01'; --2010년 이전 입사 
--WHERE HIRE_DATE >= '2010/01/01'; 2010년 이후 입사 

INSERT ALL
WHEN HIRE_DATE < '2010/01/01'
    THEN INTO EMP_OLD VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2010/01/01'
    THEN INTO EMP_NEW VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE;

--서브쿼리에 컬럼명 부분에 *로 전체조회를 해도 잘 들어갔는지 확인해보기
--테이블명에 2를 추가하여 다시 생성한 뒤 확인해보기

INSERT ALL
WHEN HIRE_DATE < '2010/01/01'
THEN INTO EMP_OLD VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2010/01/01'
THEN INTO EMP_NEW VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    SELECT *
    FROM EMPLOYEE;
--잘들어간다 

/*
    2.UPDATE
    테이블에 기록된 기존 데이터를 수정하는 구문 
    [표현법]
    UPDATE 테이블명
    SET 컬럼명 = 바꿀 값
       ,컬럼명 = 바꿀 값
       ,컬럼명 = 바꿀 값
       ,.... -여러개의 컬럼값을 동시에 변경 가능하다(,를 이용하여 나열)
    WHERE 조건; -- WHERE절을 생략하면 전체 데이터가 다 변경된다.
*/

--복사본 테이블을 만든 후 작업하기
--부서 테이블을 데이터까지 모두 복사하기 테이블명(DEPT_COPY)
--DEPT_COPY테이블에서 D9부서의 부서명을 전략기획팀으로 수정해보세요.
CREATE TABLE DEPT_COPY
AS SELECT *
   FROM DEPARTMENT;

--정보 수정하기
UPDATE DEPT_COPY
SET DEPT_NAME = '전략기획팀'
WHERE DEPT_ID = 'D9';

--ROLLBACK: 변경사항에 대해서 되돌리는 구문
ROLLBACK;

--복사본 테이블
--테이블명 EMP_SALARY / 컬럼: EMPLOYEE 테이블로부터 사번, 사원명, 부서코드, 급여, 보너스 -값까지 모두 복사하기
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
   FROM EMPLPYEE;


--EMP_SALARY테이블에서 노옹철 사원의 급여를 1000만원으로 변경하기
UPDATE EMP_SALARY
SET SALARY = 10000000
WHERE EMP_NAME = '노옹철';

--EMP_SALARY테이블에서 선동일 사원의 급여를 700만원, 보너스를 0.2로 변경하기
UPDATE EMP_SALARY
SET SALARY = '7000000'
  , BONUS = 0.2
WHERE EMP_NAME = '선동일';

--EMP_SALARY테이블에서 전체사원의 급여를 기존의 20프로 인상한 금액으로 변경하기
UPDATE EMP_SALARY
SET SALARY = SALARY * 1.2;

/*
    UPDATE시에 서브쿼리 사용
    서브쿼리를 수행한 결과값으로 기존의 값으로부터 변경하겠다.
    
    -CREATE시에 서브쿼리 사용: 서브쿼리를 수행한 결과를 테이블 만들때 넣겠다.
    -INSERT시에 서브쿼리 사용: 서브쿼리를 수행한 결과를 해당 테이블에 삽입하겠다.
    
    [표현법]
    UPDATE 테이블명
    SET 컬럼명 = (서브쿼리)
    WHERE 조건;
*/

--EMP_SALARY테이블에 본인이 추가한 이름의 사원 부서코드를 변경해보자
--김영호 - D1인 부서코드를 김영철의 부서코드와 일치시키기
UPDATE EMP_SALARY
SET DEPT_CODE = (SELECT DEPT_CODE
                 FROM EMP_SALARY
                 WHERE EMP_NAME = '김영철')
WHERE EMP_NAME = '김영호';

--방명수 사원의 급여와 보너스를 유재식 사원의 급여와 보너스값으로 변경해보세요
--단일행 다중열 서브쿼리 이용해보기
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                     FROM EMP_SALARY
                     WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

--UPDATE구문을 사용할때에도 제약조건을 위배하면 안된다.
--EMPLOYEE
--송중기 직원의 사번을 200으로 변경해보기
UPDATE EMPLOYEE
SET EMP_ID = 200 --PRIMARY 키로 설정되어 있어서 중복을 넣을수 없다.
WHERE EMP_NAME = '송중기';
--PRIMARY KEY 제약 조건을 위배함

--사번이 200번인 데이터의 사원명을 NULL로 변경해보기
UPDATE EMPLOYEE
SET EMP_NAME = NULL
WHERE EMP_ID = 200; 
--NOT NULL 제약 위배 사항

--모든 변경사항을 확정하는 명령어: COMMIT
COMMIT;

/*
    4.DELETE
    테이블에 기록된 데이터를 "행"단위로 삭제하는 구문
    
    [표현법]
    DELETE FROM 테이블명
    WHERE 조건; --WHERE절 생략가능, 생략 시 모든 행 삭제
*/
--EMPLOYEE 테이블 모든 행 삭제 
DELETE FROM EMPLOYEE;
SELECT * FROM EMPLOYEE; --데이터 전체행이 다 삭제됨, 테이블은 삭제되지 않음

ROLLBACK;

--EMPLOYEE테이블에서 아까 추가한 2명 데이터 삭제해보기
DELETE FROM EMPLOYEE --FROM 생략가능
WHERE EMP_NAME IN ('김영호','김영철'); --WHERE절 조건에 따라 1개의 행이 변경될 수 있고 또는 여러행이 변경될수 있다

--DEPARTMENT테이블로부터 DEPT_ID가 D1인 부서 삭제
DELETE FROM DEPARTMENT 
WHERE DEPT_ID = 'D1'; --만약 DPET_ID를 EMPLOYEE테이블의 DEPT_CODE가 참조하고 있었다면 삭제되지 않는다.

/*
    *TRUNCATE: 테이블의 전체행을 모두 삭제할때 사용하는 구문 DELETE보다 수행속도가 빠르다
               별도의 조건을 제시할 수 없다. ROLLBACK이 불가능하다
               (절삭)
*/
SELECT * FROM EMP_SALARY;

DELETE FROM EMP_SALARY; --COMMIT 전이라면 ROLLBACK 가능
ROLLBACK;

TRUNCATE TABLE EMP_SALARY; --ROLLBACK 불가능













                            