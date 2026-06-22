-- Platform: StrataScratch
-- Problem: Ranking Active Guests
-- Summary: Rank guests based on the total number of messages they have sent, and output the guest identifier, total messages, and their rank ordered from most to least messages sent.

-- Output : one row per guest showing the rank, guest identifier, and total_messages ordered from most to least
-- Entity/Who: guest
-- Metric: DENSE_RANK() guests per their total_messages
-- Hidden : explicit dense_rank
-- filters : None

-- Level 0:Output(rnk, guest_id, total_messages)
-- grain : one row per guest
-- columns : guest_id, total_messages, rnk
-- Operation : DENSE_RANK() ORDER BY total_messages DESC

-- Level 1: Enrich guest per their total_messages
-- grain : one row per guest_id
-- columns : id_guest, n_messages
-- Operation : COLLAPSE ROWS by GROUP BY guest_id; SUM(n_messages)

-- Raw table
-- contacts : multiple row per guest_id

WITH guest_messages AS (SELECT 
    id_guest,
    SUM(n_messages) AS total_messages
FROM airbnb_contacts
GROUP BY 1)

-- Level 0: Label rank users per total_messages 
SELECT 
    id_guest, total_messages,
    DENSE_RANK() OVER(ORDER BY total_messages DESC ) AS rnk
FROM guest_messages
ORDER BY total_messages DESC