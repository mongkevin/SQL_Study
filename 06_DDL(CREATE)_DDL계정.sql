/*
    *DDL (DDL DATA DEFINITION LANGUAGE): 데이터 정의 언어
    
    오라클에서 제공하는 객체(OBJECT)를
    새롭게 만들고 (CREATE), 구조를 변경하고 (ALTER), 구조자체를 삭제(DROP)하는 명령문
    즉, 구조 자체를 정의하는 언어로 DB관리자 설계자가 사용한다.
    
    오라클에서의 객체 (DB를 이루는 구조물들)
    테이블(TABLE), 사용자(USER), 함수(FUNCTION), 뷰(VIEW), 시퀀스(SEQUENCE)...
    
    <CREATE TABLE>
    테이블: 행(ROW), 열(COLUMN)로 구성되는 가장 기본적인 데이터베이스 객체 종류 중 하나
          모든 데이터는 테이블을 통해 저장된다(테이터를 조작하고자 한다면 테이블을 생성해야함)
    
    [표현법]
    CREATE TABLE 테이블명(
    컬럼명 자료형;
    컬럼명 자료형;
    .....
    )
    
    <자료형>
    -문자 (CHAR(크기)/VARCHAR2(크기)): 크기는 BYTE단위 (숫자, 영문, 특수문자-1BYTE/한글-글자당 3BYTE)
    -CHAR(바이트 수): 최대 2000BYTE까지 지정 가능하고 고정길이로 적은 데이터가 들어오면 공백으로 길이를 채운다
     주로 정해진 길이의 데이터를 저장할때 사용
    -VARCHAR2(바이트 수): 최대 4000BYTE까지 지정가능
                        가변 길이 (적은 값이 들어온 경우 해당 데이터만큼 크기로 맞춰준다)
                        VAR는 가변 2는 2배를 의미
                        주로 들어올 값의 글자수가 정해져 있지 않는 경우에 사용한다.
    -숫자(NUMBER): 정수/실수 상관없이 NUMBER로 작성
    -날짜(DATE): 년/월/일/시/분/초 형식으로 시간 지정

*/

--회원들의 데이터를 넣을 테이블을 생성해보자.(아이디, 비번, 이름, 생년월일) 담을 MEMBER TABLE 생성.
CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(20), --대소무자 구분하지 않음(낙타봉표기법이 의미 없음 _언더바로 구분)
    MEMBER_PWD VARCHAR2(20),
    member_name VARCHAR2(20),
    MEMBER_BDATE DATE
);
--동일한 테이블은 생성 불가
--테이블 확인하기
--1번 조회구문 
SELECT * FROM MEMBER;
--2번 테이블 딕셔너리 활용 
--데이터 딕셔너리: 다양한 객체들의 정보를 저장하고 있는 시스템 테이블
SELECT* FROM USER_TABLES;
--3번 접속탭에서 눌러서 확인

/*
    콜럼에 주석 달아보기(컬럼 설명)
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';

*/

COMMENT ON COLUMN MEMBER.MUMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MUMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.MEMBER_BDATE IS '생년월일';

SELECT * FROM MEMBER;

--INSERT (데이터 추가구문) - DM문

--한 행으로 추가 (행을 기준으로 추가), 추가할 값을 기술(값의 순서 중요)

--INSERT INTO 테이블명 VALUES(첫 번째 컬럼 값, 두번째 컬럼 값,…);

INSERT INTO MEMBER VALUES('user01','pass01','김유저','1950-12-10');

INSERT INTO MEMBER VALUES('user02','pass02','최유저','1960-1-14');

INSERT INTO MEMBER VALUES('user03','pass03','관리자','1930-2-1');

SELECT * FROM MEMBER;
INSERT INTO MEMBER VALUES(NULL, NULL, NULL, SYSDATE);
INSERT INTO MEMBER VALUES('user01','pass01','김유저','1950-12-10');

/*
    <제약조건 CONSTRAINTS>
    -원하는 데이터값만 유지하기 위해 (보관하기 위해) 특정 컬럼마다 설정하는 제약
    -제약조건이 부여된 컬럼에 들어올 데이터에 문제가 있는지 없는지 자도응로 검사
    -종류: NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGH KEY
    -컬럼에 제약 조건을 부여하는 방식: 컬럼레벨 방식, 테이블 레벨 방식 
*/

/*
    1.NOT NULL 제약 조건
    해당 컬럼에 반드시 값이 존재해야할 경우 사용
    -즉 NULL 값이 절대 들어와서는 안되는 컬럼에 부여하는 제약조건
     삽입/수정시 NULL값을 허용하지 않도록 제한하는 제약 조건
     주의사항: 컬럼레벨방식만 가능
*/

--NOT NULL 제약조건을 설정한 테이블 만들기
--컬럼레벨방식: 컬럼명 자료형 제약조건 (컬럼뒤에 바로 작성하는 방식)
CREATE TABLE MEM_NOTNULL(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);
--DROP TABLE MEM_NOTNULL; 테이블 삭제구문
--데이터 3개정도 넣어보기 NULL포함
INSERT INTO MEM_NOTNULL VALUES(1,'user03','pass03','관리자','남','010-1231-1231','suer@gmail.com');
INSERT INTO MEM_NOTNULL VALUES(2,'user02','pass02','김유저','여','010-1231-1231','suer@gmail.com');
INSERT INTO MEM_NOTNULL VALUES(2,'user02','pass02','김유저',NULL,NULL,NULL);
SELECT* FROM MEM_NOTNULL;
--NOT NULL 제약조건을 부여하지 않으면 NULL값이 들어갈 수 없다.

/*
    2.UNIQUE 제약조건
    컬럼에 중복값을 제한하는 제약조건
    삽입/수정시 기존에 해당 컬럼값 중에 중복값이 있을 경우
    추가 또는 수정이 되지 않게 제약한다.
    
    컬럼레벨방식/테이블레벨방식 둘다 가능
*/
--한개의 컬럼에 여러 제약조건을 걸어줄 수 있다
--위에 있는 NOT NULL테이블과 동일하게 작성호되 아이디에 UNIQUE 제약조건을 걸어주세요.
--작성법은 NOT NULL UNIQUE로 작성하면 됩니다.
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE, --컬럼레벨방식 
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);

INSERT INTO MEM_UNIQUE VALUES(1,'user03','pass03','관리자','남','010-1231-1231','suer@gmail.com');
INSERT INTO MEM_UNIQUE VALUES(2,'user02','pass02','김유저','남','010-1241-3231','uer@gmail.com');

SELECT * FROM MEM_UNIQUE;

--DROP 구문
DROP TABLE MEM_UNIQUE;

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL, 
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    UNIQUE(MEM_ID) --테이블레벨방식: 모든 컬럼을 다 작성한 쉬 제약조건을 나열한다.
);

INSERT INTO MEM_UNIQUE VALUES(1,'user01','pass01','관리자','남','010-1231-1231','suer@gmail.com');
--UNIQUE CONSTRAINT (DDL.SYS_C008435) VIOLATED
--SYS_C008435: 제약조건의 이름
--제약조건 부여시 직접 제약조건명을 작성하지 않으면 시스템에서 임의의 제약조건을 부여해준다.
--SYS_C~~~~~~~ (중복되지 않은 이름으로 지정)

/*
    제약조건 부여시 제약조건명도 지정하는 표현법
    
    -컬럼레벨방식
    CREATE TABLE 테이블명(
        컬럼명 자료형 제약조건,
        컬럼명 자료형 CONSTRAINT 제약조건명 제약조건,
        컬럼명 자료형,
        ...
    );
    
    -테이블레벨방식
    CREATE TABLE 테이블명(
        컬럼명 자료형,
        컬럼명 자료형,
        ....
        컬럼명 자료형,
        CONSTRAINT 제약조건명 제약조건(컬럼명)
    )
    -두 방식 모두 CONSTRAINT 제약조건명 부분 생략가능
*/
--MEM_CON_NM이라는 테이블을 생성하는데 위에 테이블과 컬럼명, 자료형은 일치
--제약조건은 MEM_NAME에 컬럼레벨 방식으로 MEM_NAME_NM 이라는 NOT NULL 제약조건을 걸어주고
--테이블레벨 방식으로는 MEM_ID_UQ 라는 이름의 유니크 제약조건을 MEM_ID컬럼에 부여해보세요
--부여 후 데이터 삽입하여 NOTNULL과 UNIQUE가 제대로 작동하고 이름이 변경되어 나오는지 확인하시오.

CREATE TABLE MEM_CON_NM(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEM_NAME_NM NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    CONSTRAINT MEM_ID_UQ UNIQUE(MEM_ID)
);
DROP TABLE MEM_CON_NM;
INSERT INTO MEM_CON_NM VALUES(1,'user01','pass01','관리자','남','010-1231-1231','suer@gmail.com');
--unique constraint (DDL.MEM_ID_UQ) violated
--어떤 컬럼에 어떤 종류의 제약조건인지 조합하여 작성하기

/*
    3.CHECK 제약조건
      컬럼에 기옥될 수 있는 값에 대한 조건을 설정할 수 있다
      EX)성별에 '남' 또는 '여' 값만 들어오게 설정하기
    
    [표현법]
    CHEAK(조건식)
*/
--위의 테이블과 같은 컬럼과 자료형 제약조건을 갖고 GENDER 컬럼에 CHECK 제약조건으로 남 또는 여만
--허용하는 테이블을 생성해 봅시다. 마지막 컬럼에 MEM_DATE 컬럼을 추가하여 날짜 자료형으로 설정하고
--NOT NULL 제약조건을 부여한뒤 데이터를 넣을때 SYSDATE를 넣어서 확인해보기
CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE,
    UNIQUE(MEM_ID)
);

--CHECK 제약조건에 NULL값도 허용된다 만약 NULL값을 허용하고 싶지 않다면? NOT NULL 추가하면 된다.

SELECT * FROM MEM_CHECK;

--MEM_DATE가 회원가입일로 사용할 컬럼이라면? 항상 SYSDATE가 들어가게 될 것
--이때 항상 SYSDATE로 입력받고자 한다면?

/*
    DEFAULT 설정
    특정 컬럼에 들어올 값에 대한 기본 값 설정
    제약조건은 아니다.

*/
DROP TABLE MEM_CHECK;

--위에 있는 MEM_CHECK 테이블과 컬럼, 데이터타입, 제약조건이 전부 일치하고
--MEM_DATE 컬럼에는 DEFAULT SYSDATE를 걸어서 생성해보시오
--생성 후 데이터 넣고 확인해볼 것

CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE  DATE DEFAULT SYSDATE NOT NULL, --DEFAULT를 먼저 설정한 뒤 제약조건을 걸어야한다
    UNIQUE(MEM_ID)
);

/*
    DML - INSERT
    방식1 - INSERT INTO 테이블명 VALUES(데이터, 데이터, ....);
    방식2(컬럼명 나열) - INSERT INTO 테이블명(컬럼명, 컬럼명,...) VALUES(데이터,데이터,...);
*/
--나열한 컬럼에 대한 데이터 전부 넣기 
INSERT INTO MEM_CHECK(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER, PHONE,EMAIL,MEM_DATE)
VALUES(1,'user01','pass01','김유저','남','010-2133-1314','user@gmail.com',SYSDATE);
--필수항목이 아닌 컬럼 제외, NOT NULL 조건인 컬럼들만 넣어줘도 된다.(입력하지 않은 컬럼은 기본값이 대입된다(초기값은 NULL이고 DEFAULT로 설정도 가능하다))
INSERT INTO MEM_CHECK(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(2,'user02','pass02','박유저','여');

SELECT * FROM MEM_CHECK;

/*
    4.PRIMARY KEY(기본키) 제약조건
      테이블에서 각 행들의 정보를 유일하게 식별할 수 있는 컬럼에 부여하는 제약조건
      -각 행들을 구분할 수 있는 식별자의 역할
      EX) 사번, 부서아이디, 직급코드, 회원번호, 학번...
      -식별자의 조건: 중복 X, 값이 없으면 안됨(NOT NULL + UNIQUE)
      
      주의사항)
      한 테이블에 하나만 지정가능하다.
*/

--위와 같은 테이블 컬럼과 제약조건을 갖고 MEM_DATE는 DEFAULT SYSDATE까지 작성 후
--컬럼레벨 방식으로 MEM_NO에 MEM_PK라는 이름을 가진 PRIMARY KEY 제약 조건을 추가하여 생성해보기

CREATE TABLE MEM_PRIMARYKEY(
    MEM_NO NUMBER CONSTRAINT MEM_PK PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE  DATE DEFAULT SYSDATE NOT NULL, 
    UNIQUE(MEM_ID)
);
INSERT INTO MEM_PRIMARYKEY(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(1,'user01','pass01','박유저','여');
INSERT INTO MEM_PRIMARYKEY(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(1,'user02','pass02','최유저','여');--unique constraint(DDL.MEM_PK)violated
INSERT INTO MEM_PRIMARYKEY(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(NULL,'user02','pass02','최유저','여'); --NULL을 ("DDL"."MEM_PRIMARYKEY"."MEM_NO") 안에 삽입할 수 없습니다

--테이블 레벨 방식으로도 아래에 작성해보기
CREATE TABLE MEM_PRIMARYKEY1(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE  DATE DEFAULT SYSDATE NOT NULL, 
    UNIQUE(MEM_ID),
    CONSTRAINT MEM_PK2 PRIMARY KEY(MEM_NO)
);

INSERT INTO MEM_PRIMARYKEY1(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(1,'user01','pass01','박유저','여');
INSERT INTO MEM_PRIMARYKEY1(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(1,'user02','pass02','최유저','여');--unique constraint(DDL.MEM_PK)violated
INSERT INTO MEM_PRIMARYKEY1(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(NULL,'user02','pass02','최유저','여'); --NULL을 ("DDL"."MEM_PRIMARYKEY"."MEM_NO") 안에 삽입할 수 없습니다

--두 컬럼을 하나의 PRIMARY KEY로 만들기(복합키)
CREATE TABLE MEM_PRIMARYKEY2(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN('남','여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE  DATE DEFAULT SYSDATE NOT NULL, 
    UNIQUE(MEM_ID),
    CONSTRAINT MEM_PK3 PRIMARY KEY(MEM_NO,MEM_ID)
);

INSERT INTO MEM_PRIMARYKEY2(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(1,'user01','pass01','박유저','여');
--MEM_NO만 동일하게 데이터 입력해보기
INSERT INTO MEM_PRIMARYKEY2(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(1,'user02','pass02','김유저','남');
SELECT * FROM MEM_PRIMARYKEY2;
--MEM_ID만 동일한 데이터 입력 
INSERT INTO MEM_PRIMARYKEY2(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(2,'user02','pass02','김유저','남');
--NO와 ID 둘다 동일한 데이터 입력
INSERT INTO MEM_PRIMARYKEY2(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(2,'user02','pass03','유저','여'); --두 컬럼의 값이 중복되면 제약조건 위배

INSERT INTO MEM_PRIMARYKEY2(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, GENDER)
VALUES(NULL,'user05','pass03','유저','여'); --복합키일 경우에는 한 컬럼이라도 NULL값을 가지면 제약조건에 위배된다

/*
    5.FOREIGH KEY(외래키)
      해당 컬럼에 다른 테이블에 존재하는 값만 들어와야 하는 컬럼에 부여하는 제약조건
      -다른 테이블(부모테이블)을 참조한다 로 표현한다.
      -참조된 다른 테이블이 가지고 있는 데이터만 들어갈 수 있다.
      
      -FOREIGH KEY 제약조건(연결고리) 다른 테이블과의 관계를 현성할 수 있다 EX) JOIN

    [표현법]
    -컬럼레벨방식
    컬럼명 자료형 CONSTRAINT 제야조건명 REFERENCES 참조할 테이블명(참조컬럼명)
    
    -테이블 레벨방식
    CONSTRAINT 제약조건명 FOREIGH KEY(컬럼명) REFERENCES 참조테이블명(참조컬럼명)
    *참조테이블 == 부모테이블
    생략 가능한 것: CONSTRAINT 제약조건명, 참조할 컬럼명(두 방식 모두)
    -만약 참조할 컬럼명을 지정하지 않았다면 해당 테이블의 PRIMARY KEY에 해당하는 컬럼이 자동으로 설정됨
    
    주의사항: 참조할 컬럼타입과 외래키로 지정할 컬럼 타입이 같아야한다.
*/

--부모테이블(참조테이블) 만들기
--회원 등급에 대한 데이터(등급코드, 등급명) 보관하는 테이블
CREATE TABLE MEM_GRADE(
    GRADE_CODE CHAR(2) PRIMARY KEY, --등급 코드/문자열('G1','G2',...)
    GRADE_NAME VARCHAR2(20) NOT NULL --등급명 / 문자열('일반회원','우수회원',...)
);

INSERT INTO MEM_GRADE VALUES('G1','일반회원');
INSERT INTO MEM_GRADE VALUES('G2','우수회원');
INSERT INTO MEM_GRADE VALUES('G3','특별회원');

SELECT * FROM MEM_GRADE;

--자식 테이블 만들기
--회원 정보를 담는 테이블
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2) REFERENCES MEM_GRADE(GRADE_CODE), --컬럼 레벨 방식으로 외래키 지정
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')) NOT NULL,
    PHONE VARCHAR2(15), 
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL
    
    --FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) --테이블 레벨 방식 
);

INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID,GENDER)
VALUES(1,'user01','pass01','김유저','G1','남');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID,GENDER)
VALUES(2,'user02','pass02','박유저','G2','여');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID,GENDER)
VALUES(3,'user03','pass03','최유저','G3','여');

SELECT * FROM MEM;
--외래키 제약조건 컬럼에 NULL값을 넣어보자 (NULL)값은 허용
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID,GENDER)
VALUES(4,'user04','pass04','이유저',NULL,'남');
--부모테이블 참조컬럼에 없는 데이터를 넣어보자
--G4등급은 부모테이블(참조테이블)인 MEM_GRADE에 GRADE_CODE에 넣은 적이 없기 때문에 찾을 수 없다는 오류 발생
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID,GENDER)
VALUES(5,'user05','pass05','장유저','G4','남'); --부모 키가 없습니다

--만약 부모테이블에 있는 GRADE_CODE가 삭제 된다면?
--MEM_GRADE 테이블에 있는 GRADE_CODE중 G1데이터를 지워보자
--행 삭제 구문(DELETE: DML구문)
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G1'; --자식 레코드가 발견되었습니다. 
--자식 테이블 중에 해당 컬럼 데이터를 참조하고 있기 때문에 삭제 불가
--기본적으로 삭제 제한 옵션이 걸려있다 
--만약 외래키에 대한 삭제 제한을 설정하려면 옵션을 부여하면 된다.
--생성시에 옵션 추가하여 생성

DROP TABLE MEM;

/*
    자식 테이블 생성 시 (외래키 제한조건을 부여했을때)
    부모테이블의 데이터가 삭제되었을때 자식 테이블에서는 어떻게 처리할 것인지 옵션으로 정해둘 수 있다
    
    *FOREIGH KEY 삭제 옵션
    -ON DELETE SET NULL: 부모테이터를 삭제할때 해당 데이터를 사용하는 자식 데이터를 NULL로 바꾸겠다
    -ON DELETE CASCADE: 부모데이터를 삭제할때 해당 데이터를 사용하는 자식 데이터도 같이 삭제하겠다 
    -ON DELETE RESTRICTED: 삭제 제한 - 기본 옵션
*/
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2),
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')) NOT NULL,
    PHONE VARCHAR2(15), 
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL,    
    FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL 
);

INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID,GENDER)
VALUES(1,'user01','pass01','김유저','G1','남');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID,GENDER)
VALUES(2,'user02','pass02','박유저','G2','여');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID,GENDER)
VALUES(3,'user03','pass03','최유저','G3','여');

SELECT * FROM MEM;

--부모테이블에 있는 GRADE_CODE가 'G1'인 데이터 삭제
DELETE FROM MEM_GRADE
WHERE GRADE_CODE='G1'; --삭제 완료

SELECT * FROM MEM;

--MEM테이블을 삭제한 뒤 ON DELECTE CASCADE옵션으로 다시 생성하여 데이터 삭제 후 확인해보기
DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2),
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')) NOT NULL,
    PHONE VARCHAR2(15), 
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL,    
    FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE CASCADE 
);

--부모테이블(MEM_GRADE) GRADE_CODE가 G3인 데이터 삭제
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G3';
--해당 뎅터를 참조하던 자식 테이블 행들도 삭제됨
SELECT * FROM MEM;

--외래키 참조하지 않아도 조인 가능한지 확인하기
DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2),
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')) NOT NULL,
    PHONE VARCHAR2(15), 
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL   
);

SELECT MEM_NO, MEM_ID,MEM_NAME,GRADE_NAME
FROM MEM
JOIN MEM_GRADE ON (GRADE_ID = GRADE_CODE);
--외래키 제약조건이 걸려있지 않아도 같은 데이터를 사용한다면 조인이 가능하다.

-------------------------------------------------------

/*
    -----------여기부터는 KH계정 접속 후 진행---------------
    
    *SUBQUERY를 이용하여 테이블을 생성해보자 (테이블 복사)
    [표현법]
    CREATE TABLE 테이블 명
    AS 서브쿼리;

*/
--EMPLOYEE 조회
SELECT *
FROM EMPLOYEE;

--EMPLOYEE 테이블을 복제한 새로운 테이블 생성(EMPLOYEE_COPY)
CREATE TABLE EMPLOYEE_COPY
AS SELECT * FROM EMPLOYEE;
--컬럼, 데이터값 복사
--NOT NULL 제약조건 복사
--PRIMARY KEY와 같은 나머지 제약 조건은 복사되지 않는다
--SUBQUERY 구문으로 생성한 경우 NOT NULL제약 조건만 복사된다.

SELECT *
FROM EMPLOYEE_COPY;

--EMPLOYEE테이블에 있는 컬럼의 구조만 복사하고 싶고 해당 데이터들을 복사하고 싶지 않을때 - 조건을 부여해서 복사
--데이터가 조회되지 않는 조건을 부여하면 된다.
SELECT *
FROM EMPLOYEE
WHERE 1=0; --1=0은 항상 FALSE

SELECT *
FROM EMPLOYEE
WHERE 1=1; --1=1은 항상 TRUE

--위의 조건으로 구조만 복사해보기
CREATE TABLE EMPLOYEE_COPY2
AS SELECT* FROM EMPLOYEE WHERE 0=1;

SELECT * FROM EMPLOYEE_COPY2;

--전체 사원들 중 급여가 300만원 이상인 사원들의 사번, 이름, 부서코드, 급여 컬럼 복제)내용물도 같이 복제)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >3000000;

CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
   FROM EMPLOYEE
   WHERE SALARY >3000000;
   
--전체 사원의 사번, 사원명, 급여, 연봉 조회한 결과를 복제한 테이블 생성(내용물도 복제)
SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12
FROM EMPLOYEE;

--서브쿼리의 SELECT절에 산술연산 또는 함수식이 기술된 경우 반드시 별칭을 부여해야한다.
CREATE TABLE EMPLOYEE_COPY4
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 연봉
    FROM EMPLOYEE;











