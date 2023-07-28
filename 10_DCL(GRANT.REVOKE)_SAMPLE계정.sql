--3_1
--테이블 생성해보기 
CREATE TABLE TEST(
    TEST_ID NUMBER
); --권한이 불충분합니다
--불충분한 권한: SAMPLE계정에 테이블 생성 권한을 주지 않았기 때문에

--3_2
--CREATE TABLE 권한 부여받고 테이블 생성해보기
CREATE TABLE TEST(
    TEST_ID NUMBER
);
--TABLESPACE: 테이블 생성 공간
--SAMPLE 계정에 TABLESPACE가 할당되지 않았기 때문에 오류발생 

--3_3 TABLESPACE 할당 받은 뒤에 테이블 생성 
CREATE TABLE TEST(
   TEST_ID NUMBER
);

--테이블 생성권한을 부여받으면 조작(DML)도 가능하다
INSERT INTO TEST VALUES(1);
SELECT * FROM TEST;

--4.뷰 생성해보기
CREATE VIEW V_TEST
AS SELECT * FROM TEST; --불충분한 권한

--4_2. CREATE VIEW 권한 부여 받고 뷰 생성해보기
CREATE VIEW V_TEST
AS SELECT * FROM TEST;

SELECT * FROM TEST;

--5. SAMPLE계정에서 KH 계정 테이블을 접근하여 조회해보기 
SELECT *
FROM KH.EMPLOYEE; --00942. 00000 -  "table or view does not exist"
--접근권한이 없기 때문에 테이블을 찾을 수 없음

--5_1. SAMPLE계정에서 KH.EMPLOYEE 테이블 SELECT 권한 부여받고 조회해보기 
SELECT *
FROM KH.EMPLOYEE;

--6.SAMPLE 계정에서 KH.DEPARTMENT 테이블에 데이터 삽입해보기
SELECT* FROM KH.DEPARTMENT;
INSERT INTO KH.DEPARTMENT VALUES('D0','회계부','L2'); --테이블이 없다는 오류

--6_1. SAMPLE 계정에 KH.DEPARTMENT 테이블에 INSERT 권한 부여받고 데이터 삽입하기
INSERT INTO KH.DEPARTMENT VALUES('D0','회계부','L2'); --INSERT 성공 
COMMIT;

--7. SAMPLE계정에 CREATE TABLE 권한 회수한 뒤 테이블 생성해보기 
CREATE TABLE TEST2(
    TEST_NO NUMBER
); --01031. 00000 -  "insufficient privileges"
--권한을 회수당했기 때문에 생성할 수 없다. 









