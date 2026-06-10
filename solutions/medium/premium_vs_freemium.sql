-- Platform : StrataScratch
-- Problem : Premium vs Freemium (Microsoft)

-- Summary : Compare the number of downloads for paying and non-paying customers by date, and filter for dates where non-paying downloads exceed paying downloads.

-- Output : one row per date, non_paying_downloads, paying_downloads soretd by earliest date
-- Entity/Who ?: users
-- Metric : Find the total number of downloads for paying and non-paying users by date
-- Filter : valid records = non-paying customers downloads > paying customers

-- Level 0: Output(date, non_paying_downloads, paying_downloads)
-- grain : one row per date
-- columns : date, non_paying_downloads, paying_downloads
-- operation : Group by date, non_paying_downloads, paying_downloads 
--  And compute SUM(non_paying) and SUM(paying)
-- Sort by date ASC

-- Level 1: Need to compute non_paying and paying customers downloads
-- grain : one row per user_id, date
-- columns : date, user_id, downloads, acc_id, paying_customer
-- Operation : Join tables users and accounts to fact_dwonloads to match the users with their records
-- filter : non-paying-downloads > paying-downloads

-- Raw tables
-- user_dimension : one row per user
-- acc_dimension : one row per user, account
-- download_facts : one row per date, user_id

WITH records AS (SELECT 
    d.date, d.user_id, d.downloads, u.acc_id, a.paying_customer

FROM ms_download_facts d
INNER JOIN ms_user_dimension u
ON d.user_id = u.user_id
INNER JOIN ms_acc_dimension a
ON u.acc_id = a.acc_id),
downloads AS (
SELECT 
    date,
    SUM(CASE WHEN paying_customer = 'no' THEN downloads END) AS non_paying_downloads,
    SUM(CASE WHEN paying_customer = 'yes' THEN downloads END) AS paying_customer_downloads

FROM records
GROUP BY 1)
SELECT 
    date,
    non_paying_downloads,
    paying_customer_downloads
FROM downloads
WHERE non_paying_downloads > paying_customer_downloads
ORDER BY 1