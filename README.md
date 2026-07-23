# SKALA 4기 SQL 종합 실습

이 저장소는 SKALA 4기 수강생을 위한 PostgreSQL 기반 SQL 종합 실습 자료입니다. 데이터베이스 설정부터 기본 JOIN, 서브쿼리, 윈도우 함수, 계층형 쿼리까지 다양한 SQL 구문을 실습할 수 있도록 구성되어 있습니다.

## 🎯 학습 목표

- 실무와 유사한 구조의 샘플 데이터를 통해 SQL 쿼리 작성 능력 향상
- `JOIN`, `GROUP BY` 등 기본 구문부터 `서브쿼리`, `윈도우 함수` 등 고급 기법까지 마스터
- `psql` 또는 `DBeaver`와 같은 DB 클라이언트 도구 사용법 숙달

## 🙋‍♂️ 대상

- SKALA 4기 수강생
- SQL 기초를 익히고 실전적인 쿼리 연습이 필요한 분

## ⚠️ 사전 준비

### 소프트웨어

- **데이터베이스**: **PostgreSQL 17** 버전 설치
- **SQL 클라이언트**:
  - `psql` (PostgreSQL 설치 시 기본 포함)
  - 또는 DBeaver, DataGrip 등 선호하는 GUI 클라이언트

### 권장 학습

본격적인 실습에 앞서, SQL의 기본 `SELECT`, `FROM`, `WHERE` 문법과 `PRIMARY KEY`, `FOREIGN KEY` 등 데이터베이스 기본 개념에 대한 사전 학습을 권장합니다.

---

## 🚀 설치 및 데이터베이스 설정

실습 환경은 크게 두 가지 방법(CLI 또는 GUI)으로 설정할 수 있습니다. 본인에게 편한 방법을 선택하세요.

### 방법 1: `psql` (명령줄 인터페이스) 사용 (권장)

터미널 또는 명령 프롬프트에서 아래 명령어를 한 줄로 실행하면, 사용자 생성부터 데이터 적재까지 모든 과정이 자동으로 진행됩니다.

1.  프로젝트의 SQL 파일들이 있는 디렉토리로 이동합니다.
2.  아래 명령어를 실행합니다.

    ```bash
    psql -U postgres -f "(psql) 종합실습2_postgres_join_lab_large.sql"
    ```

3.  실행 중 `skala_user 비밀번호를 입력하세요:` 라는 메시지가 나타나면 실습에 사용할 비밀번호를 입력하고 Enter를 누릅니다.

4.  모든 설정이 완료되면 접속 정보가 출력됩니다. 해당 정보로 DB에 접속하여 실습을 시작할 수 있습니다.

### 방법 2: DBeaver 등 GUI 도구 사용

GUI 도구에서는 트랜잭션 처리 방식의 차이로 인해 스크립트를 두 단계로 나누어 실행해야 합니다.

**1단계: 사용자 및 데이터베이스 생성**

1.  `postgres` 데이터베이스에 슈퍼유저(예: `postgres`)로 접속합니다.
2.  `종합실습2_postgres_join_lab_large_1.sql` 파일을 엽니다.
3.  파일 내의 안내에 따라 `ALTER ROLE ... PASSWORD ...` 부분의 비밀번호를 원하는 값으로 수정한 후, 각 `STEP`을 순서대로 실행하여 `skala_user` 롤과 `skala_db` 데이터베이스를 생성합니다.

**2단계: 스키마 및 데이터 적재**

1.  DBeaver에서 `skala_db` 데이터베이스로 접속하는 새 연결을 만들거나, 기존 연결 정보를 수정하여 접속합니다.
2.  `종합실습2_postgres_join_lab_large_2.sql` 파일을 엽니다.
3.  해당 스크립트 전체를 실행하여 `lab` 스키마, 테이블, 인덱스 생성 및 데이터 적재를 완료합니다.

---

## 📂 파일 구성

```
├── (psql) 종합실습2_postgres_join_lab_large.sql  # [방법 1] psql용 통합 설치 스크립트
├── 종합실습2_postgres_join_lab_large_1.sql      # [방법 2] GUI용 설치 스크립트 (1/2)
├── 종합실습2_postgres_join_lab_large_2.sql      # [방법 2] GUI용 설치 스크립트 (2/2)
│
├── 01_join_and_group.sql                     # 실습 1: JOIN 및 GROUP BY
├── 02_subquery_and_union.sql                 # 실습 2: 서브쿼리 및 집합 연산자
├── 03_window_function_and_hierarchy.sql      # 실습 3: 윈도우 함수 및 계층형 쿼리
│
└── README.md                                 # 프로젝트 안내 문서 (현재 파일)
```

## 💻 실습 방법

1.  위 설치 및 데이터베이스 설정을 완료하여 `skala_db`에 접속합니다.
2.  `01_join_and_group.sql` 부터 순서대로 파일을 열어 쿼리를 실행합니다.
3.  각 쿼리의 실행 결과를 확인하고, 주석에 담긴 문제 의도와 SQL 구문을 분석하며 학습합니다.
4.  단순히 실행만 하지 말고, `LIMIT`를 풀어보거나 `WHERE` 조건을 바꾸는 등 자유롭게 쿼리를 수정하며 실험해보는 것을 적극 권장합니다.

## 🗂️ 데이터베이스 스키마

실습에 사용되는 `lab` 스키마의 테이블 구조는 다음과 같습니다.

| 테이블명 | 설명 | 주요 컬럼 |
| :--- | :--- | :--- |
| `student` | 학생 정보 | `student_id`, `name`, `major`, `gpa` |
| `enroll` | 수강 신청 정보 | `student_id`, `course`, `grade` |
| `customers` | 고객 정보 | `customer_id`, `customer_name` |
| `orders` | 주문 정보 | `order_id`, `customer_id`, `amount` |
| `emp` | 직원 정보 (조직도) | `emp_id`, `name`, `manager_id` |