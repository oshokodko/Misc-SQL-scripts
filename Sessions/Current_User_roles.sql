DECLARE @login NVARCHAR(256), @user NVARCHAR(256);

SELECT @login = login_name FROM sys.dm_exec_sessions WHERE session_id = @@SPID;

SELECT @user = d.name
  FROM sys.database_principals AS d
  INNER JOIN sys.server_principals AS s
  ON d.sid = s.sid
  WHERE s.name = @login;

SELECT u.name, r.name
  FROM sys.database_role_members AS m
  INNER JOIN sys.database_principals AS r
  ON m.role_principal_id = r.principal_id
  INNER JOIN sys.database_principals AS u
  ON u.principal_id = m.member_principal_id
  WHERE u.name = @user;

SELECT class_desc, major_id, permission_name, state_desc
  FROM sys.database_permissions
  WHERE grantee_principal_id = USER_ID(@user);