/*
    <GROUP BY 절>
    
    그룹을 묶어줄 기준을 제시할 수 있는 구문 ->그룹함수와 같이 쓰인다.
    해당 제시된 기준별로 그룹을 묶을 수 있다.
    여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
    
    [표현법]
    GROUP BY 묶을 기준 컬럼

*/

--각 부서별로 총 급여의 합계
SELECT DEPT_CODE,SUM(SALARY)
--SELECT SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--'D1'부서의 총 급여 합
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE='D1';

--각 부서별 사원수
SELECT DEPT_CODE,COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--각 부서 별 총 급여합을 부서별로 오름차순정렬하여 조회해보기
SELECT DEPT_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE ASC;

--각 부서 별 총 급여 합을 급여별로 내림차순 정렬하여 조회
SELECT DEPT_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY SUM(SALARY) DESC;

--각 직급별 직급코드,총 급여의 합,사원수,보너스를 받는 사원수,평균 급여,최고 급여,최소급여
SELECT JOB_CODE
      ,SUM(SALARY)
      ,COUNT(*)
      ,COUNT(BONUS)
      ,AVG(SALARY)
      ,MAX(SALARY)
      ,MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;
--각 부서별 부서코드 사원수 보너스를 받는 사원수,사수가 있는 사원수,평균급여 부서별 오름차순 정렬
SELECT DEPT_CODE
      ,COUNT(*)
      ,COUNT(BONUS)
      ,COUNT(MANAGER_ID)
      ,ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

--성별 별 사원 수
--SUBSTR(EMP_NO,8,1)
SELECT DECODE(SUBSTR(EMP_NO,8,1),'1','남자','2','여자') "성별"
      ,COUNT(*) "사원 수"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1);

--성별 기준으로 평균 급여
--CASE WHEN THEN으로 남자 여자 출력
SELECT CASE WHEN SUBSTR(EMP_NO,8,1) = '1' THEN '남자'
            WHEN SUBSTR(EMP_NO,8,1) = '2' THEN '여자' --ELSE
        END "성별"
        ,ROUND(AVG(SALARY)) "평균 급여"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1);

--각 부서별 평균 급여
SELECT DEPT_CODE,
       ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--각 부서별 평균 급여가 300만원 이상인 부서들만 조회
SELECT DEPT_CODE,
       ROUND(AVG(SALARY))
FROM EMPLOYEE
WHERE AVG(SALARY) >= 3000000
GROUP BY DEPT_CODE; --문법상 그룹함수를 WHERE절에 사용할 수 없다.

/*
    <HAVING 절>
    그룹에 대한 조건을 제시하고자 할때 사용하는 구문
    주로 그룹함수를 가지고 조건 제시
*/
--각 부서별 평균 급여가 300만원 이상인 부서들만 조회
SELECT DEPT_CODE
      ,ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000; --GROUP BY 뒤에 HAVING절 작성

--각 직급별 총 급여합이 1000만원 이상인 직급 코드,급여합을 조회
SELECT JOB_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

--각 직급별 급여 평균이 300만원 이상인 직급코드,평균급여,사원수,최고급여,최소급여 조회
SELECT JOB_CODE
      ,ROUND(AVG(SALARY))
      ,COUNT(*)
      ,MAX(SALARY)
      ,MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING AVG(SALARY) >= 3000000;
       
--각 부서 별 보너스를 받는 사원이 없는 부서만을 조회
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

--각 부서 별 평균 급여가 350만원 이하인 부서만을 조회
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) <= 3500000;

/*
    < SELECT문 구조 및 실행 순서>
    
    5.SELECT 조회하고자 하는 컬럼명들 나열/ * /리터럴/산술연산/함수식/AS별칭 
    1.FROM 조회하고자 하는 테이블명/가상테이블(DUAL)
    2.WHERE 조건식 (그룹함수 X)
    3.GROUP BY 그룹기준에 대한 조건(컬럼명/함수식)
    4.HAVING 그룹함수식에 대한 조건식
    6.ORDER BY [정렬기준에 대한 컬럼명/별칭/순번][ASC/DESC][NULLS FIRST/NULLS LAST]
    
*/

-------------------------------------------------------

/*
    <집합 연산자 SET OPERATOR >
    여러개의 쿼리문을 하나의 쿼리문으로 만드는 연산자.
    
    -UNION (합집합) : 두 쿼리문을 수행한 결과값을 더한 후 중복되는 부분은 한번만 빼서 중복을 제거한것 
    -UNION ALL : 두 쿼리문을 수행한 결과값을 더한 후 중복 제거을 하지 않은것-(합집합1 + 교집합1)
    -INTERSECT (교집합) : 두 쿼리문을 수행한 결과값의 중복된 부분
    -MINUS (차집합) : 선행 쿼리문 결과값에서 후행 쿼리문 결과값을 뺀 나머지 부분
                    -선행 쿼리문 결과값 - 교집합1
        
    주의 : 두 쿼리문의 결과를 합쳐서 한개의 테이블로 보여줘야하기 때문에
          두 쿼리문의 SELECT절 부분은 같아야한다 (동일한 컬럼 조회) 

*/

--1.UNION (합집합) : 두 쿼리문을 수행한 결과값을 더하지만 중복은 제거
--부서코드가 D5이거나 또는 급여가 300만원 초과인 사원들 조회(사번,사원명,부서코드,급여)

--부서코드가 D5인 사원 (6명 - 박나라 하이유 김해술 심봉선 윤은해 대북혼)
SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE='D5';

--급여가 300만원 초과인 사원들 조회 (8명 - 선동일 송종기 노옹철 유재식 정중하 심봉선 대북혼 전지연)
SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

--UNION으로 합치기
SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE='D5'
UNION
SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; --(6명+8명-2명) : 12명
--SELECT절을 일치시켜야한다.

--직급코드가 J6이거나 또는 부서코드가 D1인 사원들을 조회(사번,사원명,부서코드,직급코드)
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE ='J6' OR DEPT_CODE = 'D1'; -- 7명
--OR연산자로 해보고
--직급코드가 J6인 사원 
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE ='J6';--6명
--부서코드가 D1인 사원
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1'; --3명
--UNION으로 해보기 
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE ='J6'
UNION
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1'; --7명

--2.UNION ALL : 여러개의 쿼리 결과를 더해서 보여주는 연산자(중복제거하지 않음)
--직급코드가 J6이거나 또는 부서코드가 D1인 사원들을 조회(사번,사원명,부서코드,직급코드)

--직급코드가 J6
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE 
WHERE JOB_CODE = 'J6'; --6명
--부서코드가 D1
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D1'; --3명

--UNION ALL
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE 
WHERE JOB_CODE = 'J6'
UNION ALL
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D1'; -- 9명

--3.INTERSECT : 교집합, 여러 쿼리결과의 중복된 결과만 조회
--직급코드가 J6이고 부서코드가 D1인 사원들을 조회 
--직급코드가 J6
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE 
WHERE JOB_CODE = 'J6';

--부서코드가 D1
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D1';

--INTERSECT 
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE 
WHERE JOB_CODE = 'J6'
INTERSECT
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D1';--2명(중복만 조회)

--4.MINUS : 차집합,선행쿼리 결과에 후행 쿼리 결과를 뺀 나머지
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE 
WHERE JOB_CODE = 'J6'
MINUS
SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D1';--중복된 2명이 제외되고 4명 조회








