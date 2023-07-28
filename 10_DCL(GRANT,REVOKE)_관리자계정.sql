/*
    DCL (DATE CONTROL LANGUAGE)
    데이터 제어 언어
    
    계정에게 시스템 권한 또는 객체 접근 권한을 부여(GRANT)하거나 회수(REVOKE)하는 언어
    
    -권한부여 (GRANT)
    시스템권한: 특정 DB에 접근하는 권한, 객체들을 생성할 수 있는 권한
    객체 접근 권한: 특정 객체들에 접근해서 조작할 수 있는 권한
    
    -스스템 권한의 종류
    CREATE SESSION: 계정 접속 권한
    CREATE TABLE: 테이블 생성권한 
    CREATE VIEW: 뷰 생성권한 
    CREATE SEQUENCE: 시퀀스 생성 권한
    CREATE USER: 계정 생성 권한 
    ....
    
*/

--1. SAMPLE 계정 생성
CREATE USER SAMPLE IDENTIFIED BY SAMPLE;

--2. SAMPLE 계정에 접속하기 위한 CREATE SESSION 권한 부여
GRANT CREATE SESSION TO SAMPLE;

--3. SAMPLE 계정에 테이블 생성 권한 부여하기 
GRANT CREATE TABLE TO SAMPLE;

--3_2. SAMPLE 계정에 TABLESPACE 활당하기
ALTER USER SAMPLE QUOTA 2M ON SYSTEM;
--QUOTA: 몫, 할당/ 2M: 2MEGA BYTE

--4_1. SAMPLE 계정에 VIEW 생성 권한 부여하기  CREATE VIEW 
GRANT CREATE VIEW TO SAMPLE;

GRANT UNLIMITED TABLESPACE TO DDL; 
/*
    -객체 권한
    특정 객체들을 조작할 수 있는 권한
    조작: SELECT, INSERT, UPDATE, DELETE - DML
    
    [표현법]
    GRANT 권한종류 ON 특정객체 TO 계정명;
    
    권한종류      |      특정객체
    ----------------------------
    SELECT      | TABLE,VIEW,SEQUENCE
    INSERT      | TABLE,VIEW
    UPDATE      | TABLE,VIEW
    DELETE      | TABLE,VIEW

*/

--5.SAMPLE 계정에 KH.EMPLOYEE 테이블을 조회할수 있는 권한을 부여하기 
GRANT SELECT ON KH.EMPLOYEE TO SAMPLE;

--6.SAMPLE 계정에 KH.DEPARTMENT 테이블에 INSERT 할 수 있는 권한 부여하기
GRANT INSERT ON KH.DEPARTMENT TO SAMPLE;

/*
    <롤 ROLE>
    특정 권한들을 하나의 집합으로 모아 놓은 것
    
    CONNECT: CREATE SESSION
    RESOURCE: CREATE TABLE, CREATE SEQUENCE, SELECT, INSERT,...
*/

------------------------------------------------------------------
/*
    *권한 회수 (REVOKE)
    권한을 회수하는 명령어 
    
    [표현법]
    REVOKE 권한1, 권한2,....FROM 계정명;
*/

--7. SAMPLE 계정이 테이블을 생성할 수 없도록 권한 회수 후 SAMPLE계정에서 CREATE 확인해보기
REVOKE CREATE TABLE FROM SAMPLE;

--최소한의 권한을 부여한 계정 USER를 만들어서 접속까지 해보세요
--CONNECT, RESOURCE: 최소한의 권한 ROLE
CREATE USER NOBODY IDENTIFIED BY NOBODY;
GRANT CONNECT, RESOURCE TO NOBODY;
DROP USER NOBODY;










