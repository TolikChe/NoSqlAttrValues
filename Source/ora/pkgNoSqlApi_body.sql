CREATE OR REPLACE PACKAGE BODY NoSqlAPI
AS
   --
   -- ���������� ����� ������ � ���������
       procedure addRow (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2, p_value in varchar2 )
   AS
      LANGUAGE JAVA
      NAME 'NoSqlAPI.addRow(java.lang.String, java.lang.Integer, java.lang.String, java.lang.String, java.lang.String )' ;
   --
   -- ���������� ������� ����� � ���������
   PROCEDURE addRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_in_array in NOSQLSTORAGEROWLIST)
   AS
      LANGUAGE JAVA
      NAME 'NoSqlAPI.addRows(java.lang.String, java.lang.Integer, java.lang.String, oracle.sql.ARRAY )' ;
      
      
      
      
   --
   -- �������� ����� ������ �� ���������
   FUNCTION deleteRow (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return number
   AS
      LANGUAGE JAVA
      NAME 'NoSqlAPI.deleteRow(java.lang.String, java.lang.Integer, java.lang.String, java.lang.String) return Integer' ;
   --
   -- �������� ����� �� ��������� �� ������� major �����.
   FUNCTION deleteRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return number
   AS
      LANGUAGE JAVA
      NAME 'NoSqlAPI.deleteRows(java.lang.String, java.lang.Integer, java.lang.String, java.lang.String) return Integer' ;
   --
   -- �������� ������ ����� �� ���������.
   FUNCTION deleteRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_in_array in varchar_table) return number
   AS
      LANGUAGE JAVA
      NAME 'NoSqlAPI.deleteRows(java.lang.String, java.lang.Integer, java.lang.String, oracle.sql.ARRAY) return Integer' ;
   --
   -- �������� ����� �� ���������. �������� ��������� �����
   FUNCTION clearStorage (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return number
   AS
      LANGUAGE JAVA
      NAME 'NoSqlAPI.clearStorage(java.lang.String, java.lang.Integer, java.lang.String, java.lang.String) return Integer' ;



      
   --
   -- ��������� �������� ����� ������ �� �����    
   FUNCTION getRowValue (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return varchar2
   AS
      LANGUAGE JAVA
      NAME 'NoSqlAPI.getRowValue(java.lang.String, java.lang.Integer, java.lang.String, java.lang.String) return String' ;        
   --
   --  ��������� ��������� ����� �� ���������
   PROCEDURE getRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2, p_out_array out NOSQLSTORAGEROWLIST)
   AS
      LANGUAGE JAVA
      NAME 'NoSqlAPI.getRows(java.lang.String, java.lang.Integer, java.lang.String, java.lang.String, oracle.sql.ARRAY[])' ;
   --
   -- �������� ������� ��� ��������� ����� �� ���������
   function getRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return t_cms_attr_value_list pipelined
   as
        java_res NOSQLSTORAGEROWLIST;
        res t_cms_attr_value;
        --
   begin
        -- �� �������� ���������� �������� ������ �� ���������  
        getRows(p_host, p_port , p_storeName, p_key, java_res);

        -- ���������� ������ ��������� � ��������� ��� ��������� 
        FOR i IN java_res.first .. java_res.last
        LOOP
                
        
                res.etyp_etyp_id := substr(java_res(i).key, instr(java_res(i).key, '/', 1, 2) + 1 , instr(java_res(i).key, '/', 1, 3) - instr(java_res(i).key, '/', 1, 2) - 1 );
                res.entity_id :=  substr(java_res(i).key, instr(java_res(i).key, '/', 1, 3) + 1 , instr(java_res(i).key, '/', 1, 4) - instr(java_res(i).key, '/', 1, 3) - 1 );              
                res.adat_adat_id := substr(java_res(i).key, instr(java_res(i).key, '/', 1, 5) + 1 , instr(java_res(i).key, '/', 1, 6) - instr(java_res(i).key, '/', 1, 5) - 1 );
                res.oper_oper_id :=  substr(java_res(i).key, instr(java_res(i).key, '/', -1) + 1 );
                res.value := java_res(i).value;
        
        /*        
                select 
                  substr(java_res(i).key, instr(java_res(i).key, '/', 1, 2) + 1 , instr(java_res(i).key, '/', 1, 3) - instr(java_res(i).key, '/', 1, 2) - 1 ),
                  substr(java_res(i).key, instr(java_res(i).key, '/', 1, 3) + 1 , instr(java_res(i).key, '/', 1, 4) - instr(java_res(i).key, '/', 1, 3) - 1 ),              
                  substr(java_res(i).key, instr(java_res(i).key, '/', 1, 5) + 1 , instr(java_res(i).key, '/', 1, 6) - instr(java_res(i).key, '/', 1, 5) - 1 ),
                  substr(java_res(i).key, instr(java_res(i).key, '/', -1) + 1 ),
                  java_res(i).value
                into res.etyp_etyp_id, res.entity_id, res.adat_adat_id, res.oper_oper_id, res.value  
                from dual;                
          */       
                 pipe row(res);
         END LOOP;
        return;    
   end getRows;
   
   
   
   -- 
   -- ��������� ����� ����� �� ����� � ���������
   function getRowsCount (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return number
   as
   LANGUAGE JAVA
        NAME 'NoSqlAPI.getRowsCount(java.lang.String, java.lang.Integer, java.lang.String, java.lang.String)  return Integer';

begin
    dbms_java.set_output(500);
END;
/