/*
    <PROCEDURE>
    PL/SQL 구문을 저장하여 이용하는 객체
    필요할때마다 내가 작성한 PL/SQL문을 편하게 호출 가능하다.
    
    생성방법
    [표현법]
    CREATE [OR REPLACE] PROCEDURE 프로시저명[(매개변수)]
    IS
    BEGIN
        실행부분
    END;
    /
    
    실행방법
    EXEC 프로시저명;
*/

--EMPLOYEE테이블을 복사한 COPY테이블 생성
CREATE TABLE PRO_TEST
AS SELECT* FROM EMPLOYEE;

SELECT* FROM EMPLOYEE;

--프로시저 생성
CREATE OR REPLACE PROCEDURE DEL_DATA
IS
--지역변수 선언 
BEGIN
    DELETE FROM PRO_TEST;
    --COMMIT;
END;
/

--생성된 프로시저 조회
SELECT * FROM USER_PROCEDURES;
--실행해보기
EXEC DEL_DATA;

SELECT* FROM PRO_TEST;

----------------------
/*
    매개변수 선언하여 사용하는 프로시져
    IN: 프로시져 실행시 필요한 값을 받는 변수(자바 매개변수와 동일)
    OUT: 호출한 곳으로 되돌려주는 변수(결과값)
*/
CREATE OR REPLACE PROCEDURE PRO_SELECT_EMP(V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
                                           V_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
                                           V_SALARY OUT EMPLOYEE.SALARY%TYPE,
                                           V_BONUS OUT EMPLOYEE.BONUS%TYPE)
IS
BEGIN
    SELECT EMP_NAME, SALARY, BONUS
    INTO V_EMP_NAME,V_SALARY,V_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
END;
/

--매개변수가 있는 프로시져 실행 후 전달 값 받을 변수 선언
VAR EMP_NAME VARCHAR2(20);
VAR SALARY NUMBER;
VAR BONUS NUMBER;

EXEC PRO_SELECT_EMP(210,:EMP_NAME,:SALARY,:BONUS);

PRINT EMP_NAME;
PRINT SALARY;
PRINT BONUS;

/*
    프로시져 장점
    1.처리속도가 빠르다
    2.대량 자료처리시 효율좋음
    ex)DB에서 대용량의 데이터를 SELECT문으로 받아와서 자바에서 처리하는 경우 VS
       DB에서 "대용량데이터"를 SELECT한 후 자바로 넘기지 않고 직접 처리하는 경우
       위 상황 중 DB에서 처리하는게 성능이 더 좋음(데이터를 자바로 넘길때마다 네트워크비용이 발생하기 때문)
       
    프로시져 단점
    1.DB자원을 직접 사용하기 때문에 DB에 부하를 주게된다(남용하면 안됨)
    2.관리적인 측면에서 자바소스코드, 오라클 코드 동시에 형상관리하기 어렵다.
*/
-----------------------------------------
/*
    <FUNCTION>
    프로시져와 유사하지만 실행결과를 반환 받을 수 있다.
    
    FUNCTION 생성방법
    [표현식]
    CREATE [OR REPLACE] FUNCTION 펑션명[(매개변수)]
    RETURN 자료형
    IS
    BEGIN
        실행부
    END;
    /
    
    FUNCTION 실행방법
    펑션이름(인수);
*/

CREATE OR REPLACE FUNCTION MYFUNC(V_STR VARCHAR2)
RETURN VARCHAR2
IS
    RESULT VARCHAR2(1000);
BEGIN
    DBMS_OUTPUT.PUT_LINE(V_STR);
    RESULT := V_STR||'추가';
    RETURN RESULT;
END;
/

SELECT MYFUNC('사리') FROM DUAL;

--EMP_ID를 전달받아 연봉을 계산하여 출력해주는 함수 만들기
--EMPLOYEE ROWTYPE으로 설정하여 조회결과 부여하고
--일반변수 RESULT NUMBER; 설정 후 연봉계산 후 대입하여 리턴해서
--SELECT EMP_ID, 생성한 함수 형식으로 조회해보기

CREATE OR REPLACE FUNCTION CALC_SALARY(V_EMP_ID EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
    E EMPLOYEE%ROWTYPE;
    RESULT NUMBER;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
    RESULT := ((E.SALARY+(E.SALARY*NVL(E.BONUS,0)))*12);
    RETURN RESULT;
END;
/

SELECT EMP_ID, CALC_SALARY(EMP_ID)
FROM EMPLOYEE;


