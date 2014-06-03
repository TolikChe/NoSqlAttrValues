-- ������� ����� ����� � ����� ��� ������� ������
--select NOSQLAPI.getRowsCount('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value') from dual;

-- ��������� ����� � ����� ��� ������� ������ ����� ������ SQL
--select * from table( NOSQLAPI.getRows('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value'));


declare 
    res NOSQLSTORAGEROWLIST;
    --
    new_rows NOSQLSTORAGEROWLIST := new NOSQLSTORAGEROWLIST();
    --
    del_keys varchar_table := new varchar_table();
    
begin
    dbms_java.set_output(500);

    dbms_output.put_line ('TEST addRow');
    -- ����� pl_sql ��������� ������    
    NOSQLAPI.ADDROW('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/100/-/150/1', 'value1' );
    NOSQLAPI.ADDROW('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/100/-/160/1', 'value2' );
    NOSQLAPI.ADDROW('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/100/-/170/1', 'value3' );
    NOSQLAPI.ADDROW('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/100/-/180/1', 'value4' );
    --
    dbms_output.put_line ('');
    dbms_output.put_line ('');
    --    
    dbms_output.put_line ('TEST addRows');    
    -- ����� pl_sql ��������� ������ �����
    new_rows.extend;
    new_rows.extend;
    new_rows.extend;
    new_rows.extend;
    new_rows.extend;
    new_rows.extend;        
    --
    new_rows(1) := new NOSQLSTORAGEROW ( '/cms_attr_value/12/101/-/160/1', 'value6' );
    new_rows(2) := new NOSQLSTORAGEROW ( '/cms_attr_value/12/101/-/170/1', 'value7' );
    new_rows(3) := new NOSQLSTORAGEROW ( '/cms_attr_value/12/101/-/180/1', 'value8' );
    new_rows(4) := new NOSQLSTORAGEROW ( '/cms_attr_value/12/101/-/190/1', 'value9' );
    new_rows(5) := new NOSQLSTORAGEROW ( '/cms_attr_value/12/110/-/150/1', 'value1' );
    new_rows(6) := new NOSQLSTORAGEROW ( '/cms_attr_value/12/110/-/160/1', 'value2' );
    -- ������� � ��������� ������
    NOSQLAPI.ADDROWS('192.168.56.102', 5000 , 'kvstore', new_rows);
    --   
    dbms_output.put_line ('');
    dbms_output.put_line ('');
    --
    dbms_output.put_line ('TEST deleteRow OneRow');
    -- ����� pl_sql ������� ������
    dbms_output.put_line(NOSQLAPI.deleteRow('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/100/-/150/1'));
    dbms_output.put_line(NOSQLAPI.deleteRow('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/100/-/150/2'));

    --   
    dbms_output.put_line ('');
    dbms_output.put_line ('');
    --
    dbms_output.put_line ('TEST deleteRows PartKey');
    -- ����� pl_sql ������� ������. �� ����� ����� 
    dbms_output.put_line(NOSQLAPI.deleteRows('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/110'));
    --   
    dbms_output.put_line ('');
    dbms_output.put_line ('');
    --
    dbms_output.put_line ('TEST deleteRows List');
    -- ����� pl_sql ������� ������. ������� �������
    del_keys.extend();
    del_keys.extend();
    del_keys(1) := '/cms_attr_value/12/101/-/170/1';
    del_keys(2) := '/cms_attr_value/12/101/-/180/1'; 
    dbms_output.put_line(NOSQLAPI.deleteRows('192.168.56.102', 5000 , 'kvstore', del_keys));

    --   
    dbms_output.put_line ('');
    dbms_output.put_line ('');
    -- /cms_attr_value/12/100/-/170/1      ------     value3 
    dbms_output.put_line ('TEST getRowValue  (value3)');
    dbms_output.put_line(NOSQLAPI.getRowValue('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/100/-/170/1'));
    --   
    dbms_output.put_line ('');
    dbms_output.put_line ('');
    --
    dbms_output.put_line ('TEST getRows PartKey (FullMajor)');
    -- ����� pl_sql �������� ������ �����
    NOSQLAPI.getRows('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/100', res);
    
    if res.count > 0 then 
        for x  in res.first .. res.last 
        loop
            dbms_output.put_line ( res(x).key || ' ## ' || res(x).value );
        end loop;
    end if;
    --   
    
    dbms_output.put_line ('');
    dbms_output.put_line ('');
    --
    dbms_output.put_line ('TEST getRows FullKey');
    -- ����� pl_sql �������� ������ �����
    NOSQLAPI.getRows('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/100/-/150/1', res);

    if res.count > 0 then 
        for x  in res.first .. res.last 
        loop
            dbms_output.put_line ( res(x).key || ' ## ' || res(x).value);
        end loop;
    end if;
    
    --   
    dbms_output.put_line ('');
    dbms_output.put_line ('');
    --
    dbms_output.put_line ('TEST getRows PartlKey (not full major)');
    -- ����� pl_sql �������� ������ �����
    NOSQLAPI.getRows('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value', res);

    if res.count > 0 then 
        for x  in res.first .. res.last 
        loop
            dbms_output.put_line ( res(x).key || ' ## ' || res(x).value);
        end loop;
    end if;    

    dbms_output.put_line('----------------------------------------------------------------------');

    --dbms_output.put_line(NOSQLAPI.clearStorage('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value'));

    
end;
