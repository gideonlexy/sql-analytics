-- -- SELECT * FROM playbook_events
SELECT 
    u.company_id,u.language,
    COUNT(e.event_name) AS event_count

FROM playbook_events e
INNER JOIN playbook_users u ON e.user_id = u.user_id
    
WHERE e.device = 'macbook pro' AND e.location = 'Argentina'
AND u.user_id NOT IN(
    SELECT user_id 
    FROM playbook_users
    WHERE language = 'spanish'
    )
    
GROUP BY 1, 2
