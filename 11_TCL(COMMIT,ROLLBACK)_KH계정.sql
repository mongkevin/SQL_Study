/*
    TCL(TRANSACTION CONTROL LANGUAGE)
    트랜잭션을 제어하는 언어
    
    *트랜잭션(TRANSACTION)
    -데이터베이스의 논리적 작업 단위
    -데이터의 변경사항(DML)들을 하나의 트랜잭션으로 묶어서 처리
    -COMMIT(확정) 하기 전까지의 변경사항들을 하나의 트랜잭션으로 처리한다
    -트랜잭션의 대상이 되는 SQL: INSERT, UPDATE, DELETE(DML)
    
    *트랜잭션의 종류
    -COMMIT; 진행: 하나의 트랜잭션에 담겨있는 변경상항들을 실제 DB에 반영하겠다는 의미
                  실제 DB에 반영시킨 후 트랜잭션은 비워진다
    -ROLLBACK;  : 하나의 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영하지 않겠다는 의미
                  트랜잭션에 담겨있는 변경사항들도 다 삭제한 뒤 마지막 COMMIT시점으로 돌아간다 
    -SAVEPOINT 포인트명; : 현재 이 시점에 임시저장점을 정의 
    -ROLLBACK TO 포인트명; : 전체 변경사항들을 삭제(마지막 COMMIT)하는 것이 아니라
                           해당 포인트 지점까지만 트랜잭션을 ROLLBACK한다.
*/

-----------------------------------------------------------------
--사번이 200인 사원 삭제
SELECT *
FROM EMPLOYEE
WHERE EMP_ID=200;

DELETE FROM EMPLOYEE
WHERE EMP_ID= 200;

ROLLBACK;

SELECT * FROM EMP_01; --25명

--사번이 900번인 사원과 901번인 사원 삭제 
DELETE FROM EMP_01
WHERE EMP_ID IN (900,901);

--사번이 210번인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 210;

SELECT * FROM EMP_01; --22명

ROLLBACK;

SELECT * FROM EMP_01; --25명

--------------------------------------------------
--사번이 900번인 사원 삭제 
DELETE FROM EMP_01
WHERE EMP_ID = 900;

--사번 800번인 사원을 추가
INSERT INTO EMP_01 VALUES(800,'김상철','인사부');

--서로 다른 DML구문을 실행한 뒤 ROLLBACK 해보기
ROLLBACK; --서로 다른 DML구문이여도 한 트랜잭션에서 처리되기 때문에 ROLLBACK시 전부 돌아온다.

--다시 삭제 및 추가 후 COMMIT; 해보기
COMMIT; -- 확정

SELECT * FROM EMP_01;

ROLLBACK;

-----------------------------------------------------
--EMP_01테이블에 사번이 217,216,214인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (217,216,214);

SELECT * FROM EMP_01; --22명

--3명이 삭제된 시점에서 SAVEPOINT 지정하기
SAVEPOINT SP1; --SAVEPOINT이(가) 생성되었습니다.

--EMP_01 테이블에 사번 801,이름 김영철, 부서 총무부 사원을 추가해보자
INSERT INTO EMP_01 VALUES(801,'김영철','총무부');

--EMP_01 테이블에 사번이 218인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 218;

--202번 삭제 
DELETE FROM EMP_01
WHERE EMP_ID=202;

SELECT* FROM EMP_01; --21명

ROLLBACK TO SP1;

SELECT* FROM EMP_01; --22명

ROLLBACK; --SAVEPOINT 지점이 아닌 그 이전 COMMIT시점으로 돌아감 

--사원 두명 추가하고 1명 삭제 후 SAVEPOINT 지정하고 다시 1명 추가 한뒤 SAVEPOINT 로 롤백해보기
INSERT INTO EMP_01 VALUES(802,'최바보','총무부');
INSERT INTO EMP_01 VALUES(803,'전천재','기술지원부');

DELETE FROM EMP_01
WHERE EMP_ID= 213;

SAVEPOINT SP2;

INSERT INTO EMP_01 VALUES(804,'박진구','해외영업1부');

ROLLBACK TO SP2;















