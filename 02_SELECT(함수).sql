/*
	<함수 FUNCTION>
	자바로 따지면 메소드와 같은 존재
	매개변수로 전달된 값들을 읽어서 계산한 결과를 반환한다.

	-단일행 함수: N개의 값을 읽어서 N개의 결과를 리턴한다(매행마다 함수를 실행하여 결과를 반환함)
	-그룹함수: N개의 값을  읽어서 1개의 결과를 리턴(하나의 그룹별로 함수 실행 후 결과 반환)

	단일행 함수와 그룹 함수는 함께 사용할 수 없다 - 결과가 행수가 다르기 때문

---------------------------단일 행 함수----------------------------

	<문자열과 관련된 함수>
	LENGTH / LENGTHB
	
	-LENGTH(문자열): 해당 전달된 문자열의 글자 수 반환
	-LENGTHB(문자열): 해당 전달된 문자열의 바이트 수 반환

	결과값은 숫자로 반환한다: NUMBER
	문자열: 문자열 형식의 리터럴, 문자열에 해당하는 컬럼

	한글: '김' => 'ㄱ','ㅣ','ㅁ' => 한글자당 3BYTE 취급
	영문, 숫자, 특수문자: 한글자당 1BYTE 취급
*/
SELECT LENGTH('오라클'),LENGTHB('오라클')
FROM DUAL; --가상 테이블로 산술 연산이나 가상 컬럼등 값을 한번만 출력하고자 할때 사용하는 테이블

SELECT '원','1',1,2
FROM DUAL;

SELECT EMAIL, LENGTH(EMAIL),LENGTHB(EMAIL),EMP_NAME,LENGTH(EMP_NAME),LENGTHB(EMP_NAME)
FROM EMPLOYEE;

/*
	INSTR 

	-INSTR(문자열,특정문자,찾을 위치의 시작값, 순번): 문자열로부터 특정 문자의 위치값 반환

	찾을 위치의 시작값, 순번은 생략가능
	결과값은 NUMBER타입으로 반환
	
	찾을 위치의 시작값(1/-1)
	1: 앞에서부터 찾겠다. (생략시 기본값)
	-1: 뒤에서부터 찾겠다.
*/
SELECT INSTR('AAABAABBAA','B') 
FROM DUAL; --앞에서부터 첫 번째에 위치하는 B의 위치값을 알려준다. 찾을 위치, 순번 생략시 기본적으로 앞에서부터 첫번째 위치

SELECT INSTR('AAABAABBAA','B',1)
FROM DUAL;

SELECT INSTR('AAABAABBAA','B',-1)
FROM DUAL; --시작값을 -1로하면 뒤에서부터 첫 번째로 오는 문자를 찾아 앞에서부터 위치를 찾는다.

SELECT INSTR('AAABAABBAA','B',-1,3)
FROM DUAL; --뒤에서부터 3번째 위치한 B를 찾아서 앞에서부터 위치값을 반환한다.

SELECT INSTR('AAABAABBAA','B',1,2)
FROM DUAL;  --앞에서부터 2번째 위치한 B를 찾아 앞에서부터 센 위치값 반환

--SELECT INSTR('AAABAABBAA','B',1,0)
--FROM DUAL; -- 범위를 벗어난 순번을 제시하면 오류 발생
--자바에서처럼 위치값을 반환하지만 0부터 시작이 아니라 1부터 시작인 것을 알 수 있다.

--EMPLOYEE 테이블에서 EMAIL의 @ 위치를 알아내봅시다
SELECT EMAIL, INSTR(EMAIL,'@') "@의 위치"
FROM EMPLOYEE;

/*
	SUBSTR
	문자열로부터 특정 문자열을 추출하는 함수
	-SUBSTR(문자열,처음위치,추출한 문자개수)
	결과값은 CHARACTER 타입으로 반환(문자열 형태)
	추출할 문자 개수는 생략가능하다(생략했을땐 문자열 끝까지 추출)
	처음 위치는 음수로 제시 가능하다: 뒤에서부터 N번째 위치로부터 문자를 추출하겠다는 의미
*/

SELECT SUBSTR('HELLO WORLD!!',6)
FROM DUAL; --WORLD!! --6번위치부터 끝까지 추출

SELECT SUBSTR('HELLO WORLD!!!',7,2)
FROM DUAL; --WO   7번위치부터 2개 추출

SELECT SUBSTR('HELLO WORLD!!!',1,5)
FROM DUAL; --1번위치부터 5개 HELLO

SELECT SUBSTR('HELLO WORLD!!',-5)
FROM DUAL; --음수 입력시 뒤에서 부터 위치 찾음

SELECT SUBSTR('HELLO WORLD!!',-5,3)
FROM DUAL; --뒤에서부터 위치찾고 3개 추출

--주민등록번호에서 성별 부분을 추출하여 확인하기
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO ,8,1) AS 성별
FROM EMPLOYEE;

--이메일에서 ID부분만 추출해서 조회해보기
SELECT EMP_NAME,EMAIL, SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1) "아이디"
FROM EMPLOYEE; --INSTR로 @위치 찾아서 그 위치 전까지 잘라내기

--남자 사원들만 조회해보기
SELECT *
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN('1','3');

--여자 사원들만 조회해보기
SELECT *
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN('2','4');
--WHERE SUBSTR(EMP_NO,8,1) = '2' OR SUBSTR(EMP_NO,8,1) = '4';

/*
	LAPAD / RPAD
	-LPAD/RPAD (문자열, 최종적으로 반환할 문자의 길이(BYTE), 덧붙이고자 하는 문자
	-제시한 문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 붙여 최종 N길이만큼의 문자열을 반환한다
	결과값은 CHARACTER 타입
	덧붙이고자하는 문자: 생략가능

*/
SELECT LPAD(EMAIL,16)
FROM EMPLOYEE; --덧붙이고자 하는 문자 생략시 ' ' 공백이 기본값이 된다

SELECT RPAD(EMAIL,20,'*')
FROM EMPLOYEE;

--주민등록번호에서 성별 이후 문자들 *처리하여 추출해보세요.
SELECT RPAD(SUBSTR (EMP_NO ,1,8),14,'*')
FROM EMPLOYEE;

/*
	LTRIM / RTRIM
	-LTRIM / RTRIM(문자열,제거시키고자 하는 문자)
	:문자열의 왼쪽 또는 오른쪽에서 제거시키고자 하는 문자들을 찾아서 제거한 나머지 문자열을 반환

	결과값은 CHARACTER형태로 나온다.
	제거시키고자 하는 문자는 생략 가능(생략시 ' '이 제거된다)
*/
SELECT LTRIM('      K   H     ')
FROM DUAL;                                                                                                                                                                                                                                                                             

SELECT LTRIM('KKKKKKKGGHHHHHH','K')
FROM DUAL; -- 왼쪽에 있는 원하는 문자를 삭제

SELECT LTRIM('123123KH123123','123')
FROM DUAL;

SELECT LTRIM('ACDBFG','ABC')
FROM DUAL; --DBFG 제거시키고자 하는 문자열을 통으로 지워주는 것이 아니라 문자 하나하나가 다 존재하면 지워주는 원리

/*
	TRIM
	
	-TRIM(BOTH/LEADING/TRAILING '제거하고자하는 문자' FROM '문자열')
	:문자열의 양쪽/앞쪽/뒤쪽에 있는 특정 문자를 제거한 나머지를 반환

	결과값은 CHARACTER타입
	BOTH/LEADING/TRAILING: 생략가능 생략시 기본값 BOTH
	LEADING: 앞쪽만
	TRAILING: 뒤쪽만
*/

SELECT TRIM('      K   H    ')
FROM DUAL; --기본적으로 양쪽 ' ' 문자 제거

--SELECT TRIM('AAAABBCC','A') 매개변수 제시 형식이 맞지 않음
--FROM DUAL; --오류발생

SELECT TRIM(BOTH 'A' FROM 'AAABBCCC')
FROM DUAL; --BOTH 양쪽 삭제, 생략시 기본값

SELECT TRIM(LEADING 'Z' FROM 'ZZZBBZZZZ')
FROM DUAL; --LEADING 앞쪽

SELECT TRIM(TRAILING 'G' FROM 'KKGGKKKGGG')
FROM DUAL; --TRAILING: 뒤쪽 삭제

/*
	LOWER/UPPER/INITCAP

	-LOWER(문자열)
	:다 소문자로 변경

	-INITCAP(문자열)
	:각 단어의 앞글자만 대문자로 변경

	결과값은 CHARACTER 형태로 반환
*/

SELECT LOWER('HELLO WORLD'),UPPER('good day'), INITCAP('good day')
FROM DUAL;

/*
	CONCAT
	CONCAT(문자열1,문자열2)
	:전달된 문자열 두개를 하나의 문자열로 합쳐서 반환

	결과값은 CHARACTER 형태로 반환


*/
SELECT CONCAT('안녕','하세요')
FROM DUAL;

SELECT '안녕' || '하세요'
FROM DUAL;

--차이점
--SELECT CONCAT('안녕','하세요','반갑','습니다')
--FROM DUAL; --오류 두개의 문자열만 가능

SELECT '안녕'||'하세요'||'반갑'||'습니다'
FROM DUAL; --여러개 가능

SELECT CONCAT('안녕',CONCAT('하세요',CONCAT('반갑','습니다')))
FROM DUAL; --중첩해서 사용할 순 있지만 가독성이 떨어진다.

/*
	REPLACE
	-REPLAC(문자열, 찾을문자, 바꿀문자)
	:문자열로부터 찾을 문자를 찾아 바꿀 문자로 변경한 문자열을 반환
	결과값은 CHARACTER형태로 반환

*/

SELECT REPLACE('user01@naver.com','naver.com','google.com')
FROM DUAL;

--EMPLOYEE 테이블의 이메일 주소 뒷부분을 google.com으로 변경하여 조회해보기
SELECT REPLACE(EMAIL,'kh.or.kr','google.com') "변경된 이메일"
FROM EMPLOYEE;

------------------------------------------------------
/*
	<숫자와 관련된 함수>
	
	ABS
	-ABS(절대값을 구할 숫자): 절대값 구하는 함수
	결과값은 NUMBER형태로 변환
*/

SELECT ABS(-10)
FROM DUAL;

SELECT ABS(-505.5)
FROM DUAL;

/*
	MOD
	-MOD(숫자,나눌값): 두 수를 나눈 나머지 값을 반환해주는 함수
	결과값은 NUMBER형

*/
SELECT MOD(10,3)
FROM DUAL;

SELECT MOD(-10,3)
FROM DUAL; --    -1

SELECT MOD(-15.5,4)
FROM DUAL; --  -3.5

/*
	ROUND
	-ROUND(반올림하고자 하는 수, 반올림할 위치) : 반올림 처리 함수
	반올림할 위치: 소수점 기준으로 아래에서 N번째 수에서 반올림하겠다(생략가능 생략시 소수점 첫번째 자리에서 반올림)
	결과값 NUMBER형

*/

SELECT ROUND(123.45)
FROM DUAL; --123

SELECT ROUND(123.456,1)
FROM DUAL; --123.5

SELECT ROUND(123.456,2)
FROM DUAL; --123.5

SELECT ROUND(123.456,-1)
FROM DUAL; --120

SELECT ROUND(123.456, -2)
FROM DUAL; --100

/*
	CEIL
	-CEIL(올림처리할 숫자): 소수점 아래의 수를 무조건 올림 처리하는 함수
	반환형은 NUMBER형
*/

SELECT CEIL(123.456)
FROM DUAL; --124

SELECT CEIL(222.001)
FROM DUAL; --223

/*
	FLOOR
	-FLOOR(버림할 숫자): 소수점 아래의 수를 무조건 버림 처리하는 함수
	반환형은 NUMBER형
*/
SELECT FLOOR(123.999)
FROM DUAL; --123

SELECT FLOOR(119.011)
FROM DUAL; --119

--각 직원별로 근무일수 구하기(오늘날짜 - 고용일) - 시분초 계산까지 되어 소수점이 나왔었따. 지워보기

SELECT *
FROM EMPLOYEE;

SELECT EMP_NAME, FLOOR(SYSDATE-HIRE_DATE) 근무일수
FROM EMPLOYEE;

/*
	TRUNC
	-TRUNC(버림처리할 숫자, 위치): 위치가 지정 가능한 버림 함수)
	결과값은 NUMBER형
	위치: 생략가능, 생략시 기본값은 0 (==FLOOR 함수)
*/
SELECT TRUNC(123.567)
FROM DUAL; --123

SELECT TRUNC(123.567,1)
FROM DUAL;

SELECT TRUNC(123.567,2)
FROM DUAL; --123.56

SELECT TRUNC(123.567,-1)
FROM DUAL; --120

-----------------------------------------------------------------------
/*
	<날짜 관련 함수>
	DATE 타입: 년, 월, 일, 시, 분, 초를 다 포함한 자료형

*/
--SYSDATE: 현재 시스템 날짜 반환
SELECT SYSDATE
FROM DUAL;

--1.
--MONTHS_BETWEEN(DATE1,DATE2): 두 날짜 사이의 개월 수 반환(결과값은 NUMBER형)
--DATE2가 더 미래일 경우엔 음수가 나온다.
--각 직원별 근무 일수, 근무 개월 수

SELECT EMP_NAME
	,FLOOR(SYSDATE-HIRE_DATE)||'일' 근무일수
--	,FLOOR(MONTHS_BETWEEN(HIRE_DATE,SYSDATE))||'개월' 근무개월수
	,FLOOR(ABS(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)))||'개월' 근무개월수 -- 절대값 함수 활용
FROM EMPLOYEE;

--2.
--ADD_MONTHS(DATE,NUMBER): 특정 날짜에 해당 숫자만큼 개월수를 더한 날짜를 반환(결과값은 DATE형)
--오늘 날짜로부터 5개월 후
SELECT ADD_MONTHS(SYSDATE,5)
FROM DUAL;

--전체사원들의 1년 근속일 (==입사일 기준 1년)
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE,12) "입사 일주년"
FROM EMPLOYEE;

--3.
--NEXT_DAY(DATE,요일(문자/숫자)): 특정 날짜에서 가장 가까운 해당 요일을 찾아 그 날짜를 반환(결과값은 DATE형)
SELECT NEXT_DAY(SYSDATE,'토요일')
FROM DUAL;

SELECT NEXT_DAY(SYSDATE,'월')
FROM DUAL;

SELECT NEXT_DAY(SYSDATE,1)
FROM DUAL; --1: 일요일 2:월요일 ~~~~7: 토요일

--토요일: SATURDAY
SELECT NEXT_DAY(SYSDATE,'SATURDAY')
FROM DUAL;

--현재 컴퓨터 언어세팅이 KOREAN이기 때문에 오류

--언어를 잠깐 변경하여 확인해봅시다
--DDL(데이터 정의 언어): CREATE, ALTER, DROP
ALTER SESSION SET NLS_LANGUAGE = AMRICAN;

--언어변경이 되었기 때문에 영문으로 가능/한글 불가능
SELECT NEXT_DAY(SYSDATE,'MONDAY')
FROM DUAL;

SELECT NEXT_DAY(SYSDATE,'SATURDAY')
FROM DUAL;


--확인 끝났으니 다시 한글로 변경
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

--4.
--LAST_DAY(DATE): 해당 특정 날짜 달의 마지막 날짜를 구하여 반환(결과값은 DATE형)

SELECT LAST_DAY(SYSDATE)
FROM DUAL;

--이름, 입사일, 이사한 달의 마지막 날을 조회하기
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

--5.
/*
	EXTRACT: 년도 또는 월 또는 일 정보를 추출해서 반환(결과값은 NUMBER형)
	
	-EXTRACT(YEAR FROM 날짜): 특정 날짜로부터 년도만 추출
	-EXTRACT(MONTH FROM 날짜): 특정 날짜로부터 월만 추출
	-EXTRACT(DAT FROM 날짜): 특정 날짜로부터 일만 추출
*/

SELECT EXTRACT(YEAR FROM SYSDATE)
	,EXTRACT(MONTH FROM SYSDATE)
	,EXTRACT(DAY FROM SYSDATE)
FROM DUAL;

--사원명, 입사년도, 입사월, 입사일을 조회해보세요. 입사년도 기준으로 내림차순하여 조회하시오.
SELECT EMP_NAME 사원명
	,EXTRACT(YEAR FROM HIRE_DATE) 입사년도
	,EXTRACT(MONTH FROM HIRE_DATE) 입사월
	,EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE
ORDER BY "입사년도" DESC;
-------------------------------------------------------
/*
	<형변환 함수>
	
	NUMBER/DATE => CHARACTER

	-TO_CHAR(NUMBER/DATE,포맷)
	: 숫자형 또는 날짜형 데이터를 문자형 타입으로 반환(포맷에 맞춰서)
		

*/

--숫자를 문자열로
SELECT TO_CHAR(1234)
FROM DUAL; --1234 =>'1234'

SELECT TO_CHAR(1234,'00000')
FROM DUAL; --1234 => '01234' 빈갘을 0으로 채운다 
--(고정적인 값으로 변환된 숫자의 길이를 맞추고 싶으면 원하는 길이만큼 0으로채움)

SELECT TO_CHAR(1234,'99999')
FROM DUAL; -- 1234 => '1234': 빈칸을 ' '로 채운다
--(가변적인 값으로 0이거나 숫자가 없을시 값을 ' '로 채움)

SELECT TO_CHAR(1234,'FM99999')
FROM DUAL; -- 1234 => '1234': 빈칸 또는 0을 없애준다
--(FM: 좌우공백제거)

SELECT TO_CHAR(1234,'L00000')
FROM DUAL; --L: LOCAL 현재 설정된 나라의 화폐단위

SELECT TO_CHAR(1234,'L99999')
FROM DUAL;

SELECT TO_CHAR(1234,'L99,999')
FROM DUAL;

--급여정보를 3자리마다 , 로 끊어서 조회하기
SELECT EMP_NAME, SALARY, TO_CHAR(SALARY,'L99,999,999') 급여
FROM EMPLOYEE;

--날짜를 문자열로
SELECT SYSDATE
FROM DUAL;

SELECT TO_CHAR(SYSDATE)
FROM DUAL; --'23/02/04'

--2023-02-24
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD')
FROM DUAL;

--시 분 초: 오전(AM) 오후(PM)
--15:17:13 --24시간 형식
SELECT TO_CHAR(SYSDATE,'PM HH24:MI:SS')
FROM DUAL;
--12시간 형식
SELECT TO_CHAR(SYSDATE,'PM HH:MI:SS')
FROM DUAL;

SELECT TO_CHAR(SYSDATE,'MON DY, YYYY')
FROM DUAL; --'2월 금,2023': MON은 월,DY는 요일을 알려주는데 요일이라는 단어는 붙이지 않음


SELECT TO_CHAR(SYSDATE,'MON DAY, YYYY')
FROM DUAL; --2월 금요일,2023: DAY로 작성하면 요일 단어까지 붙어서 나온다.

--년도로서 쓸 수 있는 포맷
SELECT TO_CHAR(SYSDATE,'YYYY')
	,TO_CHAR(SYSDATE,'RRRR')
	,TO_CHAR(SYSDATE,'YY')
	,TO_CHAR(SYSDATE,'RR')
	,TO_CHAR(SYSDATE,'YEAR')
FROM DUAL;
--YY와 RR의 차이점
--R은 ROUND 반올림
--YY: 앞자리에 무조건 20이 붙는다(20)23
--RR: 50년 기준으로 작으면 20이 붙고 크면 19가 붙는다 -20(23) / (19)53

--월로서 쓸 수 있는 포맷
SELECT TO_CHAR(SYSDATE,'MM')
	,TO_CHAR(SYSDATE,'MON')
	,TO_CHAR(SYSDATE,'MONTH')
	,TO_CHAR(SYSDATE,'RM')
FROM DUAL; --RM: 로마숫자로 표기

--일로써 쓸 수 있는 포맷
SELECT TO_CHAR(SYSDATE,'D')
	,TO_CHAR(SYSDATE,'DD')
	,TO_CHAR(SYSDATE,'DDD')
FROM DUAL;
--D: 1주일 기준으로 일요일부터 며칠째인지 알려주는 포맷
--DD: 1달 기준으로 1일부터 며칠째인지 알려주는 포맷
--DDD: 1년 기준으로 1월 1일부터 며칠째인지 알려주는 포맷

--요일로써 쓸수 있는 포맷
SELECT TO_CHAR(SYSDATE,'DY')
	,TO_CHAR(SYSDATE,'DAY')
FROM DUAL; --'요일' 단어가 붙는자의 차이

--2023년 02월 24일 (금) 포맷으로 조회하고자 한다면
SELECT TO_CHAR(SYSDATE,'YYYY"년" MM"월" DD"일" (DY)')
FROM DUAL;

--사원명, 입사일 출력해보기 위의 포맷으로
SELECT EMP_NAME, HIRE_DATE, TO_CAHR(SYSDATE,'YYYY"년" MM"월" DD"일" (DY)')
FROM EMPLOYEE;

--2010년도 이후에 입사한 사원들의 사원명과 입사일을 조회하자
SELECT EMP_NAME, HIRE_DATE, TO_CAHR(SYSDATE,'YYYY"년" MM"월" DD"일" (DY)')
FROM EMPLOYEE
--WHERE EXTRACT(YEAR FORM HIRE_DATE) >= 2010;
WHERE HIRE_DATE >= '10/01/01'; --자동형변환이 되어 비교가 된다.

/*
	NUMBER / CHARACTER => DATE
	- TO_DATE(NUMBER/CHARACTER,포맷): 숫자형 또는 문자형 데이터를 날짜형으로 변환(결과값은 DATE 타입)

*/
SELECT TO_DATE(20230201)
FROM DUAL; --기본포맷은 YY/MM/DD 이다

SELECT TO_DATE('20230201')
FROM DUAL;

SELECT TO_DATE(000101) --101
FROM DUAL; --0으로 시작하는 숫자는 숫자로 인식이 되기 때문에 0으로 시작하는 년도는 문자열로 작성하여야한다.

SELECT TO_DATE('000101')
FROM DUAL; --0으로 시작하는 년도는 문자열로 작성

SELECT TO_DATE('20100101','YYYYMMDD')
FROM DUAL; --YY/MM/DD 형식으로 나온다.

SELECT TO_DATE('000505 153010','YYMMDD HH24:MI:SS')
FROM DUAL;

SELECT TO_DATE('100630','YYMMDD')
FROM DUAL;

SELECT TO_DATE('100630','RRMMDD')
FROM DUAL; --20100630

SELECT TO_DATE('950630','RRMMDD')
FROM DUAL; --19950630 --두 자리 년도에 RR포맷을 적용시키면 50이상이면 이전세기, 50 미만이면 현재 세기로 나온다ㄴ

SELECT TO_DATE('950630','YYMMDD')
FROM DUAL; --20950630 YY는 무조건 20이(현재 세기) 붙기 때문에 2095년도가 된다.

SELECT TO_DATE('000505','YYMMDD')
FROM DUAL;

/*
	CHARACTER -> NUMBER
	-TO_NUMBER(CHARACTER, 포맷): 문자형 데이터를 숫자형으로 변환(결과값은 NUMBER형)
*/

--자동형변환의 예시 (문자열 -> 숫자)
SELECT '123'+123
FROM DUAL; --245: 자동형변환 후 산술 연산

SELECT '10,000' + '123,000'
FROM DUAL;  --숫자에 문자 , 가 포함되어 있기때문에 자동형변환이 되지 않는다

SELECT TO_NUMBER('10,000','99,999') + TO_NUMBER('123,000','999,999')
FROM DUAL; --형변환 함수로 형변환 후 연산 처리

SELECT TO_NUMBER('0123')
FROM DUAL; --123

--문자열, 숫자, 날짜 형변환(TO_CHAR, TO_NUMBER, TO_DATE)

----------------------------------------------------------------------------

--NULL : 값이 존재하지 않음을 나타내는 값
--NULL 처리 함수 : NVL, NVL2, NULLIF

--NVL(컬럼명, 해당 컬럼값이 NULL일 경우 반환할 반환값)
--햐덩 컬럼값이 존재할 경우 (NULL이 아닐경우) 기존의 컬럼값을 반환
--해당 컬럼값이 존재하지 않는 경우 (NULL인 경우) 내가 제시한 특정반환 값을 반환

--사원명, 보너스 조회를 했을때 보너스가 없는 사원은 NULL이 나왔다
--이 상황에 NULL대신 0의 값을 조회해보자.
SELECT EMP_NAME, BONUS, NVL(BONUS,0)
FROM EMPLOYEE;

--보너스 포함 연봉 조회
--SELECT EMP_NAME,(SALARY+(ASLARY*BONUS))*12 AS "보너스 포함 연봉"
SELECT EMP_NAME,SALARY*12 "연봉",,(SALARY+(SALARY*NVL(BONUS,0)))*12 AS "보너스 포함 연봉", NVL(BONUS,0) "보너스"
FROM EMPLOYEE;

--사원명, 부서코드(부서코드가 없는 경우엔 없음) 조회
--SELECT EMP_NAME,DEPT_CODE
SELECT EMP_NAME,NVL(DEPT_CODE,'없음') "부서코드"
FROM EMPLOYEE;


--NVL2(컬럼명, 결과값1, 결과값2)
--해당 컬럼값이 존재할 경우(NULL이 아닐경우) 결과값 1반환
--해당 컬럼값이 존재하지 않을 경우(NULL인 경우) 결과값 2반환

--보너스가 있는 사원은 보너스 있음, 보너스 없는 사람은 보너스 없음
SELECT EMP_NAME, BONUS, NVL2(BONUS,'보너스 있음','보너스 없음') 보너스 유무
FROM EMPLOYEE;

--사원명, 부서코드(부서코드가 있는 경우 '부서배치완료' 없는 경우 '없음') 조회해보세요
SELECT EMP_NAME, DEPT_CODE, NVL2(DEPT_CODE,'부서배치완료','없음') 부서여부
FROM EMPLOYEE;

--NULLIF(비교대상1,비교대상2): 동등비교
--두 값이 동일할 경우 NULL 반환
--두 값이 동일하지 않을 경우 비교대상1 반환

SELECT NULLIF('123','123')
FROM DUAL; --NULL 반환

SELECT NULLIF('123','456')
FROM DUAL; -- 비교대상 1인 123이 반환

--선택함수: DECODE -> 자바에서 SWITCH문과 흡사
--선택함수 유사 구문: CASE WHEN THEN 구문 -> IF문

/*
	<선택함수>
	-DECODE(비교대상, 조건값1, 결과값1, 조건값2, 결과값2, 조건값N, 결과값N,..... 결과값)

	-자바에서 SWITCH문과 흡사
	SWITCH(비교대상){
	CASE 조건값1: 결과값1; BREAK;
	CASE 조건값2: 결과값2; BREAK;
	...
	DEFAULT: 결과값;
	}
	비교대상에는 컬럼명, 산술연산(결과는 숫자), 함수(리턴값)이 들어갈 수 있다.
*/

--사번, 사원명, 주민번호, 번호에서 성별 자리 추출 후 1이면 남자 2면 여자 조회
--SELECT EMP_ID, EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별 
--DECODE의 비교대상 위치에 성별자리 추출하여 넣기
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE( SUBSTR(EMP_NO, 8, 1), 1, '남자', 2, '여자') 성별
FROM EMPLOYEE;

--사번, 사원명, 직급코드를 조회해보자
--직원들의 급여를 인상시켜서 조회하기
--직급코드가 J7인 사원은 급여를 10% 인상하여 조회
--직급코드가 J6인 사원은 급여를 15% 인상하여 조회
--직급코드가 J5인 사원은 급여를 20% 인상하여 조회
--그 외 사원들은 급여를 5%만 인상하여 조회해봅시다
--사번, 사원명, 직급코드, 급여, 인상 후 급여를 조회해보자

SELECT EMP_ID 사번
	,EMP_NAME 사원명
	,JOB_CODE 직급코드
	,SALARY 급여
	.DECODE(JOB_CODE,'J7',(SALARY+SALARY*0.1))
				,'J6',(SALARY+SALARY*0.15))
				,'J5',(SALARY+SALARY*0.20))
				,(SALARY+SALARY*0.05)) "인상 후 급여"
FROM EMPLOYEE;

/*
	CASE WHEN THEN 구문
	-DECODE 선택함수와 비교하면 EDCODE는 해당 조건검사 시 동등 비교만을 수행
	-CASE WHEN THEN 구문의 경우 특정 조건을 마음대로 제시할 수 있다.
	
	[표현법]
	CASE WHEN 조건식1 THEN 결과값1
		WHEN 조건식2 THEN 결과값2
		WHEN 조건식3 THEN 결과값3
		...
		ELSE 결과값
	END

	-자바에서 IF문과 흡사
	if(조건식1){
		결과값1
	}else{
		결과값2
	}else{
		결과값
	}
*/

--사번, 사원명, 주민번호, 번호에서 성별 자리 추출 후 1이면 남자 2면 여자 조회
--CASE WHEN THEN 구문으로 작성해보기
SELECT EMP_ID 사번
	,EMP_NAME 사원명
	,EMP_NO 주민번호
	,CASE WHEN SUBSTR(EMP_NO,8,1) = 1 THEN '남자'
	 ELSE '여자'
	END "성별"
FROM EMPLOYEE;

--급여인상을 CASE WHEN THEN으로 해보기
SELECT EMP_ID 사번
	,EMP_NAME 사원명
	,JOB_CODE 직급코드
	,SALARY 급여
	,CASE WHEN JOB_CODE = 'J7' THEN (SALARY+(SALARY*0.1))
		WHEN JOB_CODE = 'J6' THEN (SALARY+(SALARY*0.15))
		WHEN JOB_CODE ='J5' THEN (SALARY+(SALARY*0.2))
		ELSE (SALARY+(SALARY*0.05))
	END "인상 후 급여"
FROM EMPLOYEE;
--사원명, 급여, 급여 동급(SAL_LEVEL 컬럼 사용하지 않고 직접 넣기)
--급여동급 SALARY 값이 500만원 초과인 경우 '고급'
--				500만원 이하인 경우 '중급'
--				350만원 이하인 경우 '초급'
--CASE WHEN THEN 구문을 이용하여 작성해보시오
SELECT EMP_NAME 사원명
	,SALARY 급여
	,CASE WHEN SALARY > '5000000' THEN '고급'
		WHEN SALARY <= '5000000' AND SALARY >  '3500000' THEN '중급'
		ELSE '초급'
	END "급여 등급"
FROM EMPLOYEE;



















