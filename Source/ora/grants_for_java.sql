 begin
 dbms_java.grant_permission( 'CRM_33_CHE', 'SYS:java.util.logging.LoggingPermission', 'control', '' );
 end;
 
 begin
 dbms_java.grant_permission( 'CRM_33_CHE', 'SYS:java.net.SocketPermission', 'localhost', 'resolve' );
 end;
 
 begin
  dbms_java.grant_permission( 'CRM_33_CHE', 'SYS:java.net.SocketPermission', '127.0.0.1:5000', 'connect,resolve' );
 end;
 
 begin
 dbms_java.grant_permission( 'CRM_33_CHE', 'SYS:java.net.SocketPermission', 'che-PC', 'resolve' );
 end;
 
 begin
 dbms_java.grant_permission( 'CRM_33_CHE', 'SYS:java.net.SocketPermission', '192.168.56.102:49297', 'connect,resolve' );
 end;
 
 begin
  dbms_java.grant_permission( 'CRM_33_CHE', 'SYS:java.net.SocketPermission', '192.168.56.102:5000', 'connect,resolve' );
 end;
 
 begin
    dbms_java.grant_permission( 'CRM_33_CHE', 'SYS:java.net.SocketPermission', '192.168.56.102:49303', 'connect,resolve' );
 end;