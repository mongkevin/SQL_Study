/*
    <PL/SQL>
    PROCEDURE LANGUAGE EXTENSION TO SQL
    
    오라클 자체에 내장되어 있는 절차적 언어
    SQL문장 내에서 변수의 정의, 조건처리(IF), 반복문처리(LOOP,FOR,WHILE), 예외처리등을 지원하며 SQL문 단점을 보안
    다수의 SQL문을 한번에 실행가능.
    
    PL/SQL문의 구조
    -[선언부(DECLARE SECTION)]: DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분
    -[실행부(EXCUTABLE SECTION)]: BEGIN으로 시작, SQL문 또는 제어문 등의 로직을 기술하기 위한 부분
    -[예외처리부(EXCEPTION SECTION)]: EXCEPTIO으로 시작, 예외발생 시 해결하기 위한 구문을 기술하는 부분 

*/

--화면에 HELLO ORACLE 출력해보기
--1)서버 아웃풋 옵션 켜기
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/

/*
    1.DECLARE 선언부
    변수나 상수를 선언하는 공간(선언과 동시에 초기화도 가능)
    일반타입 변수, 레퍼런스 변수, ROW타입 변수
    
    1_1)일반 타입 변수 선언 및 초기화
    [표현식] 변수명 [CONSTANT] 자료형[:=값];
*/

DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
--    EID := 777;
--    ENAME := '김철수';
    EID := &번호;
    ENAME := '&이름'; --문자열은 ''을 넣어줘야한다
    --&: 값을 입력받는 프롬프트창이 나온다 입력한 값 자체가 해당 위치에 대입되기 때문에
    --   만약 문자열일시에는 ''로 감싸주어야 한다. 숫자는 상관없음
    
    DBMS_OUTPUT.PUT_LINE('EID: ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME: ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI: ' || PI);
END;
/

--이름 나이 성별을 입력받아서 출력해보세요
DECLARE
    ENAME VARCHAR2(20);
    EAGE NUMBER;
    EGENDER CHAR(3);
BEGIN
    ENAME := '&이름';
    EAGE := &나이;
    EGENDER := '&성별';
    
    DBMS_OUTPUT.PUT_LINE('ENAME: ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('EAGE: ' || EAGE);
    DBMS_OUTPUT.PUT_LINE('EGENDER: ' || EGENDER);
END;
/
--END; 아래에 / (블록의 종결): 위치를 지키고 옆에 주석을 달면 오류가 발생한다 형식 지켜주기

/*
    1_2)레퍼런스 타입 변수 선언 및 초기화(어떤 테이블의 어떤 컬럼의 데이터 타입을 참조하여 해당 타입으로 지정하겠다.)
    [표현식] 변수명 테이블명.컬럼명%TYPE;
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    EID := '300';
    ENAME := '김철수';
    SAL := 3000000;
    
    --사원의 사번이 200번인 사원의 사번, 이름, 급여를 대입해보자
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('EID: '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME: '||ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL: '||SAL);
END;
/

-----------실습 문제------------
/*
    레퍼런스 타입 변수로 EID,ENAME,JCODE,SAL,DTITLE을 선언하고
    각 자료형은 EMPLOYEE에 (EMP_ID. EMP_NAME, JOB_CODE, SALARY) DEPARTMENT의 DEPT_TITLE을 참조하고
    
    사용자가 입력한 사번의 사번, 사원명, 직급코드, 급여, 부서명 조회 후 변수에 담아 출력해보세요
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('EID: '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME: '||ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE: '||JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL: '||SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE: '||DTITLE);
END;
/

-----------------------------------
/*
    1_3)ROW타입 변수 선언
    테이블의 한 행에 대한 모든 컬럼값을 담을 수 있는 변수
    [표현식] 변수명 테이블명%ROWTYPE
*/
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('사원명: '||E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여: '||E.SALARY);
--    BDMS_OUTPUT.PUT_LINE('사원명: '||E.BONUS); --214번 사원을 조회했더니 보너스가 빈값이 나옴
    --NVL함수를 사용하여 없을땐 0으로 표시하게 작성
    DBMS_OUTPUT.PUT_LINE('보너스: '||NVL(E.BONUS,0));
  
END;
/

-------DEPARTEMENT 테이블을 ROW타입 변수로 설정한 뒤 출력해보기-------
DECLARE
    D DEPARTMENT%ROWTYPE;
BEGIN
    SELECT *
    INTO D
    FROM DEPARTMENT
    WHERE DEPT_ID = 'D1';
    --단일행만 가능하다.
    
    DBMS_OUTPUT.PUT_LINE('DEPT_ID: '||D.DEPT_ID);
    DBMS_OUTPUT.PUT_LINE('DEPT_TITLE: '||D.DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('LOCATION_ID: '||D.LOCATION_ID);
END;
/

---------실습-----------
/*
    VW_PLSQL 이름을 가진 VIEW를 생성하고
    컬럼은 사원명, 부서명, 직급명을 조회하는 구문으로 생성할 것
    
    해당 뷰를 이용하여 ROWTYPE 설정 후 사번을 입력받아 조회하는 구문을 작성하시오 
*/
CREATE VIEW VW_PLSQL (사원명, 부서명, 직급명)
AS SELECT EMP_NAME, NVL(DEPT_TITLE,'부서 없음'), JOB_NAME
   FROM EMPLOYEE
   LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
   LEFT JOIN JOB USING (JOB_CODE);

DROP VIEW VW_PLSQL;
DECLARE
    E VW_PLSQL%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM VW_PLSQL
    WHERE 사원명 = (SELECT EMP_NAME
                   FROM EMPLOYEE
                   WHERE EMP_ID='&사번');
    
    DBMS_OUTPUT.PUT_LINE('EMP_NAME: '||E.사원명);
    DBMS_OUTPUT.PUT_LINE('DEPT_TITLE: '||E.부서명);
    DBMS_OUTPUT.PUT_LINE('JOB_NAME: '||E.직급명);
END;
/

------------------------------------------------
--2.BEGIN 실행부
/*
    <조건문>
    
    1)IF 조건식 THEN 실행내용
    
    사번 입력받은 후 해당 사원의 사번, 이름, 급여, 보너스를 출력
    단, 보너스를 받지 않는 사원은 보너스 출력전 '보너스를 지급받지 않는 사원입니다'를 출력
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('사번: '||EID);
    DBMS_OUTPUT.PUT_LINE('이름: '||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여: '||SAL);
    
    IF BONUS=0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF; --IF문 끝났다라는 것을 명시
    
    DBMS_OUTPUT.PUT_LINE('보너스: '||BONUS);
END;
/

--2)IF 조건식 THEN 실행내용 ELSE 실행내용 END IF; (IF-ELSE)
--위의 상황에 보너스를 받지 않는 사원은 보너스율을 출력하지 않게 작성해보세요.

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('사번: '||EID);
    DBMS_OUTPUT.PUT_LINE('이름: '||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여: '||SAL);
    
    IF BONUS=0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('보너스: '||BONUS);
    END IF; --IF문 끝났다라는 것을 명시
    
END;
/

------------------실습 문제----------------------
--레퍼런스타입변수(EID, ENAME, DTITLE, NCODE), 일반타입변수 TEAM VARCHAR2(10)
--참조할 컬럼(EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE)
--사용자가 입력한 사원의 사번에 대한 사번, 이름, 부서명, 근무국가 코드 조회 후 변수 대입
--NCODE의 값이 KO일 경우 TEAM에 한국팀 대입 아닐경우 해외팀 대입하여
--사번, 이름, 부서, 소속(TEAM)을 출력해보세요

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE KH.NATIONAL.NATIONAL_CODE%TYPE;
    --NATIONAL: 데이터 형식 지정 예약어
    TEAM VARCHAR2(10);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING (NATIONAL_CODE)
    WHERE EMP_ID = '&사번';
    
    IF NCODE ='KO'
        THEN TEAM := '한국팀';
    ELSE
        TEAM := '해외팀';
    END IF;
    --사번, 이름, 부서, 소속 출력
    DBMS_OUTPUT.PUT_LINE('사번: '||EID);
    DBMS_OUTPUT.PUT_LINE('이름: '||ENAME);
    DBMS_OUTPUT.PUT_LINE('부서: '||DTITLE);
    DBMS_OUTPUT.PUT_LINE('부서: '||TEAM);
END;
/

-------------------------------------------------
/*
    사원의 사번을 입력받아 사원명, 부서명, 지역명, 국가명을 조회하는 VIEW
    ROWTYPE 변수에 담고
    일반타입변수 SAYHI(VARCHAR2(20))을 만들고
    입력한 사원의 국가에 따라서 ㅇㅇㅇ 사원님 ㅇㅇㅇ하세요 라는 인사말을 넣어보세요
    
    출력형태 ㅇㅇㅇ사원님 ㅇㅇㅇ(인사말)
*/
CREATE OR REPLACE VIEW VW_EMPLOYEE
AS SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
   FROM EMPLOYEE
   JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
   JOIN LOCATION ON(LOCATION_ID=LOCAL_CODE)
   JOIN KH.NATIONAL USING(NATIONAL_CODE);

DECLARE
    E VW_EMPLOYEE%ROWTYPE; 
    SAYHI VARCHAR2(20);
BEGIN
    SELECT *
    INTO E
    FROM VW_EMPLOYEE
    WHERE EMP_NAME = (SELECT EMP_NAME
                      FROM EMPLOYEE
                      WHERE EMP_ID = '&사번');
    
    IF E.NATIONAL_NAME= '한국'        
        THEN SAYHI := '안녕하세요';
    ELSIF E.NATIONAL_NAME ='중국'
        THEN SAYHI := '니하오';
    ELSIF E.NATIONAL_NAME ='러시아'
        THEN SAYHI := '프리비에';
    ELSIF E.NATIONAL_NAME ='일본'
        THEN SAYHI := '곤니찌와';
    ELSE
        SAYHI := 'HI';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(E.EMP_NAME||'사원님 '||SAYHI);
END;
/

--3) IF 조건식1 THEN 실행내용1 ELSIF 조건식2 THEN 실행내용2.... ELSE END IF;
/*
    레퍼런스 변수로 SAL, ENAME 설정 일반타입 변수로 GRADE VARCHAR2(10)설정
    사번을 입력받아 해당 사원의 급여등급을 측정하시오
    급여가 500만원 이상이면 고급
    300만원 이상이면 중급
    그외는 초급을 GRADE에 담아
    출력문: 해당사원의 급여등급은 xx입니다. 를 작성하시오 
*/

DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT SALARY, EMP_NAME
    INTO SAL, ENAME
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
                      
    IF SAL >= 5000000
        THEN GRADE := '고급';
    ELSIF SAL >= 3000000
        THEN GRADE := '중급';
    ELSE
        GRADE := '초급';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여등급은'||GRADE||' 입니다.');
END;
/

-------------------------------------------
/*
    <반복문>
    
    1)BASIC LOOP문
    [표현식]
    LOOP
        반복적으로 실행할 구문;
        *반복문을 빠져나가는 구문
    END LOOP;
    
    *반복문을 빠져나가는 구문 2가지
    1) IF 조건식 THEN EXIT; END IF;
    2) EXIT WHEN 조건식;

*/

--1~5까지 순차적으로 1씩 증가하는 값을 출력
DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
        
        --방법 1) IF문 사용
--        IF I = 6 
--            THEN EXIT; 
--        END IF;
        
        --방법 2) EXIT WHEN 사용
        EXIT WHEN I = 6;
    END LOOP;
END;
/

----------------------------------------------
/*
    2)FOR LOOP문
    [표현법]
    FOR 변수 IN 초기값.. 최종값 
    LOOP
        반복적으로 실행할 구문;
    END LOOP;
*/
--FOR LOOP에서 변수 선언 가능

BEGIN
    FOR I IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

BEGIN 
    FOR I IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

--연습문제--
/*
    TNO와 TDATE를 NUMBER와 DATE자료형을 지정하고 TEST 테이블을 생성하여
    SEQ_TNO라는 시퀀스를 생성하여 시작값 1 증가값2 최대값 1000 순환없이 캐시없이 진행 
    
    TEST테이블에 INSERT를 100번 진행하시오 이때 TNO에는 시퀀스를 뽑아넣고 TDATE에는 SYSDATE를 넣으시오 
*/

CREATE TABLE TEST(
    TNO NUMBER PRIMARY KEY, --시퀀스를 사용시 PRIMARY KEY를 일반적으로 쓴다
    TDATE DATE
);

CREATE SEQUENCE SEQ_TNO
START WITH 1
INCREMENT BY 2
MAXVALUE 1000
NOCYCLE
NOCACHE;

BEGIN
    FOR I IN 1..100
    LOOP
        INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL,SYSDATE);
    END LOOP;
END;
/

SELECT * FROM TEST;

---------------------------------------------------
/*
    3) WHILE LOOP문
    [표현식]
    WHILE 반복문수행조건 
    LOOP
        반복적으로 실행할 구문;
    END LOOP;
*/

DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I < 6
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I+1;
    END LOOP;
END;
/

------------------------------------------------
/*
    3.예외처리부
    
    예외(EXCEPTION): 실행중 발생하는 오류
    
    [표현식]
    EXCEPTION
        WHEN 예외명1 THEN 예외처리구문1;
        WHEN 예외명2 THEN 예외처리구문2;
        ....
        WHEN OTHERS THEN 예외처리구문N;
        
        *시스템 예외 (오라클에서 미리 정의해둔 예외)
        -NO_DATE_FOUND: SELECT한 결과가 한 행도 없을 경우
        -TOO_MANY_ROWS: SELECT한 결과가 여러행일 경우
        -ZERO_DIVIDE: 0으로 나눌때 발생
        -DUP_VAL_ON_INDEX: UNIQUE 제약 조건 위배경우
        ....등등 
*/
--사용자가 입력한 수로 나눗셈 연산한 결과 출력
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10/ &숫자;
    DBMS_OUTPUT.PUT_LINE('결과: '||RESULT);
END;
/
--01476. 00000 -  "divisor is equal to zero"

--예외처리해보기
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10/ &숫자;
    DBMS_OUTPUT.PUT_LINE('결과: '||RESULT);
EXCEPTION
--    WHEN ZERO_DIVIDE 
--        THEN DBMS_OUTPUT.PUT_LINE('나누기 연산 시 0으로 나눌수 없습니다.');
    WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE('나누기 연산 시 0으로 나눌수 없습니다.');
END;
/

--UNIQUE 제약조건 위배 (노옹철 사원의 사번 수정하기)
--노옹철 사원의 사번을 200번으로 수정하는 구문을 작성하시오
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = '&변결할사번'
    WHERE EMP_NAME = '노옹철';
EXCEPTION
--    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사원입니다.');
    WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE('나누기 연산 시 0으로 나눌수 없습니다.');
END;
/
--00001. 00000 -  "unique constraint (%s.%s) violated"

--사원 정보 조회하여 변수에 담을때 여러행이 조회되면 발생하는 예외
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EID, ENAME
    FROM EMPLOYEE
    WHERE MANAGER_ID = '&사수사번';
    
    DBMS_OUTPUT.PUT_LINE('사번: '||EID);
    DBMS_OUTPUT.PUT_LINE('이름: '||ENAME);
EXCEPTION
    WHEN TOO_MANY_ROWS 
        THEN DBMS_OUTPUT.PUT_LINE('너무 많은 행이 조회되었습니다.');
    WHEN NO_DATA_FOUND 
        THEN DBMS_OUTPUT.PUT_LINE('해당 사수사번에 해당하는 조회결과가 없습니다.');
END;
/
--01422. 00000 -  "exact fetch returns more than requested number of rows" 






