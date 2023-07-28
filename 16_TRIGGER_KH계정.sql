/*
    <트리커>
    지정한 테이블에 INSERT, UPDATE, DELETE 등의 DML문에 의해 변경사항이 생길때
    자동으로 실행할 내용을 정의해둘 수 있는 객체
    
    ex)
    회원탈퇴시 기존의 회원테이블에서 데이터를 DELETE 또는 UPDATE하여 상태값을 변경하고
    탈퇴한 회원들만 따로 보관하는 테이블에 INSERT처리하기.
    또는 신고횟수가 일정 수를 넘었을때 회원을 블랙리스트 등록되게끔 할수도 있다.
    입출고에 대한 데이터가 기록(INSERT)될때마다 해당 상품에 대한 재고수량을 매번 수정(UPDATE)해야할때
    
    *트리거의 종류
    SQL문의 시행시기에 따른 분류
    -BEFORE TRIGGER: 지정한 테이블에 이벤트(INSERT,UPDATE,DELETE)가 발생되기 전에 트리거 실행
    -AFTER TREIGGER: 지정한 테이블에 이벤트가 발생된 후에 트리거 실행
    
    SQL문에 의해 영향을 받는 각 행에 따른 분류
    -STATEMENT TRIGGER(문장트리거): 이벤트가 발생된 SQL문에 대해 딱 한번만 트리거 실행
    -ROW TRIGGER (행트리거): 해당 SQL문 실행할때마다 매번 트리거 실행 (FOR EACH ROW옵션 설정)
        -: OLD -BEFORE UPDATE(수정전 자료), BEFORE DELETE(삭제전 자료)
        -: NEW -AFTER INSERT(추가된 자료), AFTER UPDATE(수정 후 자료)
        
    *트리거 생성구문
    [표현식]
    CREATE OR REPLACE TRIGGER 트리거명
    BEFORE|AFTER INSERT|DELETE|UPDATE ON 테이블명
    [FOR EACH ROW]
    DECLARE
        변수선언;
    BEGIN
        실행내용(위에 지정된 이벤트 발생시 자동으로 실행할 구문)
    EXCEPTION
        예외처리구문 
    END;
    /
*/
--EMPLOYEE테이블에 새로운 행이 INSERT될때마다 자동으로 메세지 출력하는 트리거
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원님 환영합니다.');
END;
/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, SAL_LEVEL)
VALUES(556,'박상희','000000-2222222','D1','J2','S2');

ROLLBACK;

---------------------------------------------------------------
SET SERVEROUTPUT ON;
---------------------------------------------------------------
--상품 입고 및 출고 관련 예시 
--필요한 테이블 및 시퀀스 생성

--1.상품에 대한 데이터를 보관할 테이블(TB_PRODUCT)
CREATE TABLE TB_PRODUCT(
    PCODE NUMBER PRIMARY KEY, --상품번호
    PNAME VARCHAR2(30) NOT NULL, --상품이름
    BRAND VARCHAR2(30) NOT NULL, --브랜드명
    PRICE NUMBER, --가격 
    STOCK NUMBER DEFAULT 0 --재고수량
);

--2.상품 번호 중복되지 않게 사용할 시퀀스 생성 (SEQ_PCODE)
CREATE SEQUENCE SEQ_PCODE
START WITH 200
INCREMENT BY 5
NOCACHE;

--3. 샘플데이터 추가하기
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL,'갤럭시S23','SAMSUNG',1300000,DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL,'갤럭시Z플립3','SAMSUNG',1500000,10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL,'아이폰15','APPLE',1850000,20);

SELECT * FROM TB_PRODUCT;

COMMIT;

--4.상품 입출고 상세 이력 테이블(TB_PRODETAIL)
--어떤 상품이 어떤 날짜에 몇개가 입고 또는 출고가 되었는지에 대한 데이터를 기록하는 테이블
CREATE TABLE TB_PRODETAIL(
    DCODE NUMBER PRIMARY KEY, --이력번호
    PCODE NUMBER REFERENCES TB_PRODUCT, --상품번호
    PDATE DATE NOT NULL, --상품 입출고일
    AMOUNT NUMBER NOT NULL, --입출고 수량
    STATUS CHAR(6) CHECK(STATUS IN ('입고','출고')) --상태(입고, 출고)
);

--5.이력번호로 매번 새로운 번호 발생시킬수 있는 시퀀스 생성(SEQ_DCODE)
CREATE SEQUENCE SEQ_DCODE
NOCACHE;

--6.200번 상품이 오늘 날짜로 10개 입고 3개 확인
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 200, SYSDATE, 10, '입고');

--7.200번 상품의 재고수량을 10 증가
UPDATE TB_PRODUCT
SET STOCK = STOCK + 10
WHERE PCODE = 200;

COMMIT;

SELECT * FROM TB_PRODUCT;
SELECT * FROM TB_PRODETAIL;

--8.210번 상품이 오늘 날짜로 5개 출고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 210, SYSDATE, 5, '출고');
--8_1 210번 상품이 5개 출고 되었으니 상품테이블에 있는 재고를 -5해주기
UPDATE TB_PRODUCT
SET STOCK = STOCK -5
WHERE PCODE = 210;

SELECT * FROM TB_PRODUCT;
SELECT * FROM TB_PRODETAIL;

COMMIT;

--9.205번 상품이 오늘 날짜로 20개 입고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 205,SYSDATE, 20, '입고');
--9_1 205번 상품의 재고를 +20
UPDATE TB_PRODUCT
SET STOCK = STOCK + 20
WHERE PCODE = 210; --잘못 수행하는 경우

ROLLBACK; --롤백하여야한다.

SELECT * FROM TB_PRODUCT;
SELECT * FROM TB_PRODETAIL;

--이렇게 작업이 같이 실행되야하는 경우에 작업을 따로 진행하다보면 실수가 발생할 수 있다
--이런 일괄작업은 트리거를 지정하여 실행되게 하면 실수를 줄일 수 있음

--TB_PRODETAIL테이블에 INSERT 이벤트 발생시
--TB_PRODUCT테이블에 매번 자동으로 재고수량 UPDATE되게 트리거 정의

/*
    -상품이 입고된 경우 - 해당 상품을 찾아서 재고수량 증가 UPDATE
    UPDATE TB_PRODUCT
    SET STOCK = STOCK + 현재 입고된 수량(INSERT된 AMOUNT값)
    WHERE PCODE = 입고된 상품번호(INSERT된 PCODE값)
    
    -상품이 출고된 경우 - 해당 상품을 찾아서 재고수량 감소 UPDATE
    UPDATE TB_PRODUCT
    SET STOCK = STOCK - 현재 출고되 수량(INSERT된 AMOUNT값)
    WHERE PCODE = 입고된 상품번호(INSERT된 PCODE값)
*/
CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON TB_PRODETAIL
FOR EACH ROW 
BEGIN 
    --상품이 입고된 경우 -> 재고 수량 증가
    IF (:NEW.STATUS = '입고')
        THEN 
        UPDATE TB_PRODUCT
        SET STOCK = STOCK + :NEW.AMOUNT --:NEW 를 통해서 INSERT된 데이터 사용가능
        WHERE PCODE = :NEW.PCODE;
    ELSE --STATUS: 출고인 상황 
        UPDATE TB_PRODUCT
        SET STOCK = STOCK - :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/
--210번 상품 오늘 날짜로 7개 출고 
INSERT INTO TB_PRODETAIL VALUES (SEQ_DCODE.NEXTVAL, 210,SYSDATE, 7, '출고');

--200번 상품 오늘날짜로 100개 입고 
INSERT INTO TB_PRODETAIL VALUES (SEQ_DCODE.NEXTVAL, 200,SYSDATE, 100, '입고');

--상품 조회하여 트리거 실행되는지 확인하기 
SELECT * FROM TB_PRODUCT;
SELECT * FROM TB_PRODETAIL;

/*
    트리거 장점
    1. 데이터 추가, 수정, 삭제시 자동으로 데이터 관리를 해줌으로써 무결성 보장
    2. 데이터베이스 관리의 자동화
    
    트리거 단점
    1. 빈번한 추가, 수정, 삭제시 ROW의 삽입, 추가, 삭제가 함께 실행되므로 성능상 좋지 못함
    2. 관리적인 측면에서 형상관리가 불가능하기 때문에 관리하기 불편하다

*/







