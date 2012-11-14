-- Simple but sometimes very useful :)
set lines 180 pages 1000
SELECT a.sid||','||a.serial#, a.opname, a.target, a.target_desc, a.sofar,
       a.totalwork, a.units, a.start_time, a.last_update_time,
       a.time_remaining, a.elapsed_seconds, a.context, a.message,
       a.username, a.sql_address, a.sql_hash_value, a.qcsid
  FROM gv$session_longops a 
where a.time_remaining <> 0
  order by a.target, TIME_REMAINING desc;
