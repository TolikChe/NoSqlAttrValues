DROP JAVA SOURCE "NoSqlAPI";

CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "NoSqlAPI" as 
    import oracle.kv.*;
    import  java.sql.*;
    import  java.lang.*;
    import  java.math.*;
    import java.io.*;
    import oracle.sql.*;
    import java.util.*;
    import java.sql.ResultSet;
    import oracle.jdbc.driver.*;    
    import oracle.sql.ARRAY;    
    import java.io.UnsupportedEncodingException;

    public class NoSqlAPI extends Object {
        
        // -----------------------------------------  Функции по добавлению строк ----------------------------------- 
        
        
        // 
        // Добавляем одну строку в хранилище
        // Параметры: 
        // String host - ПК на котором хранилище
        // Integer port - Порт на котором сидит хранилище 
        // String storeName - Имя хранилища 
        // String key - Ключ строки, которую добавимс в хранилище 
        // String value - Значение строки, которую добавляем в хранилище
        public static void addRow(String host, Integer port, String storeName, String key, String value) {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // Откроем соединение с хранилищем
            Storage storage = new Storage(host, port.intValue(), storeName);
            // Добавляем строку
            storage.addRow(Key.fromString(key), value.getBytes());
            //
            // Закроем соединение с хранилищем
            storage.close();
        }

        // 
        // Добавляем массив строк в хранилище
        // Параметры: 
        // String host - ПК на котором хранилище
        // Integer port - Порт на котором сидит хранилище 
        // String storeName - Имя хранилища 
        // ARRAY values - Массив структур, состоящих из двух полей: ключ и значение         
        public static void addRows(String host, Integer port, String storeName, ARRAY values)  throws SQLException, ClassNotFoundException {
            //
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            // Откроем соединение с хранилищем
            Storage storage = new Storage(host, port.intValue(), storeName);
            
            // Заведем струкутру под входные значения
            ArrayList<StorageRow> rows = new ArrayList<StorageRow>();
            
            // На вход получаем массив объектов. Нужно преобразовать его.
            Object[] objects = (Object[])values.getArray();
             
            // Разберем коллекцию и над каждым из элементов выполним преобразование типов
            for (int i=0; i<objects.length; i++)
            {
               // На основе значений наполним новую коллекицю
               rows.add (new StorageRow( (String)(((STRUCT)objects[i]).getAttributes())[0] ,   (String) (((STRUCT)objects[i]).getAttributes())[1]   ));
            }

            // Занесем значения в хранилище
            storage.addRowList(rows);

            // Закроем соединение с хранилищем
            storage.close();
        }        

        // --------------------------------------------- Функции по удалению строк ----------------------------------------        
        
        
        //
        // Удаляем одну строку из хранилища
        // Параметры: 
        // String host - ПК на котором хранилище
        // Integer port - Порт на котором сидит хранилище 
        // String storeName - Имя хранилища 
        // String key - Ключ строки, по которому будем удалять запись. Полный ключ.
         public static Integer deleteRow(String host, Integer port, String storeName, String key) {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // Откроем соединение с хранилищем
            Storage storage = new Storage(host, port.intValue(), storeName);
            // Удаляем строку
            int result = storage.deleteRow(Key.fromString(key));
            //
            // Закроем соединение с хранилищем
            storage.close();
            //
            // Вернем результат
            return result;
        }
        
        //
        // Удаляем набор строк из хранилища по части ключа (полному major ключу)
        // Параметры: 
        // String host - ПК на котором хранилище
        // Integer port - Порт на котором сидит хранилище 
        // String storeName - Имя хранилища 
        // String key - Часть ключа строки, содержащая полный major ключ.  По ней будем удалять удалять записи.        
         public static Integer deleteRows(String host, Integer port, String storeName, String key) {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // Откроем соединение с хранилищем
            Storage storage = new Storage(host, port.intValue(), storeName);
            // Удаляем строку
            int result = storage.deleteRowList(Key.fromString(key));
            //
            // Закроем соединение с хранилищем
            storage.close();
            //
            // Вернем результат
            return result;
        }        

        //
        // Удаляем массив строк из хранилища
        // Параметры: 
        // String host - ПК на котором хранилище
        // Integer port - Порт на котором сидит хранилище 
        // String storeName - Имя хранилища 
        // ARRAY a_keys - Массив ключей, по которым будем удалять записи        
         public static Integer deleteRows(String host, Integer port, String storeName, ARRAY a_keys)  throws SQLException {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // Откроем соединение с хранилищем
            Storage storage = new Storage(host, port.intValue(), storeName);
            // На вход получаем массив строк. Нужно преобразовать тип 
            String[] keys = (String[])a_keys.getArray();            
            // Теперь каждую строку массива преобразовываем и вызываем метод хранилища
            int result = 0;
            for (String key : keys ) {
                // Удаляем строку из хранилища
                result += storage.deleteRow(Key.fromString(key));
            }
            //
            // Закроем соединение с хранилищем
            storage.close();
            //
            // Вернем результат
            return result;
        }
        

        //
        // Очистка хранилища. Удаляем строки по полному ключу и части ключа (не обязательно полный major. можно меньше)
        // Параметры: 
        // String host - ПК на котором хранилище
        // Integer port - Порт на котором сидит хранилище 
        // String storeName - Имя хранилища 
        // String key - Часть ключа.  По ней будем удалять удалять записи.        
         public static Integer clearStorage(String host, Integer port, String storeName, String key) {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // Откроем соединение с хранилищем
            Storage storage = new Storage(host, port.intValue(), storeName);
            // Удаляем строку
            int result = storage.clearStorage(Key.fromString(key));
            //
            // Закроем соединение с хранилищем
            storage.close();
            //
            // Вернем результат
            return result;
        }    
        

         // ----------------------------------------------  Функции по получению строк ----------------------------------------


        //
        // Получаем значение одной строки по полному ключу 
        // Параметры: 
        // String host - ПК на котором хранилище
        // Integer port - Порт на котором сидит хранилище 
        // String storeName - Имя хранилища 
        // String key - Часть ключа.  По ней будем удалять удалять записи.        
         public static String getRowValue(String host, Integer port, String storeName, String key) throws UnsupportedEncodingException {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // Откроем соединение с хранилищем
            Storage storage = new Storage(host, port.intValue(), storeName);
            // Удаляем строку
            String result = storage.getRowValue(Key.fromString(key));
            //
            // Закроем соединение с хранилищем
            storage.close();
            //
            // Вернем результат
            return result;
        }  

         
         //
         // Получаем строки из хранилища. 
         // Major часть ключа должна быть указана полностью обязательно
         // Самую последнюю часть указывать нельзя. Здесь нет преобразования входного ключа. Но есть преобразорвание выходного ключа
         public static void getRows(String host, Integer port, String storeName, String key, ARRAY[] res_out) throws SQLException, UnsupportedEncodingException {
            // System.out.println("1connect to " +storeName + " on " + host + ":" + port );
            //
            // Откроем соединение с хранилищем
            Storage storage = new Storage(host, port.intValue(), storeName);
            // 
            // получим строки из хранилища
            ArrayList<StorageRow> rows = storage.getRowList(Key.fromString(key));
            
            int i = 0;
            Object[][] result = new Object[rows.size()][2];
            
            for (StorageRow row : rows ) {
                result[i][0] = row.getKey();
                result[i][1] = row.getValue();
                i++;
            } 
            
            //
            // Вернем массив структур из процедуры
            Connection conn = new OracleDriver().defaultConnection();
            ArrayDescriptor descriptor = ArrayDescriptor.createDescriptor("NOSQLSTORAGEROWLIST", conn);
            res_out[0] = new ARRAY(descriptor, conn, result);
            //
            // Закроем соединение с хранилищем
            storage.close();
        }
        
         // ----------------------------------------------- Вспомогательные функции ------------------------------------------------
         
         
         //
         // Получаем строки из хранилища по части major ключа. Для полного ключа этот метод не работает.
         // Здесь нет преобразования входного ключа. Но есть преобразорвание выходного ключа
         public static Integer getRowsCount(String host, Integer port, String storeName, String key) throws SQLException {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // Откроем соединение с хранилищем
            Storage storage = new Storage(host, port.intValue(), storeName);
            // 
            // получим строки из хранилища
            int result = storage.getRowsCount(Key.fromString(key));
            //
            // Закроем соединение с хранилищем
            storage.close();
            //
            // Вернем результат
            return result;
        }   
        
    }
/
