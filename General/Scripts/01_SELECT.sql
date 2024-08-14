/* SELECT (조회)
 * 
 * - 지정된 테이블에서 원하는 데이터가 존재하는 행을
 *   선택해서 조회하는 SQL(구조적 질의 언어)
 * 
 * - 작성된 구문에 맞는 행, 열 데이터가 조회됨
 *   -> 조회 결과 행의 집합 == RESULT SET  (중요!!)
 * 
 * - 조회 결과는 0행 이상 (조건에 맞는 행이 없을 수 있다!)
 */

/* [SELECT 작성법 - 1]
 * 
 * 2) SELECT 컬럼명, 컬럼명, ....
 * 1) FROM 테이블명;
 * 
 * - 지정된 테이블의 모든 행에서
 *   특정 컬럼만 조회하기
 * */


-- EMPLOYEE 테이블에서 
-- 모든 행의 이름(EMP_NAME), 급여(SALARY) 컬럼 조회
SELECT EMP_NAME, SALARY 
FROM EMPLOYEE;


-- EMPLOYEE 테이블에서
-- 모든 행의 사번, 이름, 급여, 입사일 조회

SELECT 
	EMP_ID, 
	EMP_NAME, 
	SALARY, 
	HIRE_DATE 
FROM 
	EMPLOYEE;


-- EMPLOYEE 테이블에 존재하는 모든 행, 모든 컬럼 조회
-- * (asterisk) : "모든", 포함을 나타내는 기호
SELECT * FROM EMPLOYEE;


-- DEPARTMENT 테이블에서 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;


------------------------------------------------------------

/* 컬럼 값 산술 연산 */

/* 컬럼 값 : 행과 열이 교차되는 한 칸에 작성된 값
 * 
 * - SELECT문 작성 시
 *   컬럼명에 산술 연산을 작성하면
 *   조회 결과(RESULT SET)에서
 *   모든 행에 산술 연산이 적용된 결과 값이 조회된다!!
 * */

-- EMPLOYEE 테이블에서
-- 모든 사원의 이름, 급여, 급여 + 100만 조회
SELECT EMP_NAME, SALARY, SALARY + 1000000
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서
-- 모든 사원의 이름, 급여, 연봉(급여 * 12) 조회
SELECT EMP_NAME, SALARY, SALARY * 12
FROM EMPLOYEE;


------------------------------------------------

/* SYSDATE/CURRENT_DATE , SYSTIMESTAMP/CURRENT_TIMESTAMP */

/* * DB는 날짜/시간 관련 데이터를 다루기 굉장히 편하다!!!
 * 
 * - SYSDATE : 시스템이 나타내고 있는 현재 시간
 * - CURRENT_DATE : 현재 세션(사용자 기반) 시간
 * 
 * - SYSTIMESTAMP : 시스템이 나타내고 있는 현재 시간
 * 		              ms 단위 + 지역 포함
 * - CURRENT_TIMESTAMP : 현재 세션(사용자 기반) 시간
 * 		              ms 단위 + 지역 포함
 * */

SELECT SYSDATE, CURRENT_DATE,
			SYSTIMESTAMP, CURRENT_TIMESTAMP 
FROM DUAL;

/* DUAL (DUmmy tAbLe)
 * - 가짜 테이블(임시 테이블)
 * - 조회하려는 데이터가 실제 테이블에 존재하는 데이터가 아닌 경우에 사용
 * */


/* 날짜 데이터 연산하기 ( + , - 만 가능!!!) */

-- 날짜 + 1  == 1일 증가
-- 날짜 - 1  == 1일 감소
--> 정수 연산은 일 단위로 연산된다!!

-- 현재 시간, 어제, 내일, 모레 조회
SELECT 
	CURRENT_DATE,
	CURRENT_DATE - 1,
	CURRENT_DATE + 1,
	CURRENT_DATE + 2
FROM DUAL;


/* 알아두면 도움됨!!! */
-- 현재 시간, 한 시간 후, 1분 후, 10초 후 조회
SELECT 
	CURRENT_DATE,
	CURRENT_DATE + 1/24,
	CURRENT_DATE + 1/24/60,
	CURRENT_DATE + 1/1440,
	CURRENT_DATE + 1/24/60/60 * 10,
	CURRENT_DATE + 1/86400
	--CURRENT_DATE + 1/24/60/6 이건 안됨 할꺼면 다 계산해서 해야함
FROM DUAL;

/*날짜끼리 연산하기 (- 만 가능) */

--> 연산 결과는 일 단위 (1 == 1일)

-- TO_DATE('날짜문자열', '패턴');
--> 날짜 문자열을 패턴 형식으로 해석해여 DATE 타입으로 변환하는 함수

-- '' 호따옴표 문자열
SELECT'2024-08-15', TO_DATE('2024-08-15','YYYY-MM-DD') 
FORM DUAL;

-- 2024년 12월6일 - 2024년 8월 14
-- -> 종강까지 남은 일자 D-DAY

SELECT 
 TO_DATE('2024-12-06', 'YYYY-MM-DD')
 -TO_DATE('2024-08-14', 'YYYY-MM-DD')
FROM DUAL;

-- 점심시간 - 현재시간 == 점심시간까지 남은 싯간
/*SELECT TO_DATE('2024-08-14 12:50','YYYY-MM-DD HH24:MI')
- CURRENT_DATE 
FROM DUAL;
하루기준
**/

-- 초단위 기준
SELECT
	(TO_DATE('2024-08-14 12:50', 'YYYY-MM-DD HH24:MI')
	- CURRENT_DATE) * 24 * 60 * 60

FROM DUAL;

-- EMPLOYEE 테이블에서
-- 모든 사원의 사번, 이름, 입사일, 현재 까지 근무 일수, N년차 조회

-- CEIL 숫자 : 소수점 올림 처리
SELECT EMP_ID, EMP_NAME, HIRE_DATE,
	CURRENT_DATE - HIRE_DATE, 
	CEIL((CURRENT_DATE - HIRE_DATE) / 365) 
	
FROM EMPLOYEE ;

----------------------------------------------
/*컬럼명 별칭 지정하기 */

/*
 * 별칭 지정 방법
 * 
 * 1) 컬럼명 AS 별칭  문자O, 띄어쓰기 X,  특수문자X
 * 
 * 2) 컬럼명 AS "별칭"  문자O, 띄어쓰기 O,  특수문자O
 * 
 *  	-> AS 안써도 되긴함 대신 가독성 저하 및 썼으면 하는사람이 종종있음
 * 
 * ORACLE에서 ""의 의미
 * -> "" 내부에 작성된 글자 그래로를 인식해라!!!
 * 
 * 	EX) -  : 빼기         
 * 		 "-" : - 모양의 글자  
 *      
 * 	ORACLE에서 문자열 '' (홑따옴표)
 *  문자열 
 */

-- EMPLOYEE 테이블에서
-- 모든 사원의 사번, 이름, 입사일, 현재 까지 근무 일수, N년차 조회
SELECT 
	EMP_ID AS 사번, -- 컬럼명 AS 별칭 
	EMP_NAME 이름, -- 컬럼명 별칭 (AS 생략)
	HIRE_DATE AS "입사한 날짜", -- 컬럼명 AS "별칭"
	CURRENT_DATE - HIRE_DATE  "근무 일수$$",
	CEIL( (CURRENT_DATE - HIRE_DATE) / 365 ) "N년째 근무중"
FROM EMPLOYEE;

--EMPLOYEE 테이블에서 
-- 모든 사원의 사번, 이름, 급여, 연봉조회 
-- 단, 컬럼명은 모두 별칭 사용

SELECT 
	EMP_ID  사번,
	EMP_NAME AS 이름, 
	SALARY AS "급여(원)", 
	SALARY * 12 AS "연봉(급여*12)"
FROM EMPLOYEE ; 

-------------------------------------------------

/*연결 연산자 (||)
 * 
 * - 두 컬럼을 이어서 하나의 컬럼으로 조회 할때 사용
 * 
 */

SELECT EMP_ID , EMP_NAME,
EMP_ID || EMP_NAME 
FROM EMPLOYEE;

/* SELECT절에 컬럼명이 아닌 리터럴(값) 작성하는 경우
 * 
 * -조회 결과에 작성된 리터럴 컬럼이 추가되고,
 * 모든 행에 리터럴이 작성되어 있음
 * */

SELECT SALARY,'원'

FROM EMPLOYEE;

SELECT SALARY||'원' AS 급여
FROM EMPLOYEE;

-----------------------------------------

/*DISTINCT(별개의, 전혀 다른)
 * 
 * - 조회 결과 집합(RESULT SET)에 
 * DISTINCT가 지정된 컬럼중 중복되는 값이 존재할 경우
 * 중복을 제거하고 한 번만 표시할때 사용하는 구문
 * */

--EMPLOYEE 테이블에서 
-- 모든 사원의 부서 코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE;

-- 사원이 있는 부서의 부서코드 조회 
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE; -- 7행 조회 (중복제거)

--EMPLOYE 테이블에 존재하는 직급코드(JOB_CODE)조회
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE ;

---------------------------------------------------
-- WHERE 절
-- 테이블에서 조건을 충족하는 행을 조회할 때 사용
-- WHERE절에는 조건식(true/false)만 작성

-- 비교 연산자 : >, <, >=, <=, = (같다), !=, <> (같지 않다)
-- 논리 연산자 : AND, OR, NOT

/*[SELECT 작성법 - 2]
 * 
 * 3) SELECT 컬럼명,....
 * 1) FROM 테이블명
 * 2) WHERE 조건식;
 * 
 * - 1>> 특정 테이블에서 
 * - 2>> 조건식을 만족하는 행을 추려놓고
 * - 3>> 추려진 결과 행에서 원하는 컬럼만 조회
 */


--EMPLOYEE 테이블에서 
-- 급여서 400만원을 초과하는 사원의 
-- 사번, 이름, 급여 조회

SELECT  EMP_ID, EMP_NAME , SALARY 
FROM EMPLOYEE 
WHERE SALARY >4000000;

-- EMPLOYEE 테이블에서 
-- 급여가 500만원 이하인 사원의 급여 조화

SELECT EMP_ID, EMP_NAME,SALARY 
FROM EMPLOYEE
WHERE SALARY < 5000000;

--EMPLOYEE 테이블에서
-- 연본이 5천만원 이하인 사원의
-- 이름, 연봉 조회
SELECT EMP_NAME , (SALARY*12) AS 연봉
FROM EMPLOYEE 
WHERE (SALARY*12) <= 50000000 ;

-- 이름이 노옹철 인 사원의 
-- 사번, 이름, 전화 번호 조회
SELECT EMP_ID, EMP_NAME, PHONE 
FROM EMPLOYEE 
WHERE EMP_NAME = '노옹철'; --> ORACLE에서는 같다 는 = 하나

-- 부서 코드가 D9 이 아닌 사원의
-- 이름, 부서
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE != 'D9'; -- <>, !=  ;


----------------------------------------------------

-- NULL 비교 연산

/*컬럼명 = NULL, 컬럼명 != NULL (X) 안됨
 * 
 * -> = , != 비교 연산은 
 * 컬럼에 저장된 값을 비교하는 연산이다!!!
 * 
 * -> ORACLE DB에서 NULL은 값이 아니라 
 * 		값이 존재하지 않는다는 (빈칸) 의미
 * 	== 저장된 값이 없다.
 * 
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * 컬럼명 IS NULL / 컬럼명 IS NOT NULL (O)
 * 
 * ->지정된 컬럼에 값이 존재하지 않는 경우/ 존재하는 경우
 *    (값의 유무를 따짐)
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * 
 * -- EMPLOYEE 테이블에서 DEPT_CODE가 없는 사원 조회  
 * */

SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE  
--WHERE DEPT_CODE != NULL;
WHERE DEPT_CODE IS NULL;

-- EMPLOYEE 테이블에서 
-- BOUNUS 컬럼에 값이 있는 사원 조화
SELECT EMP_NAME,  BONUS 
FROM EMPLOYEE 
WHERE BONUS IS NOT NULL ;


/*논리 연산자 (AND/OR)*/

-- AND(그리고) : 두조건식의 결과가 TRUE인 경우
	 --> 두 조건을 모두 만족하는 행만 조회 결과에 포함
	
-- OR(또는) : 두 조건중 하나라도! TRUE인 경우에 TRUE
     --> 두 조건중 하나라도 만족하는 행만 조회 결과에 포함

-- 부서 코드가 D6인 사원중 급여가 400만을 초과하는 사원
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' AND SALARY >4000000;

-- 급여가 300만 이상 500만 미만인 사원의 
-- 사번, 이름, 급여 조화
SELECT DEPT_CODE, EMP_NAME , SALARY 
FROM EMPLOYEE
WHERE SALARY >= 3000000 AND SALARY <5000000 ;

-- 급여가 300만 미만 또는 500만 이상인 사원의
-- 사번, 이름, 급여 조회

SELECT DEPT_CODE, EMP_NAME , SALARY 
FROM EMPLOYEE
WHERE SALARY >= 5000000 OR SALARY < 3000000;

/*컬럼명 BETWEEN (A)AND(B)*/
-- 컬럼 값이 A이상 B이하인 경우 TRUE

-- EMPLOYEE 테이블에서 
-- 급여가  400만 이상 600 만 이하인 사원의 
-- 이름 급여 조회 

--1) AND VER
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000
  AND SALARY <= 6000000;

-- 2) BETWEEN VER
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 4000000 AND 6000000; -- 같은 결과 반환 됨 

/*컬럼명 NOT BETWEEN (A)AND(B)*/
-- 컬럼 값이 A이상 B이하가 아닌 경우 TRUE
-- == A미만, B초과

SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 4000000 AND 6000000; -- 나머지 나옴 


/* 날짜도 범위 비교 가능!!
 * EMPLOYEE 테이블에서
 * 2010년대 입사한 사원의
 * 사번, 이름, 입사일 조회 
 * */

SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE >= TO_DATE('2010-01-01','YYYY-MM-DD')
AND HIRE_DATE <= TO_DATE('2019-12-31', 'YYYY-MM-DD');

SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE 
	BETWEEN
	TO_DATE('2010-01-01', 'YYYY-MM-DD')
  AND 
  TO_DATE('2019-12-31', 'YYYY-MM-DD');
 
 /*일치하는 값만 조회*/
 
 -- 부서코드가 D5,D6,D9 인 사원의 
 -- 사번, 이름 , 부서코드 조회
 SELECT EMP_ID, EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D5'OR
DEPT_CODE ='D6'OR
DEPT_CODE ='D9'; 

/*컬럼명 IN(값1, 값2, 값3 .....)*/
-- 컬럼 값이 IN() 내에 존재하면 TURE --> 조회 결과에 포함
-- 연속으로 OR 연산을 작성한 것과 같은 효과

SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9');

/*컬럼명 NOT IN(값1, 값2, 값3 .....)*/
-- 컬럼 값이 IN() 내에 존재하지 않으면 TURE --> 조회 결과에 포함
-- 연속으로 OR 연산을 작성한 것과 같은 효과
-- D5, D6, D9제외 한


SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D5', 'D6', 'D9'); --(NULL 미포함)


SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D5', 'D6', 'D9')
OR DEPT_CODE IS NULL; --(NULL 포함)


