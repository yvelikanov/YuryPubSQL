set termout off

-- Used for the SHOW ERRORS command
column LINE/COL format A8
column ERROR    format A65  WORD_WRAPPED

-- Used for the SHOW SGA command
column name_col_plus_show_sga format a24

-- Defaults for SHOW PARAMETERS
column name_col_plus_show_param format a36 heading NAME
column value_col_plus_show_param format a30 heading VALUE

-- Defaults for SET AUTOTRACE EXPLAIN report
column id_plus_exp format 990 heading i
column parent_id_plus_exp format 990 heading p
column plan_plus_exp format a100
column object_node_plus_exp format a8
column other_tag_plus_exp format a29
column other_plus_exp format a44

set pagesize 9999 lines 180
SET APPINFO OFF


prompt W:\ORATEH\SQL

define gname=idle
column global_name new_value gname
SELECT SYS_CONTEXT ('USERENV', 'CURRENT_USER') global_name from dual;
SELECT SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')||'@'||SYS_CONTEXT ('USERENV', 'DB_NAME')||':'||SYS_CONTEXT ('USERENV', 'INSTANCE') global_name FROM dual;
set sqlprompt '&gname> '
alter session set nls_date_format='YYYY.MM.DD HH24:MI:SS';

set termout on


define _editor=notepad
SET SERVEROUTPUT ON SIZE 1000000 format wrapped
set trimspool on
set long 5000
SET SQLN OFF
set time on
set trimspool on 
column machine for a35
column osuser for a35
column program for a55
column event for a50

-- set editfile "U:\temp\buffer.sql"


-- Defaults for SHOW PARAMETERS
COLUMN name_col_plus_show_param FORMAT a30 HEADING NAME
COLUMN value_col_plus_show_param FORMAT a100 HEADING VALUE

