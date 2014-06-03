
-- Подсчет числа строк с таким или похожим ключем
select NOSQLAPI.getRowsCount('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value') from dual;

/************************************************************************************/

-- Удаление строки по ключу. На вход нужно передавать целый ключ
begin
    dbms_output.put_line(NOSQLAPI.DELETEROW('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/19525562/-/200000747/value/4'));
end;
--
--
-- Удаление строки по части ключа. На вход нужно передавать полный major ключ
begin
    --dbms_output.put_line(NOSQLAPI.DELETEROWS('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value'));
    dbms_output.put_line(NOSQLAPI.DELETEROWS('192.168.56.102', 5000 , 'kvstore', '/che'));
end;

/************************************************************************************/

-- Занесение строки в NOSQL. Заносим строки пачками
declare 
    new_rows varchar_table := new varchar_table();
    cnt number := 0; 
	amount number := 50;
begin
    dbms_java.set_output(1000000);
    --
    -- Через pl_sql добавляем строки
    --
    -- Выбираем все значения допов    
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
        -- Заносим ключ в коллекцию
        cnt := cnt + 1;
        new_rows.extend;
        new_rows(new_rows.count) := x.key;
        -- добавляем коллекцию в хранилище
        -- В коллекции amount строк
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
            -- Очистим коллекицю
            new_rows.delete;
        end if;
    end loop;
    -- Добавим в хранилище то что не быловнесено на последнем шаге
    NOSQLAPI.ADDROWS('192.168.56.102', 5000 , 'kvstore', new_rows);
    new_rows.delete;
end;

/**************************************************************************************/

-- Заносим строки в NOSQL. Заносим строки по одной
begin
    dbms_java.set_output(500);

    -- Выбираем все значения допов    
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
        -- добавляем ключ в хранилище
        NOSQLAPI.ADDROW('192.168.56.102', 5000 , 'kvstore', x.key);
    end loop;
end;
                       
/*************************************************************************************/			
		   
-- Прочитаем строки по полному major ключу. Получаем полную строку
declare 
    res varchar_table;
begin
    -- Через pl_sql вызываем чтение строк
    NOSQLAPI.getRows('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/19525562/-/200000747', res);

    if res.count > 0 then 
        for x  in res.first .. res.last 
        loop
            dbms_output.put_line (res(x));
        end loop;
    end if;

    -- Через pl_sql вызываем чтение строк
    NOSQLAPI.getRows('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/19525562', res);

    if res.count > 0 then 
        for x  in res.first .. res.last 
        loop
            dbms_output.put_line (res(x));
        end loop;
    end if;
end;

/************************************************************************************/

-- Прочитаем строки при помощи таблицы
select * from table ( NOSQLAPI.GETROWSVALUE('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12/19525562') )

/************************************************************************************/

-- Прочитаем строки по части major ключа. Получаем полную строку
declare 
    res varchar_table;
begin
    DBMS_OUTPUT.ENABLE(1000000);
    -- Через pl_sql вызываем чтение строк
    NOSQLAPI.getRowsPartKey('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12', res);

    if res.count > 0 then 
        for x  in res.first .. res.last 
        loop
            dbms_output.put_line (res(x));
        end loop;
    end if;
end;

/*************************************************************************************/

-- Прочитаем строки при помощи таблицы по части ключа
select * from table ( NOSQLAPI.getRowsValuePartKey('192.168.56.102', 5000 , 'kvstore', '/cms_attr_value/12') )

/**************************************************************************************/