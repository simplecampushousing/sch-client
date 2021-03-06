SELECT  PEOPLE.PEOPLE_ID,
        PEOPLE.FIRST_NAME,
        PEOPLE.LAST_NAME,
        PEOPLE.MIDDLE_NAME,
        DEMOGRAPHICS.GENDER,
        PEOPLE.BIRTH_DATE,
        ADDRESS.EMAIL_ADDRESS,
        ACADEMIC.CLASS_LEVEL,
        ACADEMIC.CURRICULUM,
        ACADEMIC.CREDITS AS current_Credits,
        ADDRESS.ADDRESS_LINE_1 as Address1,
        ADDRESS.ADDRESS_LINE_2 as Address2,
        ADDRESS.CITY as City,
        ADDRESS.STATE,
        ADDRESS.ZIP_CODE,
        phone.PhoneNumber,
        ACADEMIC.COLLEGE_ATTEND,
        StopLIstHolds.STOP_REASON,
        StopLIstHolds.STOP_DATE,
        StopLIstHolds.CLEARED_DATE,
        StopLIstHolds.CLEARED
        -- COALESCE(gpa.total_credits, 0) as total_credits,
        -- gpa.gpa
FROM PEOPLE AS PEOPLE
LEFT JOIN ADDRESS AS ADDRESS
  ON PEOPLE.PEOPLE_CODE_ID = ADDRESS.PEOPLE_ORG_CODE_ID
INNER JOIN ACADEMIC AS ACADEMIC
  ON PEOPLE.PEOPLE_CODE_ID = ACADEMIC.PEOPLE_CODE_ID
INNER JOIN RESIDENCY AS RESIDENCY
  ON ACADEMIC.PEOPLE_CODE_ID = RESIDENCY.PEOPLE_CODE_ID
  AND ACADEMIC.ACADEMIC_YEAR = RESIDENCY.ACADEMIC_YEAR
  AND ACADEMIC.ACADEMIC_TERM = RESIDENCY.ACADEMIC_TERM
  AND ACADEMIC.ACADEMIC_SESSION = RESIDENCY.ACADEMIC_SESSION
INNER JOIN DEMOGRAPHICS
  ON ACADEMIC.PEOPLE_CODE_ID = DEMOGRAPHICS.PEOPLE_CODE_ID
  AND ACADEMIC.ACADEMIC_YEAR = DEMOGRAPHICS.ACADEMIC_YEAR
  AND ACADEMIC.ACADEMIC_TERM = DEMOGRAPHICS.ACADEMIC_TERM
  AND ACADEMIC.ACADEMIC_SESSION = DEMOGRAPHICS.ACADEMIC_SESSION
LEFT OUTER JOIN
  (SELECT PEOPLE_CODE,
          PEOPLE_ID,
          PEOPLE_CODE_ID,
          STOP_REASON,
          STOP_DATE,
          CLEARED,
          CLEARED_DATE,
          COMMENTS,
          CREATE_DATE,
          CREATE_TIME,
          CREATE_OPID,
          CREATE_TERMINAL,
          REVISION_DATE,
          REVISION_TIME,
          REVISION_OPID,
          REVISION_TERMINAL,
          ABT_JOIN
  FROM    STOPLIST
  WHERE   (CLEARED = 'N')
  ) AS StopLIstHolds ON PEOPLE.PEOPLE_CODE_ID = StopLIstHolds.PEOPLE_CODE_ID
LEFT JOIN PersonPhone phone
  ON phone.PersonPhoneId = PEOPLE.PrimaryPhoneId
-- LEFT JOIN vwuArgosStudentGPAOverall gpa
--   ON gpa.people_code_id = p.people_code_id
WHERE (ACADEMIC.PRIMARY_FLAG = 'Y')
AND (ACADEMIC.ACADEMIC_SESSION = '')
AND (ADDRESS.ADDRESS_TYPE = 'PERM')
AND (ACADEMIC.ACADEMIC_YEAR = $%$ACADEMIC_YEAR$%$)
AND (ACADEMIC.ACADEMIC_TERM = $%$ACADEMIC_TERM$%$)
AND (ACADEMIC.ENROLL_SEPARATION = 'ENRL')
