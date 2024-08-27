DELETE : 테이블 행 삭제
DELETE *
FROM EMPLOYEE
WHERE EMP_ID = 1; 와 같이 사용함
EMPLOYEE 테이블에서 EMP_ID가 1인 사람의 모든 내용삭제

TRUNCATE : 테이블 행 삭제 (DDL)
TRUNCATE *
FROM EMPLOYEE
WHERE EMP_ID = 1; 와 같이 사용
DELETE와 사용형태와 의미는 같으나, ROLLBACK으로 복구 불가

DROP : 테이블의 열(컬럼) 삭제
DROP EMP_ID
FROM EMPLOYEE; 와 같이 사용
DELETE / TRUNCATE와 달리 테이블의 열을 삭제함
* 제약 조건 ***

- 조건의 데이터만 유지하기 위해서 특정 컬럼에 설정하는 제약
   -> 데이터 무결성(신뢰도) 보장을 목적으로 함

1. NOT NULL : 지정된 컬럼에 무조건 값이 존재해야함

2. UNIQUE : 지정된 컬럼에 중복된 값이 존재할 수 없다
      -> 단, NULL은 가능
      왜? 값이 없어서 비교가 안됨

3. PRIMARY KEY : 각 행을 구분하기 위한 식별 역할의 컬럼을 지정
   -> 컬럼에 저장된 값만 알면 모든 행을 구별할 수 있음
   -> 중복 X(UNIQUE) + 무조건 값이 존재(NOT NULL)
   -> PK는 테이블에 1개만 존재 가능
     (한 컬럼 X, PK 제약조건이 1개)

4. FOREIGN KEY : 
   자식 테이블의 한 컬럼에 작성될 수 있는 값은
   부모 테이블의 한 컬럼(PK, UNIQUE)에 작성된 값만 쓸 수 있다.
   -> 자식 테이블이 부모 테이블을 참조 
   
   - 부모 - 자식 관계 형성
     -> 두 테이블에 같은 종류의 데이터를 지닌 컬럼이 있다!
       -> JOIN의 연결 기준이 될 수 있다!
5. CHECK : 컬럼에 지정된 값만 저장할 수 있게 하는 제약조건
   - FK 제약 조건의 하위 호환 까지