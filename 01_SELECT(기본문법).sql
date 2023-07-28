--DML : 데이터 조작, SELECT(DQL), INSERT, UPDATE, DELETE
--DDL : 데이터 정의, CREATE,ALTER,DROP
--TCL : 트랜잭션 제어, COMMIT, ROllBACK
--DCL : 권한부여, GRANT, REVOKE

/*
    <SELECT>
    데이터를 조회하거나 검색할때 사용하는 명령어
    
    -RESULT SET: SELECT 구문을 통해 조회된 데이터의 결과물을 의미,
                조회된 행들의 집합
                
    [표현법]
    SELECT 조회하고자하는 컬럼명,컬럼명2,컬럼명3.....
    FROM 테이블명;

*/
--EMPLOYEE 테이블에서 전체 사원들의 사번, 이름, 급여 컬럼을 조회해보자
SELECT EMP_ID,EMP_NAME,SALARY
fROM EMPLOYEE;


--대소문자를 구분하지 않기 때문에 소문자로 작성해도 된다
--대문자로 작성하는 것이 보편적

--EMPLOYEE 테이블의 모든 컬럼을 조회하고자 한다면? 전체*를 이용한다
SELECT*
FROM EMPLOYEE;

--EMPLOYEE 테이블의 전체 사원들의 이름, 이메일, 휴대폰 번호를 조회
SELECT EMP_NAME,EMAIL,PHONE
FROM EMPLOYEE;

------실습문제--------
--1.JOB 테이블의 모든 컬럼 조회
SELECT * 
FROM JOB;
--2.JOB 테이블의 직급명 컬럼만 조회
SELECT JOB_NAME
FROM JOB;
--3.DEPARTMENT 테이블의 모든 컬럼 조회
SELECT *
FROM DEPARTMENT;
--4.EMPLOYEE 테이블의 직원명, 이메일, 전화번호, 입사일 컬럼만 조회
SELECT EMP_NAME, EMAIL, HIRE_DATE
FROM EMPLOYEE;
--5.EMPLOYEE 테이블의 입사일, 지원명,급여만 조회
SELECT HIRE_DATE,EMP_NAME,SALARY
FROM EMPLOYEE;

/*
    <컬럼값을 통한 산술 연산>
    조회하고자 하는 컬럼들을 나열하는 SELECT절에 산술연산(+-/*)을 기술하여 결과를 조회할 수 있다
*/

--EMPLOYEE 테이블에서 직원명, 월급, 연봉(월급*12)
SELECT EMP_NAME,SALARY,SALARY*12 --조회결과 컬럼명에 계산식 그대로 들어간다.
FROM EMPLOYEE;

--EMPLOYEE 테이블에서 직원명, 월그, 보너스, 보너스가 포함된 연봉(월급+보너스*월급)*12
SELECT EMP_NAME,SALARY,BONUS,(SALARY+BONUS*SALARY)*12
FROM EMPLOYEE; --산술연산 과정에서 NULL값이 존재할 경우 산술연산의 결과마저도 NULL값이 된다.

--EMPLOYEE 테이블에서 직원명, 입사일, 근무일수(오늘날짜-입사일) 조회
--연산은 DATE 타입 - 년,월,일,시,분,초 단위 저장타입
--오늘 날짜 SYSDATE
SELECT EMP_NAME,HIRE_DATE,SYSDATE-HIRE_DATE
FROM EMPLOYEE; --값이 지저분해보이는 이유: DATE타입안에 포함된 시,분,초 단위도  연산수행되기 때문에

/*
    계산식이 컬럼명에 들어가기때문에 가독성이 좋지 않다
    가독성을 위해 별칭을 부여해보자.
    <컬럼명에 별칭 부여하기>
    [표현법]
    컬럼명 AS 별칭, 컬럼명 AS "별칭", 컬럼명 별칭, 컬럼명 "별칭"
    AS를 붙이던 안붙이던
    별칭에 특수문자 또는 띄어쓰기가 포함될 경우 ""로 감싸는 표기법으로 작성해야한다.
*/

--EMPLOYEE테이블로 부터 직원명, 월급, 연봉(월급*12)을 조회
SELECT EMP_NAME AS 이름,SALARY AS 월급,SALARY*12 AS 연봉
FROM EMPLOYEE;

--EMPLOYEE테이블로부터 직원명, 월급, 보너스,보너스가 포함된 연봉(월급+보너스*월급)*12
SELECT EMP_NAME AS "직원명", SALARY AS "월급", BONUS AS "보너스", (SALARY+BONUS+SALARY)*12 AS "보너스포함 연봉"
FROM EMPLOYEE;

--EMPLOYEE 테이블로부터 직원명, 입사일, 근무일수 조회
SELECT EMP_NAME AS "사원 명", HIRE_DATE "입사 일", SYSDATE-HIRE_DATE "근무일 수"
FROM EMPLOYEE;

/*
    <리터럴>
    임의로 지정한 문자열('')을 SELECT절에 기술하면
    실제 그 테이블에 존재하는 데이터처럼 조회 가능하다
    
*/
--EMPLOYEE테이블로부터 사번, 사원명,급여,단위(원) 조회하기
SELECT EMP_ID 사번, EMP_NAME 사원명, SALARY 급여, '원' 단위
FROM EMPLOYEE;  --SELECT절에 제시한 리터럴 값이 조회결과인 RESULTSET의 모든 해에 반복적으로 출력된다.

/*
    <DISTINCT>
    조회하고자하는 컬럼에 중복된 값을 하나만 조회하려는 용도
    중복제거(해당 컬럼명 앞에 기술)
    [표현법]
    DISTINCT 컬럼명
    -주의) SELECT절에는 DISTINCT 구문이 한개만 가능하다
    
*/

--EMPLOYEE 테이블에서 부서코드들만 조회
SELECT DEPT_CODE
FROM EMPLOYEE;

SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE; --중복제거 조회

--EMPLOYEE테이블에서 직급코드들만 조회
SELECT JOB_CODE
FROM EMPLOYEE; --일반 조회

SELECT DISTINCT JOB_CODE
FROM EMPLOYEE; --중복제거 조회

----------------------------------------
/*
    <WHERE절>
    조회하고자 하는 테이블에 특정 조건을 제시하여 그 조건에 만족하는
    테이터들만을 조회하고자 할때 기술하는 구문
    
    [표현법]
    SELECT 조회하고자하는 컬럼명 - 해당 컬럼들을 조회하겠다
    FROM 테이블명
    WHERE 조건식; -그중 조건에 부합하는 것 들만

    구문 실행 순서
    FROM -> WHERE -> SELECT
    
    조건식에서는 다양한 연산자들을 이용할 수 있다
    <비교연산자>
    자바에서는 ==이 같다의 의미였는데 오라클에서는 =기호 하나로 같음을 표시
    같지않다는 의미의 != 와 같은 용도 ^=,<>가 있다.



*/
--EMPLOYEE 테이블로부터 급여가 400만원 이상인 사원들만 조회(모든 컬럼에 대해)
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 4000000;
--EMPLOYEE 테이블로부터 부서코드가 D9인 사원들의 사원명,부서코드,급여 조회
SELECT EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'; --문자열 홑따옴표
--EMPLOYEE 테이블로부터 부서코드가 D9이 아닌ㄴ 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME 사원명,DEPT_CODE 부서코드,SALARY 급여
FROM EMPLOYEE
WHERE DEPT_CODE ^= 'D9';
--WHERE DEPT_CODE <> 'D9';

---------실습문제------------
--1.EMPLOYEE테이블에서 급여가 300만원 이상인 사우너들의 이름,급여,입사일 조회
SELECT EMP_NAME,SALARY,HIRE_DATE
FROM EMPLOYEE
WHERE SALARY >= 3000000;
--2.EMPLOYEE테이블에서 직급코드가 J2인 사원들의 이름, 급여, 보너스 조회
SELECT EMP_NAME,SALARY,BONUS
FROM EMPLOYEE
WHERE JOB_CODE = 'J2';
--3.EMPLOYEE테이블에서 현재 재직중인 사원들의 사번, 이름, 입사일 조회
SELECT EMP_ID,EMP_NAME,HIRE_DATE
FROM EMPLOYEE
WHERE ENT_YN='N';
--4.EMPLOYEE테이블에서 연봉(급여*12)이 5000만원 이상인 사원들의 이름, 급여, 연봉, 입사일 조회
SELECT EMP_NAME,SALARY,SALARY*12 연봉, HIRE_DATE
FROM EMPLOYEE
WHERE (SALARY*12) >= 50000000; --해당 SELECT절에서 부여한 별칭을 WHERE절에 사용할 수 없다.

/*
    <논리 연산자>
    여러개의 조건을 묶을때 사용
    AND(자바&&) OR(자바:||)
    AND: ~이면서, 그리고
    OR: ~이거나, 또는
*/

--EMPLOYEE 테이블에서 부서코드가 D9이면서 급여가 500만원 이사인 사우너들의 이름 부서코드, 급여 조회
SELECT EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE='D9' AND SALARY >= 5000000;
--부서코드가 D6이거나 급여가 300만원 이사인 사원들의 이름,부서코드, 급여 조회
SELECT EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE='D6' OR SALARY >= 3000000;
--급여가 350만원 이상이고 600만원 이하인 사원들의 이름,사번,급여,직급코드 조회
SELECT EMP_NAME,EMP_ID,SALARY,JOB_CODE
FROM EMPLOYEE
WHERE SALARY>=350000 AND SALARY<=6000000;

/*
    <BETWEEN AND>
    몇 이상 몇 이하인 범위에 대한 조건을 제시할 때 사용
    [표현법]
    비교대상 컬럼명 BETWEEN 하한값 AND 상한값
    
*/

--급여가 350만원 이상이고 600만원 이하인 사원들의 이름, 사번, 급여, 직급코드 조회
SELECT EMP_NAME, EMP_ID, SALARY,JOB_CODE
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

--급여가 350만원 미만이고 600만원 초과인 사원들의 이름,사번,급여,직급코드 조회
SELECT EMP_NAME, EMP_ID, SALARY,JOB_CODE
FROM EMPLOYEE
--WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
WHERE SALARY NOT BETWEEN 3500000 AND 600000; --NOT의 위치는 컬럼명 앞 또는 BETWEEN 앞에 올수 있다
--NOT은 논리부정

--DATE형식에도 사용 가능
--입사일이 '90/01/01'~'03/01/01' 인 사원들의 모든 컬럼 조회사
SELECT*
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '03/01/01';

--입사일이 '90/01/01'~'03/01/01' 이 아닌 사원들의 모든 컬럼 조회사
SELECT*
FROM EMPLOYEE
WHERE NOT HIRE_DATE BETWEEN '90/01/01' AND '03/01/01';
--WHERE HIRE_DATE NOT BETWEEN '90/01/01' AND '03/01/01';

/*
    <LIKE '특정패턴'>
    비교하고자 하는 컬럼값이 내가 지정한 특정 패턴에 만족될 경우 조회
    
    [표현법]
    비교대상 컬럼명 LIKE '특정패턴'
    
    -옵선: 특정패턴 부분에 와일드카드인 '&','_'를 제시할 수 있다.
    '&':0글자 이상
        비교대상 컬럼명 LIKE '문자%' -> 컬럼값 중에 '문자'로 시작하는 것을 조회
        비교대상 컬럼명 LIKE '%문자' -> 컬럼값 중에 '문자'로 끝나는 것을 조회
        비교대상 컬럼명 LIKE '%문자%' -> 컬럼값 중에 '문자'가 포함되는 것을 조회
    '_': 1글자
        비교대상 컬럼명 LIKE '_문자' -> 해당 컬럼값 중에 '문자'앞에 글자 무조건 1글자가 존재하는 경우 조회
        비교대상 컬럼명 LIKE '__문자'-> 해당 컬럼값 중에 '문자'앞에 무조건 2글자가 존재하는 경우 조회 
    

*/

--성이 전씨인 사원들의 이름 급여 입사일 조회
SELECT EMP_NAME,SALARY,HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

--이름중에 '하'가 포함된 사원들의 이름 급여 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

--전화번호 4번째 자리가 9로 시작하는 사원들의 사번 사원명 전화번호 이메일 조회
SELECT EMP_ID, EMP_NAME,PHONE,EMAIL
FROM EMPLOYEE
WHERE PHONE LIKE '___9%';

--이름 가운데 글자가 '지'인 사원들의 모든 컬럼
SELECT *
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_지_';

--이름 가운데 글자가 '지'가 아닌 사원들의 모든 컬럼
SELECT*
FROM EMPLOYEE
--WHERE NOT EMP_NAME LIKE '_지_';
WHERE EMP_NAME NOT LIKE '_지_';

-------실습문제--------
--1.이름이 '연'으로 끝나는 사원들의 이름, 입사일 조회
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '__연';
--WHERE EMP_NAME LIKE '%연';
--2.전화번호 처음 3글자가 010이 아닌 사원들의 이름, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%'; 
--3.DEPARTMENT 테이블에서 해외영업과 관련된 부서들의 모든 컬럼조회
SELECT *
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '%해외영업%';

/*
    <IS NULL>
    해당 값이 NULL인지 비교해주는 용도
    
    [표현법]
    비교대상 컬럼 IS NULL: 컬럼값이 NULL일 경우
    비교대상 컬럼 IS NOT NULL: 컬럼값이 NULL이 아닐경우
*/
SELECT *
FROM EMPLOYEE;

--보너스를 받지 않는 사원들(BONUS 컬럼이 NULL인 사원들)의 사번, 이름, 급여,보너스
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NULL;

--사수가 없는 사원들의 사원명, 사수사번, 부서코드 조회
SELECT EMP_NAME, EMP_ID, EMP_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;
--사수도 없고 부서배치도(DEPT_CODE)도 아직 바지 않은 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL;
--부서배치는 받지 않았지만 보너스는 받은 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE BONUS IS NULL;

SELECT EMP_NAME, MAMGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANATGER_ID IS NULL;

SELECT*
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND CONUS IS NOT NULL;

/*
	<IN>
	비교 대상 컬럼 값이 내가 제시한 목록들 중에 일치하는 값이 있는지 판단

	[표현법]
	비교대상 컬럼 IN (값,값,값.....)
*/
--부서코드가 D6이거나 또는 D8이거나 또는 D5인 사원들의 이름,부서코드,급여 조회
SELECT EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
--WHERE DEPT_CODE ='D6' OR DEPT_CODE = 'D8' OR DEPT_CODE = 'D5';
WHERE DEPT_CODE IN ('D6','D8','D5');

--직급코드가 J1이거나 J3이거나 j4인 사원들 모든 컬럼 조회
--그 외 사원 조회
SELECT *
FROM EMPLOYEE
WHERE JOB_CODE IN ('J1','J3','J4');

--그외 사원 조회
SELECT *
FROM EMPLOYEE
WHERE NOT JOB_CODE IN ('J1','J3','J4');

/*
	<연결 연산자 ||>
	여러 컬럼값을 마치 하나의 컬럼처럼 연결시켜주는 연산자
	컬럼과 리터럴(임의의 문자열)을 연결할 수 있다.
*/
SELECT EMP_ID||EMP_NAME||SALARY AS "연결 완료"
FROM EMPLOYEE;

--XX번 XXX의 월급은 XXXX원 입니다.
SELECT EMP_ID||'번'||EMP_NAME||'의 월급은'||SALARY||'원 입니다.' AS "급여정보"
FROM EMPLOYEE;

/*
	<연산자 우선순위>
	1. ( )
	2. 산술연산자
	3. 연결연산자
	4. 비교연산자
	5. IS NULL, LIKE, IN
	6. BETWEEN AND
	7. NOT
	8. AND (논리)
	9. OR (논리)
*/
-------------------------------------------------------------------
/*
	정렬
	<ORDER BY 절>
	SELECT문 가장 마지막에 기입하는 구문뿐만 아니라 마지막에 실행되는 구문이다.
	최종 조회된 결과물들에 대해서 정렬 기준을 세워주는 구문

	[표현법]
	SELECT 조회할 컬럼1, 컬럼2...
	FROM 조회할 대상 테이블
	WHERE 조건절
	ORDER BY [정렬기준으로 세우고자하는 컬럼명/별칭/컬럼순번] [ASC/DESC] [NULLS FIRST/NULLS LAST] (생략가능)

	오름차순/내림차순
	-ASC: 오름차순(생략시 기본)
	-DESC: 내림차순
	
	정렬하고자 하는 컬럼값에 NULL이 있을 경우
	-NULLS FIRST: NULL 값들을 앞으로 배치시키겠다(내림차순 정렬일 경우 기본값)
	-NULLS LAST: NULL 값들을 뒤로 배치하겠다. (오름차순 정렬일 경우 기본값)

*/

--월급이 높은 사람들부터 나열하기(내림차순)
SELECT*
FROM EMPLOYEE
ORDER BY SALARY DESC;

--월급 오름 차순
SELECT *
FROM EMPLOYEE
ORDER BY SALARY; --ASC 기본값이라 생략 가능

--보너스 기분 정렬
SELECT *
FROM EMPLOYEE
--ORDER BY BONUS; --ASC, NULLS LAST 기본값으로 설정됨
--ORDER BY BONUS DESC; --NULLS FIRST가 적용
ORDER BY BONUS DESC,SALARY ASC; --첫 번째로 제시한 정렬기준의 컬럼값이 일치할 경우 두 번째 정렬 기준을 가지고 정렬시킬 수 있다.

--연봉 기준
SELECT EMP_NAME, SALARY, (SALARY*12) "연봉",HIRE_DATE
FROM EMPLOYEE
--ORDER BY "연봉" DESC; --병칭 사용 가능
--ORDER BY (SALARY*12) DESC;
--ORDER BY 3 ASC; --컬럼 순번 정렬
--ORDER BY 1; --문자열도 정렬가능
ORDER BY HIRE_DATE; --날짜도 정렬가능


