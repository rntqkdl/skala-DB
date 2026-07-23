-- ==========================================
-- 파트 3: 윈도우 함수(Window Function) 및 계층형 쿼리 실습
-- ==========================================

-- 21. 학과별·GPA 구간별 소계 및 총계 (GROUP BY ROLLUP)
WITH student_tier AS (
    SELECT
        student_id,
        major,
        CASE
            WHEN gpa < 3.0 THEN '3.0 미만'
            WHEN gpa <= 3.5 THEN '3.0~3.5'
            ELSE '3.5 초과'
        END AS gpa_tier
    FROM lab.student
)
SELECT
    CASE WHEN GROUPING(major) = 1 THEN '▶ 전체 총계' ELSE major END AS "학과",
    CASE WHEN GROUPING(gpa_tier) = 1 THEN '▷ 소계' ELSE gpa_tier END AS "GPA구간",
    COUNT(student_id) AS "학생_수"
FROM student_tier
GROUP BY ROLLUP(major, gpa_tier)
ORDER BY
    GROUPING(major),
    major,
    GROUPING(gpa_tier),
    gpa_tier;

-- 22-1. 조직도 계층 트리 탐색 (WITH RECURSIVE)
WITH RECURSIVE emp_tree AS (
    SELECT
        e.emp_id,
        e.name,
        e.manager_id,
        0 AS depth,
        CAST(e.name AS TEXT) AS path
    FROM lab.emp e
    WHERE e.manager_id IS NULL
    
    UNION ALL
    
    SELECT
        e.emp_id,
        e.name,
        e.manager_id,
        t.depth + 1 AS depth,
        t.path || ' > ' || e.name AS path
    FROM lab.emp e
    INNER JOIN emp_tree t
        ON e.manager_id = t.emp_id
)
SELECT emp_id, name, depth, path
FROM emp_tree
ORDER BY path
LIMIT 5;

-- 22-2. 매니저별 직속 부하 직원 수 집계
SELECT
    m.emp_id AS manager_id,
    m.name AS manager_name,
    COUNT(e.emp_id) AS direct_reports
FROM lab.emp m
INNER JOIN lab.emp e
    ON m.emp_id = e.manager_id
GROUP BY
    m.emp_id,
    m.name
ORDER BY m.emp_id
LIMIT 5;

-- 23. 학과별 순위 추출 및 윈도우 함수 비교 (CTE 방식)
WITH RankedStudents AS (
    SELECT
        student_id,
        name,
        major,
        gpa,
        ROW_NUMBER() OVER (PARTITION BY major ORDER BY gpa DESC, student_id ASC) AS row_num,
        RANK() OVER (PARTITION BY major ORDER BY gpa DESC, student_id ASC) AS rank_val,
        DENSE_RANK() OVER (PARTITION BY major ORDER BY gpa DESC, student_id ASC) AS dense_rank_val,
        COUNT(student_id) OVER (PARTITION BY major) AS total_in_major
    FROM lab.student
)
SELECT
    student_id,
    name,
    major,
    gpa,
    row_num,
    rank_val,
    dense_rank_val,
    total_in_major
FROM RankedStudents
WHERE row_num <= 3
ORDER BY major, row_num
LIMIT 5;

-- 24. 이전 수강 과목 대비 성적 변화 분석 (LAG)
WITH ScoreConverted AS (
    SELECT
        student_id,
        course,
        grade,
        CASE grade
            WHEN 'A' THEN 4
            WHEN 'B' THEN 3
            WHEN 'C' THEN 2
            WHEN 'D' THEN 1
            ELSE 0
        END AS score
    FROM lab.enroll
),
LaggedData AS (
    SELECT
        student_id,
        course,
        grade,
        score,
        LAG(score) OVER (PARTITION BY student_id ORDER BY course) AS prev_score,
        MAX(score) OVER (PARTITION BY student_id) - MIN(score) OVER (PARTITION BY student_id) AS score_range
    FROM ScoreConverted
)
SELECT
    student_id,
    course,
    grade,
    score,
    prev_score,
    (score - prev_score) AS diff,
    CASE
        WHEN (score - prev_score) > 0 THEN '상승'
        WHEN (score - prev_score) = 0 THEN '유지'
        WHEN (score - prev_score) < 0 THEN '하락'
        ELSE '비교 불가 (첫 과목)'
    END AS "성적_추이",
    score_range
FROM LaggedData
ORDER BY student_id, course
LIMIT 5;

-- 25. 누적 주문금액 및 특정 시점 추출 (ROWS BETWEEN)
WITH OrderCalculations AS (
    SELECT
        customer_id,
        order_id,
        amount,
        SUM(amount) OVER (PARTITION BY customer_id ORDER BY order_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_sum,
        AVG(amount) OVER (PARTITION BY customer_id ORDER BY order_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg,
        SUM(amount) OVER (PARTITION BY customer_id) AS total_sum
    FROM lab.orders
),
FilteredOrders AS (
    SELECT
        customer_id,
        order_id,
        amount,
        cum_sum,
        total_sum,
        moving_avg,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_id) AS rn
    FROM OrderCalculations
    WHERE cum_sum > (total_sum * 0.5)
)
SELECT
    customer_id,
    order_id AS "50%돌파_주문ID",
    amount AS "해당주문_금액",
    cum_sum AS "누적합",
    total_sum AS "전체합",
    ROUND(moving_avg, 2) AS "3건_이동평균"
FROM FilteredOrders
WHERE rn = 1
ORDER BY customer_id
LIMIT 5;