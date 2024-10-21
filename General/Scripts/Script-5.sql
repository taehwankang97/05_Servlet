/* 관리자 계정(sys) 접속 후 수행*/
/*
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- 계정 생성
CREATE USER SPRING_BDH IDENTIFIED BY SPRING1234;

-- 권한 부여
GRANT CONNECT, RESOURCE TO SPRING_BDH;

-- 테이블 저장 공간 할당
ALTER USER SPRING_BDH
DEFAULT TABLESPACE USERS
QUOTA 100M ON USERS;
*/

--------------------------------------------------------------------

/* SPRING 계정 접속 후 테이블, 시퀀스 생성 */
/* 회원("MEMBER") */
CREATE TABLE KH_HYG."MEMBER"(
	"MEMBER_NO" 		NUMBER,
	"MEMBER_EMAIL" 		VARCHAR2(50)  NOT NULL,
	"MEMBER_PW" 		VARCHAR2(100) NOT NULL,
	"MEMBER_NICKNAME"   NVARCHAR2(10) NOT NULL,
	"MEMBER_TEL"		CHAR(11)      NOT NULL,
	"MEMBER_ADDRESS"	NVARCHAR2(150),
	"PROFILE_IMG"		VARCHAR2(300),
	"ENROLL_DATE"		DATE DEFAULT CURRENT_DATE,
	"MEMBER_DEL_FL"		CHAR(1) DEFAULT 'N',
	"AUTHORITY"			NUMBER DEFAULT 1,
	CONSTRAINT "MEMBER_PK" PRIMARY KEY("MEMBER_NO"),
	
	CONSTRAINT "MEMBER_DEL_FL_CHK"
	CHECK("MEMBER_DEL_FL" IN ('Y', 'N')),
	
	CONSTRAINT "AUTHORITY_CHK"
	CHECK("AUTHORITY" IN (1, 2))
);


-- COMMENT 추가
COMMENT ON COLUMN "MEMBER"."MEMBER_NO" 		 IS '회원 번호(PK)';
COMMENT ON COLUMN "MEMBER"."MEMBER_EMAIL" 	 IS '회원 이메일(ID)';
COMMENT ON COLUMN "MEMBER"."MEMBER_PW" 		 IS '회원 비밀번호';
COMMENT ON COLUMN "MEMBER"."MEMBER_NICKNAME" IS '회원명(별명)';
COMMENT ON COLUMN "MEMBER"."MEMBER_TEL" 	 IS '회원 전화번호(-제외)';
COMMENT ON COLUMN "MEMBER"."MEMBER_ADDRESS"  IS '회원 주소';
COMMENT ON COLUMN "MEMBER"."PROFILE_IMG" 	 IS '프로필 이미지 경로';
COMMENT ON COLUMN "MEMBER"."ENROLL_DATE" 	 IS '가입일';
COMMENT ON COLUMN "MEMBER"."MEMBER_DEL_FL"   IS '탈퇴 여부(Y,N)';
COMMENT ON COLUMN "MEMBER"."AUTHORITY" 		 IS '권한(1:일반, 2:관리자)';


-- 회원 번호 시퀀스 생성
CREATE SEQUENCE SEQ_MEMBER_NO NOCACHE;

-- 샘플 회원 데이터 삽입
INSERT INTO "MEMBER"
VALUES(SEQ_MEMBER_NO.NEXTVAL, 'member01@kh.or.kr', 'pass01!',
	  '샘플1', '01012341234', NULL, NULL,
	   DEFAULT, DEFAULT, DEFAULT);
	  
COMMIT;

SELECT * FROM "MEMBER";


-- 샘플 데이터 비밀번호 암호화 적용
UPDATE "MEMBER"
SET
	"MEMBER_PW" = '$2a$10$KzFKEvO4C65xBTetZDV8QufZvhQnIGU0SE5ZEaZo0T9SrdYS5oFMC'
WHERE
	"MEMBER_NO" = 1;

COMMIT;

SELECT * FROM "MEMBER";


/* 회원 정보 수정 */
UPDATE "MEMBER"
SET 
	MEMBER_NICKNAME = ?,
	MEMBER_TEL = ?,
	MEMBER_ADDRESS =?
WHERE
	MEMBER_NO = ?; 



INSERT INTO "MEMBER"
VALUES(
	SEQ_MEMBER_NO.NEXTVAL, 
	'member02@kh.or.kr', 
	'$2a$10$KzFKEvO4C65xBTetZDV8QufZvhQnIGU0SE5ZEaZo0T9SrdYS5oFMC',
	 '샘플2', 
	 '01022222222', 
	 NULL, NULL, DEFAULT, DEFAULT, DEFAULT);

INSERT INTO "MEMBER"
VALUES(
	SEQ_MEMBER_NO.NEXTVAL, 
	'member03@kh.or.kr', 
	'$2a$10$KzFKEvO4C65xBTetZDV8QufZvhQnIGU0SE5ZEaZo0T9SrdYS5oFMC',
	 '샘플3', 
	 '01033333333', 
	 NULL, NULL, DEFAULT, DEFAULT, DEFAULT);

COMMIT;

-- 모든 회원 탈퇴 복구
UPDATE 
	"MEMBER"
SET
	MEMBER_DEL_FL = 'N';

COMMIT;




-- 이메일 중복 검사(탈퇴 안한 회원 중 중복 확인)
SELECT COUNT(*)
FROM "MEMBER"
WHERE MEMBER_EMAIL = 'member033@kh.or.kr'
AND   MEMBER_DEL_FL = 'N';


-- 파일 업로드 테스트용 테이블
CREATE TABLE TB_FILE_TEST(
	FILE_NO NUMBER PRIMARY KEY,
	FILE_ORIGINAL_NAME VARCHAR2(300), -- 원본 파일명
	FILE_RENAME VARCHAR2(300), -- 변경된 파일명
	FILE_PATH VARCHAR2(300), -- 파일이 저장된 폴더명
	UPDATE_DATE DATE DEFAULT CURRENT_DATE -- 저장된 날짜
);

CREATE SEQUENCE SEQ_FILE_NO NOCACHE; -- 시퀀스 생성



SELECT * FROM TB_FILE_TEST;


UPDATE TB_FILE_TEST
SET FILE_PATH = '/images/test/';

COMMIT;

-------------------------------------------------------------------------------

CREATE TABLE "MEMBER" (
	"MEMBER_NO"	NUMBER		NOT NULL,
	"MEMBER_EMAIL"	VARCHAR2(50)		NOT NULL,
	"MEMBER_PW"	VARCHAR2(100)		NOT NULL,
	"MEMBER_NICKNAME"	NVARCHAR2(10)		NOT NULL,
	"MEMBER_TEL"	CHAR(11)		NOT NULL,
	"MEMBER_ADDRESS"	NVARCHAR2(150)		NULL,
	"PROFILE_IMG"	VARCHAR2(300)		NULL,
	"ENROLL_DATE"	DATE	DEFAULT CURRENT_DATE	NOT NULL,
	"MEMBER_DEL_FL"	CHAR(1)	DEFAULT 'N'	NOT NULL,
	"AUTHORITY"	NUMBER	DEFAULT 1	NOT NULL
);

COMMENT ON COLUMN "MEMBER"."MEMBER_NO" IS '회원 번호(SEQ_MEMBER_NO)';
COMMENT ON COLUMN "MEMBER"."MEMBER_EMAIL" IS '회원 이메일(ID)';
COMMENT ON COLUMN "MEMBER"."MEMBER_PW" IS '회원 비밀번호(암호화)';
COMMENT ON COLUMN "MEMBER"."MEMBER_NICKNAME" IS '회원명(별명)';
COMMENT ON COLUMN "MEMBER"."MEMBER_TEL" IS '회원 전화번호(-제외)';
COMMENT ON COLUMN "MEMBER"."MEMBER_ADDRESS" IS '회원 주소';
COMMENT ON COLUMN "MEMBER"."PROFILE_IMG" IS '프로필 이미지 경로';
COMMENT ON COLUMN "MEMBER"."ENROLL_DATE" IS '가입일';
COMMENT ON COLUMN "MEMBER"."MEMBER_DEL_FL" IS '탈퇴 여부('Y', 'N')';
COMMENT ON COLUMN "MEMBER"."AUTHORITY" IS '권한(1:일반, 2:관리자)';


CREATE TABLE "BOARD" (
	"BOARD_NO"	NUMBER		NOT NULL,
	"BOARD_TITLE"	NVARCHAR2(100)		NOT NULL,
	"BOARD_CONTENT"	VARCHAR2(4000)		NOT NULL,
	"BOARD_WRITE_DATE"	DATE	DEFAULT CURRENT_DATE	NOT NULL,
	"BOARD_UPDATE_DATE"	DATE		NULL,
	"READ_COUNT"	NUMBER	DEFAULT 0	NOT NULL,
	"BOARD_DEL_FL"	CHAR(1)	DEFAULT 'N'	NOT NULL,
	"MEMBER_NO"	NUMBER		NOT NULL,
	"BOARD_CODE"	NUMBER		NOT NULL
);

COMMENT ON COLUMN "BOARD"."BOARD_NO" IS '게시글 번호(SEQ_BOARD_NO)';
COMMENT ON COLUMN "BOARD"."BOARD_TITLE" IS '게시글 제목';
COMMENT ON COLUMN "BOARD"."BOARD_CONTENT" IS '게시글 내용';
COMMENT ON COLUMN "BOARD"."BOARD_WRITE_DATE" IS '게시글 작성일';
COMMENT ON COLUMN "BOARD"."BOARD_UPDATE_DATE" IS '마지막 수정일';
COMMENT ON COLUMN "BOARD"."READ_COUNT" IS '조회 수';
COMMENT ON COLUMN "BOARD"."BOARD_DEL_FL" IS '삭제 여부(N, Y)';
COMMENT ON COLUMN "BOARD"."MEMBER_NO" IS '작성자 회원 번호';
COMMENT ON COLUMN "BOARD"."BOARD_CODE" IS '게시판 종류 코드 번호';



CREATE TABLE "BOARD_IMG" (
	"IMG_NO"	NUMBER		NOT NULL,
	"IMG_PATH"	VARCHAR2(200)		NOT NULL,
	"IMG_ORIGINAL_NAME"	NVARCHAR2(50)		NOT NULL,
	"IMG_RENAME"	NVARCHAR2(50)		NOT NULL,
	"IMG_ORDER"	NUMBER		NULL,
	"BOARD_NO"	NUMBER		NOT NULL
);

COMMENT ON COLUMN "BOARD_IMG"."IMG_NO" IS '이미지 번호(SEQ_IMG_NO)';
COMMENT ON COLUMN "BOARD_IMG"."IMG_PATH" IS '이미지 요청 경로';
COMMENT ON COLUMN "BOARD_IMG"."IMG_ORIGINAL_NAME" IS '이미지 원본명';
COMMENT ON COLUMN "BOARD_IMG"."IMG_RENAME" IS '이미지 변경명';
COMMENT ON COLUMN "BOARD_IMG"."IMG_ORDER" IS '이미지 순서';
COMMENT ON COLUMN "BOARD_IMG"."BOARD_NO" IS '이미지가 첨부된 게시글 번호';


CREATE TABLE "BOARD_TYPE" (
	"BOARD_CODE"	NUMBER		NOT NULL,
	"BOARD_NAME"	NVARCHAR2(20)		NOT NULL
);

COMMENT ON COLUMN "BOARD_TYPE"."BOARD_CODE" IS '게시판 종류 코드 번호';
COMMENT ON COLUMN "BOARD_TYPE"."BOARD_NAME" IS '게시판 이름';


CREATE TABLE "BOARD_LIKE" (
	"MEMBER_NO"	NUMBER		NOT NULL,
	"BOARD_NO"	NUMBER		NOT NULL
);

COMMENT ON COLUMN "BOARD_LIKE"."MEMBER_NO" IS '좋아요를 누른 회원 번호';
COMMENT ON COLUMN "BOARD_LIKE"."BOARD_NO" IS '좋아요가 눌러진 게시글 번호';


CREATE TABLE "COMMENT" (
	"COMMENT_NO"	NUMBER		NOT NULL,
	"COMMENT_CONTENT"	VARCHAR2(4000)		NOT NULL,
	"COMMENT_WRITE_DATE"	DATE	DEFAULT CURRENT_DATE	NOT NULL,
	"COMMENT_DEL_FL"	CHAR(1)	DEFAULT 'N'	NOT NULL,
	"MEMBER_NO"	NUMBER		NOT NULL,
	"BOARD_NO"	NUMBER		NOT NULL,
	"PARENT_COMMENT_NO"	NUMBER		NULL
);

COMMENT ON COLUMN "COMMENT"."COMMENT_NO" IS '댓글 번호(SEQ_COMMENT_NO)';
COMMENT ON COLUMN "COMMENT"."COMMENT_CONTENT" IS '댓글 내용';
COMMENT ON COLUMN "COMMENT"."COMMENT_WRITE_DATE" IS '댓글 작성일';
COMMENT ON COLUMN "COMMENT"."COMMENT_DEL_FL" IS '댓글 삭제 여부(N, Y)';
COMMENT ON COLUMN "COMMENT"."MEMBER_NO" IS '회원 번호(SEQ_MEMBER_NO)';
COMMENT ON COLUMN "COMMENT"."BOARD_NO" IS '게시글 번호(SEQ_BOARD_NO)';
COMMENT ON COLUMN "COMMENT"."PARENT_COMMENT_NO" IS '부모 댓글 번호';



ALTER TABLE "MEMBER" ADD CONSTRAINT "PK_MEMBER" PRIMARY KEY (
	"MEMBER_NO"
);

ALTER TABLE "BOARD" ADD CONSTRAINT "PK_BOARD" PRIMARY KEY (
	"BOARD_NO"
);

ALTER TABLE "BOARD_IMG" ADD CONSTRAINT "PK_BOARD_IMG" PRIMARY KEY (
	"IMG_NO"
);

ALTER TABLE "BOARD_TYPE" ADD CONSTRAINT "PK_BOARD_TYPE" PRIMARY KEY (
	"BOARD_CODE"
);

ALTER TABLE "BOARD_LIKE" ADD CONSTRAINT "PK_BOARD_LIKE" PRIMARY KEY (
	"MEMBER_NO",
	"BOARD_NO"
);

ALTER TABLE "COMMENT" ADD CONSTRAINT "PK_COMMENT" PRIMARY KEY (
	"COMMENT_NO"
);

ALTER TABLE "BOARD" ADD CONSTRAINT "FK_MEMBER_TO_BOARD_1" FOREIGN KEY (
	"MEMBER_NO"
)
REFERENCES "MEMBER" (
	"MEMBER_NO"
);

ALTER TABLE "BOARD" ADD CONSTRAINT "FK_BOARD_TYPE_TO_BOARD_1" FOREIGN KEY (
	"BOARD_CODE"
)
REFERENCES "BOARD_TYPE" (
	"BOARD_CODE"
);

ALTER TABLE "BOARD_IMG" ADD CONSTRAINT "FK_BOARD_TO_BOARD_IMG_1" FOREIGN KEY (
	"BOARD_NO"
)
REFERENCES "BOARD" (
	"BOARD_NO"
);

ALTER TABLE "BOARD_LIKE" ADD CONSTRAINT "FK_MEMBER_TO_BOARD_LIKE_1" FOREIGN KEY (
	"MEMBER_NO"
)
REFERENCES "MEMBER" (
	"MEMBER_NO"
);

ALTER TABLE "BOARD_LIKE" ADD CONSTRAINT "FK_BOARD_TO_BOARD_LIKE_1" FOREIGN KEY (
	"BOARD_NO"
)
REFERENCES "BOARD" (
	"BOARD_NO"
);

ALTER TABLE "COMMENT" ADD CONSTRAINT "FK_MEMBER_TO_COMMENT_1" FOREIGN KEY (
	"MEMBER_NO"
)
REFERENCES "MEMBER" (
	"MEMBER_NO"
);

ALTER TABLE "COMMENT" ADD CONSTRAINT "FK_BOARD_TO_COMMENT_1" FOREIGN KEY (
	"BOARD_NO"
)
REFERENCES "BOARD" (
	"BOARD_NO"
);

ALTER TABLE "COMMENT" ADD CONSTRAINT "FK_COMMENT_TO_COMMENT_1" FOREIGN KEY (
	"PARENT_COMMENT_NO"
)
REFERENCES "COMMENT" (
	"COMMENT_NO"
);


/* BOARD 테이블 BOARD_DEL_FL CHECK 제약 조건 추가*/
ALTER TABLE "BOARD"
ADD CONSTRAINT "CHK_BOARD_DEL_FL"
CHECK(BOARD_DEL_FL IN ('Y', 'N'));


/* COMMNET 테이블 BOARD_DEL_FL CHECK 제약 조건 추가*/
ALTER TABLE "COMMENT"
ADD CONSTRAINT "CHK_COMMENT_DEL_FL"
CHECK(COMMENT_DEL_FL IN ('Y', 'N'));


--------------------------------------------------------------------
/* 게시판 종류 (BOARD_TYPE) 추가 */
INSERT INTO "BOARD_TYPE" VALUES (1, '공지 사항');
INSERT INTO "BOARD_TYPE" VALUES (2, '자유 게시판');
INSERT INTO "BOARD_TYPE" VALUES (3, '정보 게시판');
COMMIT;

----------------------------------------------------------------

/* 게시글 번호 시퀀스 생성 */
CREATE SEQUENCE SEQ_BOARD_NO NOCACHE;

/* PL/SQL을 이용해서 BOARD 테이블에 샘플 데이터 삽입 */
BEGIN 
	FOR I IN 1..2000 LOOP
		INSERT INTO "BOARD"
		VALUES(
			SEQ_BOARD_NO.NEXTVAL,
			SEQ_BOARD_NO.CURRVAL || '번째 게시글',
			SEQ_BOARD_NO.CURRVAL || '번째 게시글 내용 입니다',
			DEFAULT, DEFAULT, DEFAULT, DEFAULT,
			1, 
			CEIL( DBMS_RANDOM.VALUE(0,3) )
		);
	END LOOP;
END;

-- ALT + X로 실행

-- 삽입된 행의 개수 확인
SELECT COUNT(*) FROM BOARD;

-- 확인되면 COMMIT;
COMMIT;


-- 게시판 종류 별로 샘플 데이터 개수 확인
SELECT BOARD_CODE, COUNT(*)
FROM "BOARD"
GROUP BY BOARD_CODE
ORDER BY BOARD_CODE ASC;


-----------------------------------------------

/* 댓글 번호 시퀀스 생성 */
CREATE SEQUENCE SEQ_COMMENT_NO NOCACHE;


/* 댓글 테이블("COMMENT")에 샘플 데이터 삽입 */
BEGIN
	FOR I IN 1..3000 LOOP
		INSERT INTO "COMMENT"
		VALUES(
			SEQ_COMMENT_NO.NEXTVAL,
			SEQ_COMMENT_NO.CURRVAL || '번째 댓글',
			DEFAULT, DEFAULT,
			1, 
			CEIL (DBMS_RANDOM.VALUE(0, 1999) ),
			NULL 
		);
	END LOOP;
END;

SELECT COUNT(*) FROM "COMMENT";
COMMIT;

-- 게시글 번호별 작성된 댓글 개수 조회
SELECT BOARD_NO, COUNT(*) 
FROM "COMMENT"
GROUP BY BOARD_NO 
ORDER BY BOARD_NO DESC;


--------------------------------------------------------------

/* 특정 게시판(BOARD_CODE)에
 * 삭제되지 않은 게시글 목록 조회
 * 
 * - 조회된 행 번호 : ROWNUM 또는 ROW_NUMBER() 이용
 *   게시글 번호, 제목, 조회수, 작성일 : BOARD 테이블 컬럼
 * 
 *   작성자 닉네임 : MEMBER 테이블 MEMBER_NICKNAME 컬럼
 * 
 *   댓글 수 : COMMET 테이블에서 BOARD_NO 별 댓글 개수 COUNT(*)
 * 
 *   좋아요 개수 : BOARD_LIKE 테이블에서 BOARD_NO 별 댓글 개수 COUNT(*)
 * 
 * - 작성일은 몇 초/분/시간 전 또는 YYYY-MM-DD 형식으로 조회
 * 
 * - 가장 최근 글이 제일 처음 조회
 *   (시퀀스 번호로 만들어진 BOARD_NO를 이용)
 * */

-- ROW_NUMBER() OVER (ORDER BY BOARD_NO ASC) AS "RNUM"
 -->  BOARD_NO 오름차순으로 정렬 후 조회된 행의 번호를 지정
 --   + 해당 컬럼 별칭을 "RNUM" 지정 
 --> 연속 되지 않은 PK 대신 연속된 숫자를 만들려고 사용!

-- 상관 서브쿼리 해석 순서
-- 1) 메인 쿼리 1행 해석
-- 2) 서브 쿼리에서 메인 쿼리 1행 조회 결과를 이용 -> 해석
-- 3) 다시 메인 쿼리 해석


SELECT 
	ROW_NUMBER() OVER (ORDER BY BOARD_NO ASC) AS "RNUM",
	BOARD_NO,
	BOARD_TITLE,
	READ_COUNT,
	MEMBER_NICKNAME,
	(SELECT COUNT(*) 
	 FROM "COMMENT" C
	 WHERE C.BOARD_NO = B.BOARD_NO) AS "COMMENT_COUNT",
	 
	(SELECT COUNT(*)
	 FROM "BOARD_LIKE" L
	 WHERE L.BOARD_NO = B.BOARD_NO) AS "LIKE_COUNT",
	 
	CASE 
		WHEN CURRENT_DATE - BOARD_WRITE_DATE  < 1 / 24 / 60
		THEN FLOOR( (CURRENT_DATE - BOARD_WRITE_DATE) 
					* 24 * 60 * 60 ) || '초 전'
		WHEN CURRENT_DATE - BOARD_WRITE_DATE  < 1 / 24
		THEN FLOOR( (CURRENT_DATE - BOARD_WRITE_DATE) 
					* 24 * 60  ) || '분 전'
		WHEN CURRENT_DATE - BOARD_WRITE_DATE  < 1 
		THEN FLOOR( (CURRENT_DATE - BOARD_WRITE_DATE) 
					* 24 ) || '시간 전'
		ELSE TO_CHAR(BOARD_WRITE_DATE, 'YYYY-MM-DD')
	END AS "BOARD_WRITE_DATE"
	
	,
	(SELECT IMG_PATH || IMG_RENAME 
	 FROM BOARD_IMG I 
	 WHERE IMG_ORDER = 0 
	 AND I.BOARD_NO = B.BOARD_NO) AS THUMBNAIL
	
FROM
	"BOARD" B
JOIN
	"MEMBER" M ON (B.MEMBER_NO = M.MEMBER_NO)
WHERE 
	BOARD_DEL_FL = 'N' -- 삭제 안된 글
AND   
	BOARD_CODE = 1     -- 게시판 종류
ORDER BY 
	RNUM DESC
;
	




-- DATE 타입 끼리 - 연산 시 결과 == 몇 일 차이(일 단위)
SELECT CURRENT_DATE 
	- TO_DATE('2024-10-01 22:36:00', 
			  'YYYY-MM-DD HH24:MI:SS')
FROM DUAL;



INSERT INTO "BOARD"
VALUES(
	SEQ_BOARD_NO.NEXTVAL,
	SEQ_BOARD_NO.CURRVAL || '번째 게시글',
	SEQ_BOARD_NO.CURRVAL || '번째 게시글 내용 입니다',
	DEFAULT, DEFAULT, DEFAULT, DEFAULT,
	1, 
	1
);

COMMIT;



SELECT COUNT(*)
  	FROM "BOARD"
  	WHERE BOARD_CODE = 3
  	AND BOARD_DEL_FL = 'N';


SELECT SEQ_BOARD_NO.NEXTVAL FROM DUAL;



-- ---------------------------------------------------------

-- 이미지 번호 생성용 시퀀스
CREATE SEQUENCE SEQ_IMG_NO NOCACHE;

/* 여러 행을 한 번에 INSERT 하는 방법 
 * 
 * 1. INSERT ALL 구문
 * 2. INSERT + SUBQUERY (사용!)
 * 
 * [문제점] 위에 두 방법 다 SEQUENCE를 직접 사용 불가!!
 * */


-- SEQ_IMG_NO 시퀀스의 다음 값을 반환하는 함수 생성
CREATE OR REPLACE FUNCTION NEXT_IMG_NO

-- 반환형
RETURN NUMBER

-- 사용할 변수
IS IMG_NO NUMBER;

BEGIN 
	SELECT SEQ_IMG_NO.NEXTVAL 
	INTO IMG_NO
	FROM DUAL;

	RETURN IMG_NO;
END;
;






INSERT INTO "BOARD_IMG"
(
	SELECT NEXT_IMG_NO(),
		'/images/board/', '원본명','변경명',1,2000
	FROM DUAL
	
	UNION ALL
	
	SELECT NEXT_IMG_NO(),
		'/images/board/', '원본명','변경명',1,2000
	FROM DUAL
	
	UNION ALL
	
	SELECT NEXT_IMG_NO(),
		'/images/board/', '원본명','변경명',1,2000
	FROM DUAL
);

ROLLBACK;

SELECT * FROM "BOARD"
ORDER BY BOARD_NO DESC;


SELECT * FROM "BOARD_IMG";

COMMIT;


---------------------------------------------------------

/* 게시글 상세 조회*/
SELECT 
	BOARD_NO, BOARD_TITLE, BOARD_CONTENT,
	BOARD_CODE, READ_COUNT, B.MEMBER_NO ,
	MEMBER_NICKNAME, PROFILE_IMG,
	
	TO_CHAR(BOARD_WRITE_DATE, 'YYYY"년" MM"월" DD"일" HH24:MI:SS')
		AS BOARD_WRITE_DATE,
		
	TO_CHAR(BOARD_UPDATE_DATE, 'YYYY"년" MM"월" DD"일" HH24:MI:SS')
		AS BOARD_UPDATE_DATE,
		
	(SELECT COUNT(*) 
	 FROM BOARD_LIKE L
	 WHERE L.BOARD_NO = 2013) AS LIKE_COUNT,
	 
	(SELECT IMG_PATH || IMG_RENAME
	 FROM BOARD_IMG I
	 WHERE I.BOARD_NO = 2013
	 AND IMG_ORDER = 0) AS THUMBNAIL
	
FROM "BOARD" B
JOIN "MEMBER" M ON (B.MEMBER_NO = M.MEMBER_NO)
WHERE BOARD_NO = 2013
AND   BOARD_CODE = 1

;


-----------------------------------------------------------------

/*댓글 샘플 데이터 추가*/
INSERT INTO "COMMENT"
VALUES(
	SEQ_COMMENT_NO.NEXTVAL,
	'부모 댓글 3', -- 1 ~ 3 까지 실행
	DEFAULT, 
	DEFAULT,
	2,  -- 회원 번호
	2019, -- 게시글 번호 
	NULL 
);

COMMIT;

-- 부모 댓글 1의 자식 댓글 

INSERT INTO "COMMENT"
VALUES(
	SEQ_COMMENT_NO.NEXTVAL,
	'자식 댓글 2-2', -- 1-1 ~ 1-2 , 2-1 ~ 2-2 까지 실행
	DEFAULT, 
	DEFAULT,
	2,  -- 회원 번호
	2019, -- 게시글 번호 
	3004 
);

-- 후손 댓글
INSERT INTO "COMMENT"
VALUES(
	SEQ_COMMENT_NO.NEXTVAL,
	'후손 댓글 1-1-2', -- 1-1 ~ 1-2 , 2-1 ~ 2-2 까지 실행
	DEFAULT, 
	DEFAULT,
	2,  -- 회원 번호
	2019, -- 게시글 번호 
	3006 
);

/* 특정 게시글의 댓글 목록 조회 + 계층형 쿼리*/
-- LEVEL 컬럼 : 현재 계층 레벨 출력
SELECT LEVEL, COMMENT_NO, PARENT_COMMENT_NO, COMMENT_CONTENT
FROM "COMMENT"
WHERE BOARD_NO = 2019

/*계층형 쿼리 코드 추가*/
-- PARENT_COMMENT_NO 값이 NULL인 행이 계층의 시작이다 
-- == LEVEL == 1 
START WITH PARENT_COMMENT_NO IS NULL
-- PARENT_COMMENT_NO 값이 COMMENT_NO와 같은 행을 
-- 자식으로 지정하여 연결
CONNECT BY PRIOR COMMENT_NO = PARENT_COMMENT_NO

-- 형제들(같은 레벨)간의 정렬 순서를 COMMENT_NO 오름차순
ORDER SIBLINGS BY COMMENT_NO ASC;

/*실제 사용할 댓글 목록 조회 + 계층형 쿼리*/

SELECT LEVEL, C.* FROM
	(SELECT COMMENT_NO, COMMENT_CONTENT,
	    TO_CHAR(COMMENT_WRITE_DATE, 'YYYY"년" MM"월" DD"일" HH24"시" MI"분" SS"초"') COMMENT_WRITE_DATE,
	    BOARD_NO, MEMBER_NO, MEMBER_NICKNAME, PROFILE_IMG, PARENT_COMMENT_NO, COMMENT_DEL_FL
	FROM "COMMENT"
	JOIN MEMBER USING(MEMBER_NO)
	WHERE BOARD_NO = 2019) C
WHERE COMMENT_DEL_FL = 'N'
OR 0 != (SELECT COUNT(*) FROM "COMMENT" SUB
				WHERE SUB.PARENT_COMMENT_NO = C.COMMENT_NO
				AND COMMENT_DEL_FL = 'N')
START WITH PARENT_COMMENT_NO IS NULL
CONNECT BY PRIOR COMMENT_NO = PARENT_COMMENT_NO
ORDER SIBLINGS BY COMMENT_NO
;



INSERT INTO "BOARD_TYPE"
VALUES(4, '테스트');

COMMIT;

  
  SELECT COUNT(*)
  FROM "BOARD"
  JOIN "MEMBER" USING ("MEMBER_NO") --작성자 검색 (제목검색 , 내용검색은 주석후 실행)
  WHERE BOARD_CODE = 1 
  AND BOARD_DEL_FL = 'N'
 
 -- 제목 검색인 경우
 AND BOARD_TITLE LIKE '%'|| '11' || '%';

-- 내용 검색인 경우
--AND BOARD_COTENT LIKE '%'|| '11' || '%'
  
  -- 제목 또는 내용 검색
 -- AND( BOARD_TITLE LIKE '%' || '11' || '%'
  -- OR BOARD_CONTENT LIKE '%' || '11' || '%');
  
  -- 작성자 검사 
  AND MEMBER_NICKNAME '%' || '11' || '%';
  
 
 SELECT RNUM, BOARD_NO, CEIL(RNUM/10)CP
 FROM
 	(SELECT 
 	ROW_NUMBER() OVER(ORDER BY BOARD_NO DESC) RNUM
 	,BOARD_NO
 FROM "BOARD"
 JOIN "MEMBER" USING(MEMBER_NO)
 WHERE BOARD_CODE = 1
 AND 
 	BOARD_DEL_FL = 'N'
-- AND BOARD_TITLE LIKE '%'||'11'||'%'
-- AND BOARD_CONTENT LIKE '%'||'11'||'%'
/* AND BOARD_TITLE LIKE '%'||'11'||'%'
 OR
 BOARD_CONTENT LIKE '%'||'11'||'%')*/
 	
 	AND MEMBER_NICKNAME LIKE '%'||'나'||'%')
 WHERE BOARD_NO = 1820;
/* 알림 */

/* 알림 테이블 */
CREATE TABLE "NOTIFICATION" (
   "NOTIFICATION_NO"   NUMBER      NOT NULL,
   "NOTIFICATION_CONTENT"   VARCHAR2(1000)      NOT NULL,
   "NOTIFICATION_CHECK"   CHAR(1)   DEFAULT 'N'   NOT NULL,
   "NOTIFICATION_DATE"   DATE   DEFAULT CURRENT_DATE   NOT NULL,
   "NOTIFICATION_URL"   VARCHAR2(1000)      NOT NULL,
   "SEND_MEMBER_NO"   NUMBER      NOT NULL,
   "RECEIVE_MEMBER_NO"   NUMBER      NOT NULL
);

COMMENT ON COLUMN "NOTIFICATION"."NOTIFICATION_NO" IS '알림 번호';
COMMENT ON COLUMN "NOTIFICATION"."NOTIFICATION_CONTENT" IS '알림 내용(HTML 포함)';
COMMENT ON COLUMN "NOTIFICATION"."NOTIFICATION_CHECK" IS '읽음 여부(Y,N)';
COMMENT ON COLUMN "NOTIFICATION"."NOTIFICATION_DATE" IS '알림 생성 시간';
COMMENT ON COLUMN "NOTIFICATION"."NOTIFICATION_URL" IS '연결 페이지 주소';
COMMENT ON COLUMN "NOTIFICATION"."SEND_MEMBER_NO" IS '알림 보낸 회원 번호';
COMMENT ON COLUMN "NOTIFICATION"."RECEIVE_MEMBER_NO" IS '알림 받는 회원 번호';


ALTER TABLE "NOTIFICATION" ADD CONSTRAINT "PK_NOTIFICATION" PRIMARY KEY (
   "NOTIFICATION_NO"
);

ALTER TABLE "NOTIFICATION" ADD CONSTRAINT "FK_MEMBER_TO_NOTIFICATION_1" FOREIGN KEY (
   "SEND_MEMBER_NO"
)
REFERENCES "MEMBER" (
   "MEMBER_NO"
);

ALTER TABLE "NOTIFICATION" ADD CONSTRAINT "FK_MEMBER_TO_NOTIFICATION_2" FOREIGN KEY (
   "RECEIVE_MEMBER_NO"
)
REFERENCES "MEMBER" (
   "MEMBER_NO"
);


-- 알림 번호 시퀀스 생성
CREATE SEQUENCE SEQ_NOTI_NO NOCACHE;





SELECT * FROM NOTIFICATION;
   

		SELECT 
			NOTIFICATION_NO, 
			NOTIFICATION_CONTENT, 
			NOTIFICATION_URL, 
			PROFILE_IMG AS SEND_MEMBER_PROFILE_IMG, 
			SEND_MEMBER_NO, 
			RECEIVE_MEMBER_NO,
			NOTIFICATION_CHECK,
			CASE 
				WHEN TRUNC(NOTIFICATION_DATE) = TRUNC(CURRENT_DATE) THEN TO_CHAR(NOTIFICATION_DATE, 'AM HH:MI')
				ELSE TO_CHAR(NOTIFICATION_DATE, 'YYYY-MM-DD')
			END AS NOTIFICATION_DATE
		FROM "NOTIFICATION"
		JOIN "MEMBER" ON (SEND_MEMBER_NO = MEMBER_NO)
		WHERE RECEIVE_MEMBER_NO = 2
		ORDER BY NOTIFICATION_NO DESC




SELECT *
FROM "NOTIFICATION"
WHERE READ;

-- 회원 프로필 이미지 + 게시글 이미지 파일명만 모두 조회하기
-- SUBSTR(컬럼명, 시작 인덱스) : 인덱스 부터 끝까지 잘라서 반환

-- INSTR(컬럼명, '찾을문자열', 검색순서) : 일치하는 문자열 인덱스 반환

-- 검색 순서 -1 == 뒤에서부터 검색
SELECT 
	SUBSTR(PROFILE_IMG, 
	INSTR(PROFILE_IMG,'/',-1)
	+1) AS "FILE_NAME"
	
FROM "MEMBER"
WHERE PROFILE_IMG IS NOT NULL

UNION

SELECT TO_CHAR(IMG_RENAME) "FILE_NAME"
FROM "BOARD_IMG";


/*채팅 관련*/


CREATE TABLE "CHATING_ROOM" (
	"CHATING_ROOM_NO"	NUMBER		NOT NULL,
	"CREATE_DATE"	DATE		NOT NULL,
	"OPEN_MEMBER"	NUMBER		NOT NULL,
	"PARTICIPANT"	NUMBER		NOT NULL
);

COMMENT ON COLUMN "CHATING_ROOM"."CHATING_ROOM_NO" IS '채팅방 번호';

COMMENT ON COLUMN "CHATING_ROOM"."CREATE_DATE" IS '채팅방 생성일';

COMMENT ON COLUMN "CHATING_ROOM"."OPEN_MEMBER" IS '개설자 회원번호';

COMMENT ON COLUMN "CHATING_ROOM"."PARTICIPANT" IS '참여자 회원 번호';

CREATE TABLE "MESSAGE" (
	"MESSAGE_NO"	NUMBER		NOT NULL,
	"MESSAGE_CONTENT"	VARCHAR2(4000)		NOT NULL,
	"READ_FL"	CHAR(1)	DEFAULT 'N'	NOT NULL,
	"SEND_TIME"	DATE	DEFAULT CURRENT_DATE	NOT NULL,
	"SENDER_NUMBER"	NUMBER		NOT NULL,
	"Field"	VARCHAR(255)		NULL,
	"CHATING_ROOM_NO"	NUMBER		NOT NULL
);

COMMENT ON COLUMN "MESSAGE"."MESSAGE_NO" IS '메시지 번호';

COMMENT ON COLUMN "MESSAGE"."MESSAGE_CONTENT" IS '메시지 내용';

COMMENT ON COLUMN "MESSAGE"."READ_FL" IS '읽음여부 Y,N';

COMMENT ON COLUMN "MESSAGE"."SEND_TIME" IS '메세지 보낸시간';

COMMENT ON COLUMN "MESSAGE"."SENDER_NUMBER" IS '메세지 보낸회원 번호';

COMMENT ON COLUMN "MESSAGE"."CHATING_ROOM_NO" IS '채팅방 번호';

ALTER TABLE "CHATING_ROOM" ADD CONSTRAINT "PK_CHATING_ROOM" PRIMARY KEY (
	"CHATING_ROOM_NO"
);

ALTER TABLE "MESSAGE" ADD CONSTRAINT "PK_MESSAGE" PRIMARY KEY (
	"MESSAGE_no"
);

ALTER TABLE "CHATING_ROOM" ADD CONSTRAINT "FK_MEMBER_TO_CHATING_ROOM_1" FOREIGN KEY (
	"OPEN_MEMBER"
)
REFERENCES "MEMBER" (
	"MEMBER_NO"
);

ALTER TABLE "CHATING_ROOM" ADD CONSTRAINT "FK_MEMBER_TO_CHATING_ROOM_2" FOREIGN KEY (
	"PARTICIPANT"
)
REFERENCES "MEMBER" (
	"MEMBER_NO"
);

ALTER TABLE "MESSAGE" ADD CONSTRAINT "FK_MEMBER_TO_MESSAGE_1" FOREIGN KEY (
	"SENDER_NUMBER"
)
REFERENCES "MEMBER" (
	"MEMBER_NO"
);

ALTER TABLE "MESSAGE" ADD CONSTRAINT "FK_CHATING_ROOM_TO_MESSAGE_1" FOREIGN KEY (
	"CHATING_ROOM_NO"
)
REFERENCES "CHATING_ROOM" (
	"CHATING_ROOM_NO"
);

-- 채팅방 번호 생서 시퀀스

CREATE SEQUENCE SEQ_ROOM_NO NOCACHE;

-- 메시지 번호 생성 시퀀스

CREATE SEQUENCE SEQ_MESSAGE_NO NOCACHE;

-- 로그인한 회원이 참여한 채팅방 목록 조회
 SELECT CHATTING_ROOM_NO
			,(SELECT MESSAGE_CONTENT FROM (
				SELECT * FROM MESSAGE M2
				WHERE M2.CHATTING_ROOM_NO = R.CHATTING_ROOM_NO
				ORDER BY MESSAGE_NO DESC) 
				WHERE ROWNUM = 1) LAST_MESSAGE
			,TO_CHAR(NVL((SELECT MAX(SEND_TIME) SEND_TIME 
					FROM MESSAGE M
					WHERE R.CHATTING_ROOM_NO  = M.CHATTING_ROOM_NO), CREATE_DATE), 
					'YYYY.MM.DD') SEND_TIME
			,NVL2((SELECT OPEN_MEMBER FROM CHATTING_ROOM R2
				WHERE R2.CHATTING_ROOM_NO = R.CHATTING_ROOM_NO
				AND R2.OPEN_MEMBER = 2),
				R.PARTICIPANT,
				R.OPEN_MEMBER
				) TARGET_NO	
			,NVL2((SELECT OPEN_MEMBER FROM CHATTING_ROOM R2
				WHERE R2.CHATTING_ROOM_NO = R.CHATTING_ROOM_NO
				AND R2.OPEN_MEMBER = 2),
				(SELECT MEMBER_NICKNAME FROM MEMBER WHERE MEMBER_NO = R.PARTICIPANT),
				(SELECT MEMBER_NICKNAME FROM MEMBER WHERE MEMBER_NO = R.OPEN_MEMBER)
				) TARGET_NICKNAME	
			,NVL2((SELECT OPEN_MEMBER FROM CHATTING_ROOM R2
				WHERE R2.CHATTING_ROOM_NO = R.CHATTING_ROOM_NO
				AND R2.OPEN_MEMBER = 2),
				(SELECT PROFILE_IMG FROM MEMBER WHERE MEMBER_NO = R.PARTICIPANT),
				(SELECT PROFILE_IMG FROM MEMBER WHERE MEMBER_NO = R.OPEN_MEMBER)
				) TARGET_PROFILE
			,(SELECT COUNT(*) FROM MESSAGE M WHERE M.CHATTING_ROOM_NO = R.CHATTING_ROOM_NO AND READ_FL = 'N' AND SENDER_NO != 2) NOT_READ_COUNT
			,(SELECT MAX(MESSAGE_NO) SEND_TIME FROM MESSAGE M WHERE R.CHATTING_ROOM_NO  = M.CHATTING_ROOM_NO) MAX_MESSAGE_NO
		FROM CHATTING_ROOM R
		WHERE OPEN_MEMBER = 2
		OR PARTICIPANT = 2
		ORDER BY MAX_MESSAGE_NO DESC NULLS LAST;




 
 