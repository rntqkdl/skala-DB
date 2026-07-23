-- ==========================================
-- 파트 2: 서브쿼리(Subquery) 및 집합 연산자 실습
-- ==========================================

-- 14. 소속 학과명 붙이기 (스칼라 서브쿼리)
SELECT
    s.student_id,
    s.name,
    s.major AS "학과_코드",
    (
        SELECT m.major_name
        FROM lab.major_info m
        WHERE m.major_code = s.major
    ) AS "전체_학과명"
FROM lab.student s
ORDER BY s.student_id
LIMIT 5;

-- 15. 전체 평균 GPA보다 높은 학생 조회 (일반 서브쿼리)
SELECT
    student_id,
    name,
    major,
    gpa
FROM lab.student
WHERE gpa > (
    SELECT AVG(gpa)
    FROM lab.student
)
ORDER BY gpa DESC
LIMIT 5;

-- 16. 자신의 학과 평균 GPA보다 높은 학생 조회 (상관 서브쿼리)
SELECT
    s.student_id,
    s.name,
    s.major,
    s.gpa,
    ROUND((
        SELECT AVG(s2.gpa)
        FROM lab.student s2
        WHERE s2.major = s.major
    ), 2) AS major_avg_gpa
FROM lab.student s
WHERE s.gpa > (
    SELECT AVG(s2.gpa)
    FROM lab.student s2
    WHERE s2.major = s.major
)
ORDER BY s.student_id
LIMIT 5;

-- 17. 수강 기록이 있는 학생 (IN 서브쿼리)
SELECT
    s.student_id,
    s.name,
    s.major
FROM lab.student s
WHERE s.student_id IN (
    SELECT e.student_id
    FROM lab.enroll e
)
ORDER BY s.student_id
LIMIT 5;

-- 18. 수강 기록이 없는 학생 (NOT EXISTS 서브쿼리)
SELECT
    s.student_id,
    s.name,
    s.major
FROM lab.student s
WHERE NOT EXISTS (
    SELECT 1
    FROM lab.enroll e
    WHERE e.student_id = s.student_id
)
ORDER BY s.student_id
LIMIT 5;

-- 19. 특정 집단과의 비교 (> ANY 다중행 서브쿼리)
SELECT
    s.student_id,
    s.name,
    s.major,
    s.gpa
FROM lab.student s
WHERE s.gpa > ANY (
    SELECT s2.gpa
    FROM lab.student s2
    WHERE s2.major = 'HR'
)
ORDER BY s.student_id
LIMIT 5;

-- 20. 조건에 따른 두 집합 결합 (UNION)
SELECT
    s.student_id,
    s.name,
    s.major
FROM lab.student s
WHERE s.major = 'CS'

UNION

SELECT
    s.student_id,
    s.name,
    s.major
FROM lab.student s
INNER JOIN lab.enroll e
    ON s.student_id = e.student_id
WHERE e.course = 'DB'
ORDER BY student_id
LIMIT 5;