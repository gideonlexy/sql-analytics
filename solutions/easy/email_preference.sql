-- Platform : StataScratch
-- Problem : Email Preference(City Of Francisco)

-- Output : home_library_code
-- Entity/Who? : libraries
-- Metric : Libraries from 2016 that have no email but have preferences set to email
-- Operation : Isolate the libraries with the given filters
-- filter : circulation_active_year = 2016 a
--          : provided_email_address = False
--          : notice_preference_definition = 'email'

SELECT DISTINCT
    home_library_code

FROM library_usage
WHERE circulation_active_year = 2016
AND provided_email_address = False
AND notice_preference_definition = 'email'