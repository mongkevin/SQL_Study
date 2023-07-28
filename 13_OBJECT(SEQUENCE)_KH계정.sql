/*
    <시퀀스 SEQUENCEE>
    자동으로 번호를 발생시켜주는 역할을 하는 객체
    정수 값을 자동으로 순차적으로 발생시킨다 (연속된 숫자)
    
    EX)주차번호, 회원번호, 사번, 게시글 번호 등등
       순차적으로 겹치지 않는 숫자를 이용할때 시퀀스를 사용한다/
       
       1. 시퀀스 객체 생성 구문
       
       [표현법]
       CREATE SEQUENCE 시퀀스명
       START WITH 시작 숫자      -생략 가능, 처음 발생시킬 시작값 지정
       INCREMENT BY 증가값      -생략 가능, 한번 시퀀스가 증가할때마다 몇 씩 증가시킬것인지 지정
       MAXVALUE                -생략 가능, 최대값 지정 
       MINVALUE                -생략 가능, 최소값 지정
       CYCLE/NOCYCLE           -생략 가능, 값의 순환여부를 결정
       CACHE 바이트 크기/NOCACHE  -생략 가능, 캐시메모리 여부 지정 CACHE_SIZE의 기본값은 20 BYTE
       
       *캐시메모리
       시퀀스로부터 미리 발생될 값들을 생성하여 저장해두는 공간
       매번 호출할때마다 시퀀스번호를 생성하는 것보다
       캐시메모리 공간에 미리 생성된 값들을 가져다 쓰게 되면 속도가 빠르다
       단, 접속이 끊기고 나서 재접속을 하게되면 기존에 생성되어있던 값이 사라지고 그 다음값부터 뽑히게 된다. 
*/
CREATE SEQUENCE SEQ_TEST;

--현재 접속한 계정이 소유하고 있는 시퀀스에 대한 정보 조회용 데이터 딕셔너리
SELECT * FROM USER_SEQUENCES;

--옵션 부여하면서 생성해보기
CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

/*
    2.시퀀스 사용 구문
    
    시퀀스명.CURRVAL: 현재 시퀀스값 (마지막으로 성공적으로 발생된 NEXTVAL의 값)
    시퀀스명.NEXTVAL: 현재 시퀀스의 값을 증가시키고, 그 증가된 값
                    --시퀀스명.CURRVAL + INCREMENT BY
                    
    단, 시퀀스 생성 후 첫 NEXTVAL은 START WITH로 지정된 시작값으로 발생한다.
    때문에 시퀀스 생성 후 NEXTVAL이 실행되지 않은 시점에선 CURRVAL을 수행할 수 없다.
*/

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; --08002. 00000 -  "sequence %s.CURRVAL is not yet defined in this session"
--시퀀스가 생성되고 나서 NEXTVAL을 한번이라도 수행해야 NEXTVAL을 수행할 수 있다.
--CURRVAL은 마지막으로 수행된 NEXTVAL의 값을 저장하여 보여주는 임시값이기 때문 
--첫수행
SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; --300
--NEXTVAL이 수행되었기 때문에 조회 가능
SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; --300

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; --305

SELECT * FROM USER_SEQUENCES; --LAST_NUMBER: 310
--LAST_NUMBER: 현재 값에서 다음 NEXTVAL이 수행된 예정값

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; --310
--오류: ORA-08004: 시퀀스 SEQ_EMPNO.NEXTVAL exceeds MAXVALUE은 사례로 될 수 없습니다
--지정한 MAXVALUE 값을 초과하여 오류발생

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; --310 마지막으로 성공적으로 실행된 NEXTVAL의 값을 가지고 있다.

/*
    3.시퀀스 변경
    [표현법]
    ALTER SEQUENCE 시퀀스명
    INCREMENT BY 증가값      -생략 가능, 한번 시퀀스가 증가할때마다 몇 씩 증가시킬것인지 지정
    MAXVALUE                -생략 가능, 최대값 지정 
    MINVALUE                -생략 가능, 최소값 지정
    CYCLE/NOCYCLE           -생략 가능, 값의 순환여부를 결정
    CACHE 바이트 크기/NOCACHE  -생략 가능, 캐시메모리 여부 지정 CACHE_SIZE의 기본값은 20 BYTE
    
    -START WITH는 변경 불가 ( 변경하고 싶다면 삭제 후 재생성을 하여야한다)
*/
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; --310

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; --320

--SEQUENCE 삭제하기
DROP SEQUENCE SEQ_EMPNO;

--매번 새로운 사번이 발생되는 시퀀스를 생성해보세요 (SEQ_EID) 300부터 시작하여 2씩 증가하고 최대값 400
--생성 후 EMPLOYEE에 사원 추가를 해보세요 EMP_ID에 시퀀스를 넣어서 2명
CREATE SEQUENCE SEQ_EID
START WITH 300
INCREMENT BY 2
MAXVALUE 400;

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SAL_LEVEL) 
VALUES(SEQ_EID.NEXTVAL, '김나영', '931025-1885436','J2','S2');

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SAL_LEVEL) 
VALUES(SEQ_EID.NEXTVAL, '박찬영', '910925-1675436','J2','S2');

--이후 진행할 형태
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SAL_LEVEL) 
VALUES(SEQ_EID.NEXTVAL, ?, ?, ?, ?);




