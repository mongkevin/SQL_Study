/*
    DDL(DATA DEFINITION LANGUAGE)
    데이터 정의 언어
    객체들을 새롭게 생성(CREATE)하고, 수정(ALTER)하고, 삭제(DROP)하는 구문
    
    1.ALTER
    객체 구조를 수정하는 구문
    
    <테이블수정>
    [표현법]
    ALTER TABLE 테이블명 수정할 내용
    
    -수정할 내용
    1)컬럼추가/수정/삭제
    2)제약조건 추가/수정/삭제
    3)테이블명/컬럼명/제약조건명 수정
    
    1)컬럼 추가 / 수정 / 삭제
    1_1) 컬럼추가 (ADD): ADD 추가할 컬럼명 자료형 DEFAUL기본값(생략가능)
*/

SELECT* FROM DEPT_COPY;

--CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR(20);

--새로운 컬럼이 추가되고 기본적으로 NULL값으로 채워진다.

--LNAME 컬럼 DEFAULT 지정 후 추가하기
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';

--1_2) 컬럼 수정 (MODIFY)
--컬럼의 자료형 수정: MODIFY 수정할 컬럼명 바꾸고자하는 자료형
--DEFAULT 값 수정: MODIFY 수정할 컬럼명 DEFAULT 바꾸고자하는 값

--DEPT_COPY테이블의 DEPT_ID컬럼 자료형을 CHAR(3)으로 변경해보기
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3); 

--NUMBER타입으로 변경해보기
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER; --수정이 불가능
--현재 변경하고자 하는 컬럼에 이미 담겨있는 값과 완전히 다른 타입으로는 변경 불가

--DEPT_ID 컬럼 크기를 1로 바꿔보자
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(1); --수정이 불가능
--기본에 들어있던 값보다 작은 수치로는 변경 불가능
--문자 -> 숫자 (변경불가) / 문자열 사이즈 축소불가 / 문자열 사이즈 확대 가능

--여러개의 컬럼 변경
--DEPT_TITLE컬럼의 데이터타입을 VARCHAR2(40)으로 
--LOCATION_ID컬럼의 데이터탑입을 VARCHAR2(2)로 
--LNAME컬럼의 기본값을 '미국'으로 변경해보세요
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE VARCHAR2(40)
MODIFY LOCATION_D VARCHAR2(2)
MODIFY LNAME DEFAULT '미국';

--1_3) 컬럼 삭제(DROP COLUMN): DROP COLUMN 삭제하고자 하는 컬럼명
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY; --테스트용 테이블 카피

--DEPT_ID 컬럼을 지워보자
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;
--나머지 컬럼 전부 지워보기

ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
--마지막 컬럼 삭제를 하려하면 오류가 발생: 테이블에 최소한 하나의 컬럼은 있어야 하기 때문.

--2) 제약조건 추가 / 삭제
/*
    2_2) 제약조건 추가
    -PRIMARY KEY: ADD PRIMARY KEY(컬럼명);
    -FOREIGH KEY: ADD FOREIGN KEY(컬럼명) REFERENCES 참조테이블명(참조컬럼명)
                    -> 참조컬럼명은 생략가능
    -UNIQUE: ADD UNIQUE(컬럼명)
    -CHECK: ADD CHECK (컬러에 대한 조건)
    -NOT NULL: MODIFY 컬럼명 NOT NULL;
    
    나만의 제약조건을 부여하고자 한다면?
    CONSTRAINT 제약조건명 앞에 붙이기

*/

--DEPT_COPY테이블에 DEPT_ID컬럼에 PRIMARY KEY 제약조건,
ALTER TABLE DEPT_COPY 
ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID)
--DEPT_TITLE컬럼에 UNIQUE제약조건
ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE)
--LNAME 컬럼에 NOT NULL 제약조건 추가해보기
MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;


/*
    2-2)제약조건 삭제
    
    PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK: DROP CONSTRAINT 제약조건명;
    NOT NULL: MODIFY 컬럼명 NULL;
*/
--DEPT_COPY 테이블로부터 DCOPY_PK 제약조건 지우기
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;
--DEPT_COPY 테이블로부터 DCOPY_UQ, DCOPY_NN 지우기
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_UQ;
ALTER TABLE DEPT_COPY MODIFY LNAME NULL;

--3) 컬럼명 / 제약조건명 / 테이블명 변경(RENAME)

--3_1)컬럼명 변경: RENAME COLUMN 기존컬러명 TO 바꿀컬럼명
--DEPT_COPY 테이블에서 DEPT_TITLE 컬럼을 DEPT_NAME으로 변경하기 
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

--DEPT_ID 컬럼을 DEPT_NO 컬럼으로 변경
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_ID TO DEPT_NO;

--3_2)제약조건명 변경: RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명
--DEPT_COPY에서 sys_c0029241를 DCOPY_NN로 변경
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C0029241 TO DCOPY_NN;

--3_3)테이블명 변경: RENAME TO 바꿀테이블
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;

SELECT* FROM DEPT_COPY; --변경되어 더 이상 조회할 수 없다

---------------------------------------------
/*
    2.DROP 
    객체 삭제 구문
    [표현]
    DROP 객체 객체명;
    
    DROP TABLE 테이블명;
*/
--EMP_NEW2라는 테이블 삭제하기
DROP TABLE EMP_NEW2;

--부모테이블을 삭제하는 경우
--DEPT_TEST 테이블에 DEPT_NO 컬럼을 PRIMARY KEY 제약조건 추가
ALTER TABLE DEPT_TEST
ADD CONSTRAINT DCOPY_PY PRIMARY KEY(DEPT_NO);

--EMPLOYEE_COPY3에 외래키(DEPT_CODE) 추가하기 외래키 이름은 ECOPY_FK
--DEPT_TEST 테이블의 DEPT_NO 컬럼 참조하기 
ALTER TABLE EMPLOYEE_COPY3
ADD CONSTRAINT ECOPY_FK FOREIGN KEY(DEPT_CODE) REFERENCES DEPT_TEST(DEPT_NO);

-- 참조테이블 연결한 뒤 부모테이블 삭제해보기
DROP TABLE DEPT_TEST; --삭제 불가 
--어딘사에서 참조되고 있는 부모테이블은 삭제되지 않는다.
--만약 부모테이블을 삭제하고자 한다면
--방법1) 부모테이블을 참조하고 있는 자식 테이블 먼저 삭제 후 부모테이블 삭제
--방법2) 부모테이블만 삭제하면서 외래키 제약조건까지 삭제하기
--DROP TABLE 부모테이블 CASCADE CONSTRAINT
DROP TABLE DEPT_TEST CASCADE CONSTRAINT;
DROP TABLE DEPT_TEST CASCADE CONSTRAINT;











