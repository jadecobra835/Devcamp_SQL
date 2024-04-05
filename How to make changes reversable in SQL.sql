USE devcamp_sql_course_schema;
 
BEGIN;
UPDATE guides
SET guides_title = 'Oops'
WHERE guides_users_id = 1;

SELECT * 
FROM guides;

ROLLBACK;