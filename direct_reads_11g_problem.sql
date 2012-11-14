--- Hourly based comparison between Physical reads and Direct Reads
select
    s1.h_date,
    trunc(s1.v_avg,2) pyh_reads,
    trunc(s2.v_avg,2) dir_reads,
    trunc(s1.mb_sec,2) pyh_mb_s,
    trunc(s2.mb_sec,2) dir_mb_s,
    trunc((s2.v_avg/s1.v_avg)*100,2) R_PCT
from 
--S1-B-----------
(
select 
	trunc(b_snap_date,'HH') h_date, 
	sum(snap_value) svalue, 
	sum(snap_value/snap_secs) v_avg,
	sum(snap_value/snap_secs)*v_db_block_size/1024/1024 mb_sec
from
(select 
  s.INSTANCE_NUMBER,
  cast (s.END_INTERVAL_TIME as date) e_snap_date,
  cast (s.BEGIN_INTERVAL_TIME as date) b_snap_date,
  (cast(s.END_INTERVAL_TIME as date) - cast(s.BEGIN_INTERVAL_TIME as date))*24*60*60 snap_secs,
  t.VALUE,
  (t.VALUE-LAG (t.VALUE) OVER (ORDER BY s.INSTANCE_NUMBER, s.BEGIN_INTERVAL_TIME)) snap_value
from 
  DBA_HIST_SNAPSHOT s,
  DBA_HIST_SYSSTAT t
where 1=1
  and s.SNAP_ID = t.SNAP_ID
  and s.DBID = t.DBID
  and s.INSTANCE_NUMBER = t.INSTANCE_NUMBER
  and s.DBID = (select DBID from V$DATABASE)
  and t.STAT_NAME = 'physical reads'
  ) pr,
  (select VALUE v_db_block_size from v$parameter where name = 'db_block_size')
where snap_value > 0 
group by trunc(b_snap_date,'HH'),v_db_block_size
) S1,
--S2-B-----------
(
select 
	trunc(b_snap_date,'HH') h_date, 
	sum(snap_value) svalue, 
	sum(snap_value/snap_secs) v_avg,
	sum(snap_value/snap_secs)*v_db_block_size/1024/1024 mb_sec
from
(select 
  s.INSTANCE_NUMBER,
  cast (s.END_INTERVAL_TIME as date) e_snap_date,
  cast (s.BEGIN_INTERVAL_TIME as date) b_snap_date,
  (cast(s.END_INTERVAL_TIME as date) - cast(s.BEGIN_INTERVAL_TIME as date))*24*60*60 snap_secs,
  t.VALUE,
  (t.VALUE-LAG (t.VALUE) OVER (ORDER BY s.INSTANCE_NUMBER, s.BEGIN_INTERVAL_TIME)) snap_value
from 
  DBA_HIST_SNAPSHOT s,
  DBA_HIST_SYSSTAT t
where 1=1
  and s.SNAP_ID = t.SNAP_ID
  and s.DBID = t.DBID
  and s.INSTANCE_NUMBER = t.INSTANCE_NUMBER
  and s.DBID = (select DBID from V$DATABASE)
  and t.STAT_NAME = 'physical reads direct'
  ) pr,
  (select VALUE v_db_block_size from v$parameter where name = 'db_block_size')
where snap_value > 0 
group by trunc(b_snap_date,'HH'),v_db_block_size
) S2
--S2-E-----------
where 1=1
    and s1.h_date = s2.h_date (+)
order by 
    s1.h_date;