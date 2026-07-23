-- ==========================================
-- 파트 1: 기본 JOIN 및 GROUP BY 집계 실습
-- ==========================================

-- 1. 학생과 수강 INNER JOIN
SELECT
    s.student_id,
    s.name,
    s.major,
    e.course,
    e.grade
FROM lab.student s
INNER JOIN lab.enroll e
    ON s.student_id = e.student_id
LIMIT 5;

-- 2. 모든 학생 기준 수강 데이터 (LEFT JOIN)
SELECT
    s.student_id,
    s.name,
    s.major,
    e.course,
    e.grade
FROM lab.student s
LEFT JOIN lab.enroll e
    ON s.student_id = e.student_id
LIMIT 5;

-- 3. 수강 데이터 기준 학생 매핑 (RIGHT JOIN)
SELECT
    e.student_id AS enroll_stu_id,
    s.name,
    e.course,
    e.grade
FROM lab.student s
RIGHT JOIN lab.enroll e
    ON s.student_id = e.student_id
ORDER BY e.student_id DESC
LIMIT 5;

-- 4. 학생/수강 모두 포함 (FULL OUTER JOIN)
SELECT
    s.student_id AS student_tbl_id,
    e.student_id AS enroll_tbl_id,
    s.name,
    e.course,
    e.grade
FROM lab.student s
FULL OUTER JOIN lab.enroll e
    ON s.student_id = e.student_id
ORDER BY s.student_id DESC
LIMIT 5;

-- 5. 한 번도 수강하지 않은 학생 목록 (ANTI JOIN)
SELECT
    s.student_id,
    s.name,
    s.major
FROM lab.student s
LEFT JOIN lab.enroll e
    ON s.student_id = e.student_id
WHERE e.course IS NULL
ORDER BY s.student_id
LIMIT 5;

-- 6. 한 과목 이상 수강한 학생 목록 (EXISTS 활용)
SELECT
    s.student_id,
    s.name,
    s.major
FROM lab.student s
WHERE EXISTS (
    SELECT 1
    FROM lab.enroll e
    WHERE s.student_id = e.student_id
)
ORDER BY s.student_id
LIMIT 5;

-- 7. 고객별 주문 건수 및 총액 집계
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS order_count,
    SUM(o.amount) AS total_amount
FROM lab.customers c
INNER JOIN lab.orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY c.customer_id
LIMIT 5;

-- 8. 구매 총액 상위 10명 리포트
SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.amount) AS total_amount
FROM lab.customers c
INNER JOIN lab.orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_amount DESC
LIMIT 10;

-- 9. 모든 직원과 담당 매니저 이름 (SELF JOIN)
SELECT
    e.emp_id AS employee_id,
    e.name AS employee_name,
    m.name AS manager_name
FROM lab.emp e
LEFT JOIN lab.emp m
    ON e.manager_id = m.emp_id
ORDER BY e.emp_id
LIMIT 5;

-- 10. 모든 학생 기준 과목 수강 건수 분포
SELECT
    s.student_id,
    s.name,
    COUNT(e.course) AS enrolled_course_count
FROM lab.student s
LEFT JOIN lab.enroll e
    ON s.student_id = e.student_id
GROUP BY
    s.student_id,
    s.name
ORDER BY s.student_id
LIMIT 10;

-- 11. DB 과목을 듣지 않은 학생 나열 (Anti-Join 응용)
SELECT
    s.student_id,
    s.name,
    s.major
FROM lab.student s
LEFT JOIN lab.enroll e
    ON s.student_id = e.student_id
    AND e.course = 'DB'
WHERE e.course IS NULL
ORDER BY s.student_id
LIMIT 5;

-- 12. 과목별 책임 매니저 및 수강 인원 리포트
SELECT
    c.course AS "과목명",
    COUNT(e.student_id) AS "수강인원",
    m.name AS "책임_매니저"
FROM lab.course_owner c
LEFT JOIN lab.enroll e
    ON c.course = e.course
LEFT JOIN lab.emp m
    ON c.manager_id = m.emp_id
GROUP BY
    c.course,
    m.name
ORDER BY "수강인원" DESC;

-- 13. 학생별 과목 추천 후보 생성 (CROSS JOIN)
SELECT
    s.student_id,
    s.name,
    c.course AS "추천_후보_과목"
FROM lab.student s
CROSS JOIN lab.course_owner c
ORDER BY
    s.student_id,
    c.course
LIMIT 100;