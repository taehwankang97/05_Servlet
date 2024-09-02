SELECT
EMP_ID, EMP_NAME,EMP_NO, SALARY,JOB_NAME,NVL( DEPT_TITLE, '없음') 
FROM
EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE 
DECODE(SUBSTR(EMP_NO,8,1),1,'M',2,'F') = 'F' 
AND 
SALARY BETWEEN 4000000 AND 8000000
ORDER BY 
SALARY ASC;

-- 모든 유저 조회 
SELECT
 USER_NO,
 USER_ID,
 USER_PW,
 USER_NAME,
 TO_CHAR(ENROLL_DATE,'YYYY"년" MM"월" DD "일"') ENROLL_DATE
FROM TB_USER
ORDER BY USER_NO ASC;



-- 검색어가 이름 O 조회
SELECT
	USER_NO,
	USER_ID,
	USER_PW,
	USER_NAME,
	TO_CHAR(ENROLL_DATE,'YYYY"년" MM"월" DD "일"') ENROLL_DATE
FROM	TB_USER
WHERE 
	USER_NAME LIKE '%'||'이'||'%'
ORDER BY 
USER_NO ASC;

DELETE 
	*
FROM
	TB_USER
WHERE
	USER_NO = 8;
	-- 일치하는 USER_NO이 있음 1
 -- 없음 0



SELECT
	USER_NO
FROM
	TB_USER
WHERE 
	USER_ID = 'user02'
AND 
	USER_PW = 'user02';	
	
-- ID,PW 가 일치하는 이름의 회원 

UPDATE TB_USER
SET 
	USER_NAME = '이순신'
WHERE 
	USER_NO = 8;
	
-- 중복 되는 아이디가 있는지 조회
SELECT
COUNT(*)
FROM
	TB_USER
WHERE USER_ID = 'user02';

SELECT
*
FROM
TB_USER;

SELECT
*
FROM
TB_USER
WHERE
USER_NO = '4';



