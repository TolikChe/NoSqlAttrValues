CREATE OR REPLACE package NoSqlAPI
as
    hostName varchar2(50);
    hostPort number;
    storageName varchar2(50);
    
    type t_cms_attr_value is record 
    (
        entity_id number,
        etyp_etyp_id number,
        adat_adat_id number,
        oper_oper_id number,
        value varchar2(4000)
    );
        
    type t_cms_attr_value_list is table of t_cms_attr_value;

   ---------------------------------------------------------------------------------------------------    
   -------------------------------------------- Добавление строк --------------------------------
    
  /* 
     04.03.2013 Черкасов А.
   * Процедура:
       addRow
   * Описание:
       Добавление одной строки в хранилище
   * Параметры:
        p_host            IN  varchar2    Хост на котором запущен сервер NoSql
        p_port            IN  NUMBER     Порт хоста на котором запущен сервер NoSql
        p_storeName  IN  varchar2  Имя хранилища NoSql
        p_key             IN varchar2   Ключ, который хотим добавить в хранилище 
        p_value           IN varchar2   Значение для ключа, которое хотим добавить в хранилище
   * Возвращаемое значение:
        Нет
   * Примечание:
        Содержит под собой вызов процедуры на Java 
   * Исключения:
        Нет
   */    
    procedure addRow (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2, p_value in varchar2 );
    --
  /* 
     04.03.2013 Черкасов А.
   * Процедура:
       addRows
   * Описание:
       Добавление массива строк в хранилище
   * Параметры:
        p_host            IN  varchar2                          Хост на котором запущен сервер NoSql
        p_port            IN  NUMBER                           Порт хоста на котором запущен сервер NoSql
        p_storeName  IN  varchar2                           Имя хранилища NoSql
        p_in_array      IN NOSQLSTORAGEROWLIST  Массив ключей, которые хотим добавить в хранилище 
   * Возвращаемое значение:
        Нет
   * Примечание:
        Содержит под собой вызов процедуры на Java 
   * Исключения:
        Нет
   */    
    procedure addRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_in_array in NOSQLSTORAGEROWLIST);
    --
    ----------------------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------- Удаление строк -------------------------------------------------------------
    --
  /* 
     04.03.2013 Черкасов А.
   * Функция:
       deleteRow
   * Описание:
       Удаление одной строки из хранилища
   * Параметры:
        p_host            IN  varchar2       Хост на котором запущен сервер NoSql
        p_port            IN  NUMBER        Порт хоста на котором запущен сервер NoSql
        p_storeName  IN  varchar2       Имя хранилища NoSql
        p_key             IN varchar2        Ключ целиком, который хотим удалить из хранилища 
   * Возвращаемое значение:
        Если строка удалена успешно то возвращается 1. Если строка не удалена или не найдена то 0.
   * Примечание:
        Содержит под собой вызов процедуры на Java
   * Исключения:
        Нет
   */         
    function deleteRow (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return number;
    --
  /* 
     04.03.2013 Черкасов А.
   * Функция:
       deleteRows
   * Описание:
       Удаление строк из хранилища по ключу.
   * Параметры:
        p_host            IN  varchar2       Хост на котором запущен сервер NoSql
        p_port            IN  NUMBER        Порт хоста на котором запущен сервер NoSql
        p_storeName  IN  varchar2       Имя хранилища NoSql
        p_key             IN varchar2        Часть ключа, по которой хотим удалить все строки похожие на него. Полностью должна быть major часть.  
   * Возвращаемое значение:
        Число удаленных строк
   * Примечание:
        Содержит под собой вызов процедуры на Java
   * Исключения:
        Нет
   */
    function deleteRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return number;
    --
  /* 
     04.03.2013 Черкасов А.
   * Функция:
       deleteRows
   * Описание:
       Удаление масива строк из хранилища.
   * Параметры:
        p_host            IN  varchar2       Хост на котором запущен сервер NoSql
        p_port            IN  NUMBER        Порт хоста на котором запущен сервер NoSql
        p_storeName  IN  varchar2       Имя хранилища NoSql
        p_in_array      IN varchar_table Массив ключей, которые хотим удалить из хранилища  
   * Возвращаемое значение:
        Число удаленных строк
   * Примечание:
        Содержит под собой вызов процедуры на Java
   * Исключения:
        Нет
   */
    function deleteRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_in_array in varchar_table) return number;
    

/* 
     04.03.2013 Черкасов А.
   * Функция:
       clearStorage
   * Описание:
       Удаление строк из хранилища. Можно использовать целый ключ, часть ключа и даже чать ключа меньше чем major
   * Параметры:
        p_host            IN  varchar2       Хост на котором запущен сервер NoSql
        p_port            IN  NUMBER        Порт хоста на котором запущен сервер NoSql
        p_storeName  IN  varchar2       Имя хранилища NoSql
        p_key             IN varchar2        Часть ключа, по которой хотим удалить все строки похожие на него.
   * Возвращаемое значение:
        Число удаленных строк
   * Примечание:
        Содержит под собой вызов процедуры на Java
   * Исключения:
        Нет
   */
    function clearStorage (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return number;    
    
    --
    ----------------------------------------------------------------------------------------------------------------------------------------------
    ---------------------------------------------------- Получение строк ---------------------------------------------------------------------
    --
  /* 
     04.03.2013 Черкасов А.
   * Функция:
       getRowValue
   * Описание:
       Получение значения одной строки из хранилища по полному ключу
   * Параметры:
        p_host            IN  varchar2       Хост на котором запущен сервер NoSql
        p_port            IN  NUMBER        Порт хоста на котором запущен сервер NoSql
        p_storeName  IN  varchar2       Имя хранилища NoSql
        p_key             IN varchar2        полный ключ.
   * Возвращаемое значение:
        Значение строки
   * Примечание:
        Содержит под собой вызов процедуры на Java
   * Исключения:
        Нет
   */  
    function getRowValue (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return varchar2;    
    --
  /* 
     04.03.2013 Черкасов А.
   * Процедура:
       getRows
   * Описание:
       Получение масива строк из хранилища.
   * Параметры:
        p_host            IN  varchar2       Хост на котором запущен сервер NoSql
        p_port            IN  NUMBER        Порт хоста на котором запущен сервер NoSql
        p_storeName  IN  varchar2       Имя хранилища NoSql
        p_key             IN varchar2        Часть ключа, по которой хотим получить все строки похожие на него. Полностью должна быть major часть. Можно указать ключ полностью.
        p_out_array    OUT NOSQLSTORAGEROWLIST Массив строк, которые подошли под переданный ключ  
   * Возвращаемое значение:
        Нет
   * Примечание:
        Содержит под собой вызов процедуры на Java
   * Исключения:
        Нет
   */    
    procedure getRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2, p_out_array out NOSQLSTORAGEROWLIST);    
    --
  /* 
     04.03.2013 Черкасов А.
   * Функция:
       getRows
   * Описание:
       Получение строк из хранилища путем выполнения sql запроса.
   * Параметры:
        p_host            IN  varchar2       Хост на котором запущен сервер NoSql
        p_port            IN  NUMBER        Порт хоста на котором запущен сервер NoSql
        p_storeName  IN  varchar2       Имя хранилища NoSql
        p_key             IN varchar2        Часть ключа, по которой хотим получить все строки похожие на него. Полностью должна быть major часть. Можно указать ключ полностью.
   * Возвращаемое значение:
        Строки повторяющие структуру таблицы cms_attr_value
   * Примечание:
        Содержит под собой вызов процедуры на Java
   * Исключения:
        Нет
   */  
    function getRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return t_cms_attr_value_list pipelined;
   
    -----------------------------------------------------------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------- Вспомогательные функции ----------------------------------------------------
    --
  /* 
     04.03.2013 Черкасов А.
   * Функция:
       getRowsCount
   * Описание:
       Получение числа строк по указанному ключу 
   * Параметры:
        p_host            IN  varchar2       Хост на котором запущен сервер NoSql
        p_port            IN  NUMBER        Порт хоста на котором запущен сервер NoSql
        p_storeName  IN  varchar2       Имя хранилища NoSql
        p_key             IN varchar2        Часть ключа, по которой хотим получить число строк похожих на него. Полностью должна быть major часть. Можно указать ключ полностью.
   * Возвращаемое значение:
         Число строк, подходящих по ключу
   * Примечание:
        Содержит под собой вызов процедуры на Java
   * Исключения:
        Нет
   */
    function getRowsCount (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return number;
    
end;
/