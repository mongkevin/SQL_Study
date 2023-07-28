/*
    OBJECT
    데이터베이스를 이루는 논리적인 구조물들
    
    *OBJECT의 종류
    -TABLE, USER, VIEW, SEQUENCE, INDEX, PACKAGE, TRIGGER, FUNCTION, SYNONYM, PROCEDURE...
    
    <VIEW>
    SELECT를 저장할 수 있는 객체
    (자주 사용될 긴 SELECT문을 VIEW에 저장시켜둔다면 매번 SELECT문을 작성할 필요가 없다)
    -조회용 임시 테이블 같은 존재(실제 데이터가 담겨있는 것은 아니다)
*/

--------------------실습문제---------------------
--'한국'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명, 직급명을 조회하시오
--오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, NATIONAL N, LOCATION L, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE
AND E.JOB_CODE = J.JOB_CODE
AND N.NATIONAL_NAME = '한국';

--ANSI구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N USING(NATIONAL_CODE)
JOIN JOB J USING(JOB_CODE)
WHERE N.NATIONAL_NAME = '한국';

/*
    1. VIEW 생성 방법
    
    [표현법]
    CREATE VIEW 뷰명
    AS 서브쿼리;
    
    CREATE OR REPLACE VIEW 뷰명
    AS 서브쿼리;
    -뷰 생성시 중복된 이름이 있다면 해당 이름의 뷰를 갱신하는 구문
    -없다면 생성
    -옵션 생략 가능
    
*/

CREATE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME
   FROM EMPLOYEE E, DEPARTMENT D, NATIONAL N, LOCATION L, JOB J
   WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND L.NATIONAL_CODE = N.NATIONAL_CODE
   AND E.JOB_CODE = J.JOB_CODE;
    
DROP VIEW VW_EMPLOYEE;
--01031. 00000 -  "insufficient privileges" (권한 부여하고 오기)

--사원들의 사번, 이름, 부서명, 급여, 근무국가명, 직급명을 조회하시오
SELECT *
FROM(SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME
     FROM EMPLOYEE E
     JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
     JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
     JOIN NATIONAL N USING(NATIONAL_CODE)
     JOIN JOB J USING(JOB_CODE)
     WHERE N.NATIONAL_NAME = '한국');

--위의 구문을 VIEW로 생성해두었으니 VIEW로 조회하기
SELECT *
FROM VW_EMPLOYEE;

--'한국'에서 근무하는 사원 조회
SELECT *
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME='한국';

--'러시아'에서 근무하는 사원들의 사번 이름 직급명 보너스
SELECT EMP_ID, EMP_NAME, JOB_NAME, BONUS
FROM VW_EMPLOYEE;
--현재 VIEW에는 BONUS조회 항목이 없기 때문에 오류가 발생한다.
--이때 BONUS를 추가하고자 한다면?
--CREATE OR REPLACE 구문을 사용
CREATE OR REPLACE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_NAME, E.BONUS
   FROM EMPLOYEE E, DEPARTMENT D, NATIONAL N, LOCATION L, JOB J
   WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND L.NATIONAL_CODE = N.NATIONAL_CODE
   AND E.JOB_CODE = J.JOB_CODE;

SELECT* FROM VW_EMPLOYEE; 

--'러시아'에서 근무하는 사원들의 사번 이름 직급명 보너스(CREATE OR REPLACE 후)
SELECT EMP_ID, EMP_NAME, JOB_NAME, BONUS
FROM VW_EMPLOYEE;
--수정사항이 갱신되어 오류 사라짐

--뷰는 논리적인 가상테이블 - 실직저긍로 데이터를 저장하고 있지 않음
--단순히 쿼리문이 TEXT문구로 저장되어 있다. 
--참고) 해당 계정이 가지고 있는 VIEW에 대한 내용을 조회할땐
--USER_VIEWS 데이터 딕셔너리를 조회하면 된다/
SELECT * FROM USER_VIEWS;

--사원의 사번, 이름, 직급명, 성별, 근무년수를 조회할 수 있는 SELECT문을 작성한 뒤
--VIEW로 생성해보시오.
SELECT EMP_ID, EMP_NAME, JOB_NAME, 
       DECODE(SUBSTR(EMP_NO,8,1),1,'남',3,'남',2,'여',4,'여'),
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

CREATE OR REPLACE VIEW VW_EMP
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, 
   DECODE(SUBSTR(EMP_NO,8,1),1,'남',3,'남',2,'여',4,'여'),
   EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
   FROM EMPLOYEE
   JOIN JOB USING(JOB_CODE); --별칭을 부여하지 않아 오류

/*
    뷰 컬럼에 별칭 부여
    서브쿼리 부분에 SELECT절에 함수나 산술연산식이 기술되어 있는 경우엔 반드시 별칭을 부여해야한다.
*/
CREATE OR REPLACE VIEW VW_EMP
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, 
   DECODE(SUBSTR(EMP_NO,8,1),1,'남',3,'남',2,'여',4,'여') "성별", 
   EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) "근무년수"
   FROM EMPLOYEE
   JOIN JOB USING(JOB_CODE);
--별칭 부여 후 생성 성공
SELECT * FROM VW_EMP;

--또 다른 방법(별칭 나열방식)- 모든 컬럼에 대해서 별칭을 입력하여야한다.
CREATE OR REPLACE VIEW VW_EMP ("사번","이름","직급명","성별","근무년수")
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, 
   DECODE(SUBSTR(EMP_NO,8,1),1,'남',3,'남',2,'여',4,'여') , 
   EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
   FROM EMPLOYEE
   JOIN JOB USING(JOB_CODE);

SELECT 사번, 이름, 직급명, 성별, 근무년수 
FROM VW_EMP;

SELECT 이름, 성별
FROM VW_EMP
WHERE 성별 ='여'; --이미 생성할때 부여된 별칭 및 리터럴들을 SELECT할때 사용 가능하다.

--근무년수가 20년 이상인 사원들의 사번, 이름, 근무년수
SELECT 사번, 이름, 근무년수
FROM VW_EMP
WHERE 근무년수 >= 20;

--뷰생성
CREATE OR REPLACE VIEW VW_EMP_TEST
AS SELECT * FROM EMP_01;

SELECT * FROM VW_EMP_TEST;

--뷰 삭제
DROP VIEW VW_EMP_TEST;

SELECT * FROM USER_VIEWS;

--뷰를 통해 DML구문 실행시켜보기
--생성된 뷰를 통해서 DML(INSERT, UPDATE, DELETE) 사용이 가능하지만
--뷰를 통해 조작된 데이터는 실제 데이터가 조작된다.

SELECT * FROM VW_EMP_TEST;
--뷰에 INSERT해보기
INSERT INTO VW_EMP_TEST VALUES(999,'김구구','비비디부');

--기반 테이블 조회해보기
SELECT * FROM EMP01; --기반테이블에 해당 데이터가 추가되었다.

--VW_EMP_TEST에 999번째 사원의 이름을 구구콘으로 변경
UPDATE VW_EMP_TEST 
SET EMP_NAME = '구구콘' 
WHERE EMP_ID = 999;

--VW_EMP_TEST에 800번째 사원을 삭제
DELETE FROM VW_EMP_TEST WHERE EMP_ID = 800;

--두 작업 후 기반 테이블도 확인해보기
SELECT * FROM EMP_01;

--VIEW에 DML구문을 적용하면 기반테이블이 영향을 받는다.

--기반테이블에서 삭제되면 VIEW에서 볼 수 없다.(기반테이블 영향을 받는다)
DELETE FROM EMP_01
WHERE EMP_ID=999;

SELECT * FROM VW_EMP_TEST;

/*
    DML이 가능한 경우: 서브쿼리를 이용하여 기존의 테이블을 별도의 처리없이 복제하고자 할 경우
    
    *하지만 VIEW에 DML이 불가능한 경우가 더 많다 - 한번의 처리가 적용된 경우는 불가능
    1)뷰에 정의되어있지 않은 컬럼 조작하는 경우
    2)뷰에 정의되어있지 않은 컬럼 중 기반테이블에 NOT NULL제약조건이 지정된 경우
    3)산술 연산식 또는 함수를 통해 정의되어 있는 경우
    4)그룹함수나 GROUP BY 절이 포함된 경우
    5)DISTINCT 구문이 포함된 경우
    6)JOIN을 이용하여 여러테이블을 매칭 시켜놓은 경우
    
*/
--1)뷰에 정의되어있지 않은 컬럼 조작하는 경우
--당연한 결과로 스킵한다

--2)뷰에 정의되어있지 않은 컬럼 중 기반테이블에 NOT NULL제약조건이 지정된 경우
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_NAME FROM JOB;

SELECT * FROM VW_JOB;

--INSERT로 데이터를 넣어보자
INSERT INTO VW_JOB VALUES('인턴'); --JOB테이블에 (NULL,'인턴')와 같은 형태로 데이터가 들어가려고 함
--NOT NULL제약조건이 걸려있는 JOB_CODE에 NULL이 들어가려해서 오류 발생.

--VIEW 옵션
--FORCE: 쿼리문의 테이블, 컬럼, 함수 등이 존재하지 않아도 생성이 된다.

--[표현법] CREATE FORCE VIEW 뷰명 
CREATE FORCE VIEW VW_FORCE_TEST
AS SELECT * FROM TB_TEST;

SELECT * FROM TB_TEST;

SELECT * FROM VW_FORCE_TEST;

SELECT * FROM USER_VIEWS;

--존재하지 않은 기반테이블을 CREATE해보기
CREATE TABLE TB_TEST(
    TB_ID NUMBER,
    TB_NAME VARCHAR2(20)
);

--3.WITH CHECK OPTION
--SELECT문에서 WHERE절에 설정한 조건을 위배하는 수정을 막아주는 옵션 
CREATE OR REPLACE VIEW VW_CHECKOPION
AS SELECT EMP_ID, EMP_NAME, SALARY,DEPT_CODE
   FROM EMPLOYEE
   WHERE DEPT_CODE = 'D5' WITH CHECK OPTION;

SELECT * FROM VW_CHECKOPION;

--CHECKOPTION이 설정된 컬럼에 대해 변경하지 않음
UPDATE VW_CHECKOPION
SET SALARY = 500000
WHERE EMP_ID=207; --가능

--CHECK OPTION 설정 조건 위배해보기
UPDATE VW_CHECKOPION
SET DEPT_CODE='D1'
WHERE EMP_ID = 207; --변경 실패(WITH CHECK OPTION의 조건에 위배 됩니다)

--4.WITH READ ONLY
--VIEW에 대한 수정을 막는 옵션(조회전용)
CREATE OR REPLACE VIEW VW_READONLY
AS SELECT * FROM EMPLOYEE WITH READ ONLY;

SELECT * FROM VW_READONLY;

UPDATE VW_READONLY
SET EMP_NAME='김철수'
WHERE EMP_ID=202; --cannot perform a DML operation on a read-only view

