conn &1 
@login
@curpid

set termout off
alter session set NLS_DATE_FORMAT='YYYY.MM.DD HH24:MI:SS';

COLUMN spool_file NEW_VALUE spool_file NOPRINT
-- SELECT 'spooling_' || name || SYS_CONTEXT ('USERENV', 'INSTANCE') ||'_' || TO_CHAR(SYSDATE, 'YYYYMMDD_HH24MISS', 'NLS_DATE_LANGUAGE=''AMERICAN''') || '.log' AS spool_file FROM v$database;
SELECT 'spooling_' || name || SYS_CONTEXT ('USERENV', 'INSTANCE') ||'_' || TO_CHAR(SYSDATE, 'YYYYMMDD', 'NLS_DATE_LANGUAGE=''AMERICAN''') || '.log' AS spool_file FROM v$database;
SPOOL ./spool/&spool_file append 


set numwidth 15
set pages 10000
set termout on
-- SET TAB OFF