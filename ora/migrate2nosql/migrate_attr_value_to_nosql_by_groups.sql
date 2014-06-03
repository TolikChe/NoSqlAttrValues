-- ������� ������ � NOSQL
-- ������� ������ �������
declare 
    new_rows NOSQLSTORAGEROWLIST := new NOSQLSTORAGEROWLIST();
    cnt number := 0; 
    key varchar2(500);
    value varchar2(500);
begin
    dbms_java.set_output(500);
    --
    -- ����� pl_sql ��������� ������
    --
    -- �������� ��� �������� �����    
    for x in (SELECT    '/cms_attr_value/'
                               || etyp_etyp_id
                               || '/'
                               || entity_id
                               || '/-/'
                               || adat_adat_id
                               || '/'
                               || oper_oper_id as key, 
                               NVL (string_value, TO_CHAR (date_value_utc, 'yyyy:mm:dd:hh24:mi:ss')) AS value
                      FROM cms_attr_value
                     WHERE ROWNUM < 10000000)
    loop
        -- ������� ���� � ���������
        cnt := cnt + 1;
        new_rows.extend;
        new_rows(new_rows.count) := new NOSQLSTORAGEROW ( x.key,  x.value) ;
        key := x.key;
        value := x.value;
        
        -- ��������� ��������� � ���������
        -- � ��������� 3000 �����
        if mod(cnt, 3000) = 0 then 
            NOSQLAPI.ADDROWS('192.168.56.102', 5000 , 'kvstore', new_rows);
            -- ������� ���������
            new_rows.delete;
        end if;
    end loop;
    -- ������� � ��������� �� ��� �� ����������� �� ��������� ����
    NOSQLAPI.ADDROWS('192.168.56.102', 5000 , 'kvstore', new_rows);
    new_rows.delete;
exception when others then 
    dbms_output.put_line( key || '::' || value );
    raise;
end;


