select p.spid,  s.sid, s.serial#, s.username, s.server, saddr from v$session s, v$process p
where s.audsid = SYS_CONTEXT ('USERENV', 'SESSIONID')
and s.paddr = p.addr 
/
