
-- ������� ����� ����� � ����� ��� ������� ������
select NOSQLAPI.getRowsCount('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value') from dual;

/************************************************************************************/

-- �������� ������ �� �����. �� ���� ����� ���������� ����� ����
begin
    dbms_output.put_line(NOSQLAPI.DELETEROW('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/19525562/-/200000747/value/4'));
end;
--
--
-- �������� ������ �� ����� �����. �� ���� ����� ���������� ������ major ����
begin
    --dbms_output.put_line(NOSQLAPI.DELETEROWS('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value'));
    dbms_output.put_line(NOSQLAPI.DELETEROWS('192.168.56.102', 5000 , 'kvstore', '/che'));
end;

/************************************************************************************/

-- ��������� ������ � NOSQL. ������� ������ �������
declare 
    new_rows varchar_table := new varchar_table();
    cnt number := 0; 
	amount number := 50;
begin
    dbms_java.set_output(1000000);
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
                               || '/value/'
                               || NVL (string_value, TO_CHAR (date_value_utc, 'yyyy:mm:dd:hh24:mi:ss')) AS key
                      FROM cms_attr_value
                     WHERE ROWNUM < 10000000)
    loop
        -- ������� ���� � ���������
        cnt := cnt + 1;
        new_rows.extend;
        new_rows(new_rows.count) := x.key;
        -- ��������� ��������� � ���������
        -- � ��������� amount �����
        if mod(cnt, amount) = 0 then 
            begin
                NOSQLAPI.ADDROWS('192.168.56.102', 5000 , 'kvstore', new_rows);
             exception when others then 
                dbms_output.put_line('----------');
                for y in new_rows.first .. new_rows.last loop
                    dbms_output.put_line(new_rows(y));
                end loop;
                dbms_output.put_line(' ');
             end;
            -- ������� ���������
            new_rows.delete;
        end if;
    end loop;
    -- ������� � ��������� �� ��� �� ����������� �� ��������� ����
    NOSQLAPI.ADDROWS('192.168.56.102', 5000 , 'kvstore', new_rows);
    new_rows.delete;
end;

/**************************************************************************************/

-- ������� ������ � NOSQL. ������� ������ �� �����
begin
    dbms_java.set_output(500);

    -- �������� ��� �������� �����    
    for x in (SELECT    '/cms_attr_value/'
                               || etyp_etyp_id
                               || '/'
                               || entity_id
                               || '/-/'
                               || adat_adat_id
                               || '/value/'
                               || NVL (string_value, TO_CHAR (date_value_utc, 'yyyy:mm:dd:hh24:mi:ss')) AS key
                      FROM cms_attr_value
                     WHERE ROWNUM < 10000)
    loop
        --dbms_output.put_line (x.key);
        -- ��������� ���� � ���������
        NOSQLAPI.ADDROW('192.168.56.102', 5000 , 'kvstore', x.key);
    end loop;
end;
                       
/*************************************************************************************/			
		   
-- ��������� ������ �� ������� major �����. �������� ������ ������
declare 
    res varchar_table;
begin
    -- ����� pl_sql �������� ������ �����
    NOSQLAPI.getRows('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/19525562/-/200000747', res);

    if res.count > 0 then 
        for x  in res.first .. res.last 
        loop
            dbms_output.put_line (res(x));
        end loop;
    end if;

    -- ����� pl_sql �������� ������ �����
    NOSQLAPI.getRows('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/19525562', res);

    if res.count > 0 then 
        for x  in res.first .. res.last 
        loop
            dbms_output.put_line (res(x));
        end loop;
    end if;
end;

/************************************************************************************/

-- ��������� ������ ��� ������ �������
select * from table ( NOSQLAPI.GETROWSVALUE('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/19525562') )

/************************************************************************************/

-- ��������� ������ �� ����� major �����. �������� ������ ������
declare 
    res varchar_table;
begin
    DBMS_OUTPUT.ENABLE(1000000);
    -- ����� pl_sql �������� ������ �����
    NOSQLAPI.getRowsPartKey('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12', res);

    if res.count > 0 then 
        for x  in res.first .. res.last 
        loop
            dbms_output.put_line (res(x));
        end loop;
    end if;
end;

/*************************************************************************************/

-- ��������� ������ ��� ������ ������� �� ����� �����
select * from table ( NOSQLAPI.getRowsValuePartKey('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12') )

/**************************************************************************************/