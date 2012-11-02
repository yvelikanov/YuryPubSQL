column MTS format a3
column PGASUM format 99,999,999,999,990
column UGASUM format 99,999,999,999,990
column PGA format 999,999,999,990
column UGA format 999,999,999,990
column large_pool_size format 99,999,999,999,990
column shared_pool_size format 99,999,999,999,990
column login format a10
column "OS user" format a10
column "Host name" format a10
column "Prog" format a20
set feedb off pages 2000

select sysdate from dual;

select 	substr(s.username,0,10) Login,
	rpad(s.osuser,10) "OS user",
	substr(s.MACHINE,0,10) "Host name", 
	substr(s.PROGRAM,1,20) Prog,
	substr(t.sid,0,4) sid,
	decode(s.server,'DEDICATED','N','Y') MTS,
	trunc(100*(t.value/tot.PGAtot),2) PGAPCT,
	t.value PGA,
	trunc(100*(tu.value/ugatot.UGAtot),2) UGAPCT,
	tu.value UGA
from 
	v$sesstat tu, 
	v$sesstat t, 
	v$session s, 
	(select sum(value) PGATOT from v$sesstat where STATISTIC#=(select STATISTIC# from v$statname where name = 'session pga memory')) tot,
	(select sum(value) UGATOT from v$sesstat where STATISTIC#=(select STATISTIC# from v$statname where name = 'session uga memory')) ugatot
where 
	s.sid=t.sid 
	and t.STATISTIC#=(select STATISTIC# from v$statname where name = 'session pga memory')
	and s.sid=tu.sid 
	and tu.STATISTIC#=(select STATISTIC# from v$statname where name = 'session uga memory')
order by PGA
/

select sum(value) PGASUM from v$sesstat where STATISTIC#=(select STATISTIC# from v$statname where name = 'session pga memory')
/

select sum(value) UGASUM from v$sesstat where STATISTIC#=(select STATISTIC# from v$statname where name = 'session uga memory')
/

set feedb on
