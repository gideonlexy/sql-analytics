-- Platform : ScrtaScratch
-- Problem : Number of Conversations
-- summary : Find the total number of conversations between users. 

WITH messages AS (SELECT DISTINCT
    LEAST(message_sender_id, message_receiver_id),
    GREATEST(message_sender_id, message_receiver_id)

FROM whatsapp_messages)
SELECT
    COUNT(*) AS messages
FROM messages