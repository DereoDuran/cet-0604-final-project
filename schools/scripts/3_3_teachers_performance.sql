WITH attendances AS (
    SELECT teacher_id, year, AVG(attendance) AS avg_attendance
    FROM lessons
    JOIN dates ON dates.date_id = lessons.date_id
    GROUP BY teacher_id, year
    ORDER BY avg_attendance DESC
)
SELECT attendances.teacher_id, teacher_name, attendances.year, attendances.avg_attendance FROM attendances
join teachers on attendances.teacher_id = teachers.teacher_id;
