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
        
        // -----------------------------------------  ������� �� ���������� ����� ----------------------------------- 
        
        
        // 
        // ��������� ���� ������ � ���������
        // ���������: 
        // String host - �� �� ������� ���������
        // Integer port - ���� �� ������� ����� ��������� 
        // String storeName - ��� ��������� 
        // String key - ���� ������, ������� �������� � ��������� 
        // String value - �������� ������, ������� ��������� � ���������
        public static void addRow(String host, Integer port, String storeName, String key, String value) {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // ������� ���������� � ����������
            Storage storage = new Storage(host, port.intValue(), storeName);
            // ��������� ������
            storage.addRow(Key.fromString(key), value.getBytes());
            //
            // ������� ���������� � ����������
            storage.close();
        }

        // 
        // ��������� ������ ����� � ���������
        // ���������: 
        // String host - �� �� ������� ���������
        // Integer port - ���� �� ������� ����� ��������� 
        // String storeName - ��� ��������� 
        // ARRAY values - ������ ��������, ��������� �� ���� �����: ���� � ��������         
        public static void addRows(String host, Integer port, String storeName, ARRAY values)  throws SQLException, ClassNotFoundException {
            //
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            // ������� ���������� � ����������
            Storage storage = new Storage(host, port.intValue(), storeName);
            
            // ������� ��������� ��� ������� ��������
            ArrayList<StorageRow> rows = new ArrayList<StorageRow>();
            
            // �� ���� �������� ������ ��������. ����� ������������� ���.
            Object[] objects = (Object[])values.getArray();
             
            // �������� ��������� � ��� ������ �� ��������� �������� �������������� �����
            for (int i=0; i<objects.length; i++)
            {
               // �� ������ �������� �������� ����� ���������
               rows.add (new StorageRow( (String)(((STRUCT)objects[i]).getAttributes())[0] ,   (String) (((STRUCT)objects[i]).getAttributes())[1]   ));
            }

            // ������� �������� � ���������
            storage.addRowList(rows);

            // ������� ���������� � ����������
            storage.close();
        }        

        // --------------------------------------------- ������� �� �������� ����� ----------------------------------------        
        
        
        //
        // ������� ���� ������ �� ���������
        // ���������: 
        // String host - �� �� ������� ���������
        // Integer port - ���� �� ������� ����� ��������� 
        // String storeName - ��� ��������� 
        // String key - ���� ������, �� �������� ����� ������� ������. ������ ����.
         public static Integer deleteRow(String host, Integer port, String storeName, String key) {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // ������� ���������� � ����������
            Storage storage = new Storage(host, port.intValue(), storeName);
            // ������� ������
            int result = storage.deleteRow(Key.fromString(key));
            //
            // ������� ���������� � ����������
            storage.close();
            //
            // ������ ���������
            return result;
        }
        
        //
        // ������� ����� ����� �� ��������� �� ����� ����� (������� major �����)
        // ���������: 
        // String host - �� �� ������� ���������
        // Integer port - ���� �� ������� ����� ��������� 
        // String storeName - ��� ��������� 
        // String key - ����� ����� ������, ���������� ������ major ����.  �� ��� ����� ������� ������� ������.        
         public static Integer deleteRows(String host, Integer port, String storeName, String key) {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // ������� ���������� � ����������
            Storage storage = new Storage(host, port.intValue(), storeName);
            // ������� ������
            int result = storage.deleteRowList(Key.fromString(key));
            //
            // ������� ���������� � ����������
            storage.close();
            //
            // ������ ���������
            return result;
        }        

        //
        // ������� ������ ����� �� ���������
        // ���������: 
        // String host - �� �� ������� ���������
        // Integer port - ���� �� ������� ����� ��������� 
        // String storeName - ��� ��������� 
        // ARRAY a_keys - ������ ������, �� ������� ����� ������� ������        
         public static Integer deleteRows(String host, Integer port, String storeName, ARRAY a_keys)  throws SQLException {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // ������� ���������� � ����������
            Storage storage = new Storage(host, port.intValue(), storeName);
            // �� ���� �������� ������ �����. ����� ������������� ��� 
            String[] keys = (String[])a_keys.getArray();            
            // ������ ������ ������ ������� ��������������� � �������� ����� ���������
            int result = 0;
            for (String key : keys ) {
                // ������� ������ �� ���������
                result += storage.deleteRow(Key.fromString(key));
            }
            //
            // ������� ���������� � ����������
            storage.close();
            //
            // ������ ���������
            return result;
        }
        

        //
        // ������� ���������. ������� ������ �� ������� ����� � ����� ����� (�� ����������� ������ major. ����� ������)
        // ���������: 
        // String host - �� �� ������� ���������
        // Integer port - ���� �� ������� ����� ��������� 
        // String storeName - ��� ��������� 
        // String key - ����� �����.  �� ��� ����� ������� ������� ������.        
         public static Integer clearStorage(String host, Integer port, String storeName, String key) {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // ������� ���������� � ����������
            Storage storage = new Storage(host, port.intValue(), storeName);
            // ������� ������
            int result = storage.clearStorage(Key.fromString(key));
            //
            // ������� ���������� � ����������
            storage.close();
            //
            // ������ ���������
            return result;
        }    
        

         // ----------------------------------------------  ������� �� ��������� ����� ----------------------------------------


        //
        // �������� �������� ����� ������ �� ������� ����� 
        // ���������: 
        // String host - �� �� ������� ���������
        // Integer port - ���� �� ������� ����� ��������� 
        // String storeName - ��� ��������� 
        // String key - ����� �����.  �� ��� ����� ������� ������� ������.        
         public static String getRowValue(String host, Integer port, String storeName, String key) throws UnsupportedEncodingException {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // ������� ���������� � ����������
            Storage storage = new Storage(host, port.intValue(), storeName);
            // ������� ������
            String result = storage.getRowValue(Key.fromString(key));
            //
            // ������� ���������� � ����������
            storage.close();
            //
            // ������ ���������
            return result;
        }  

         
         //
         // �������� ������ �� ���������. 
         // Major ����� ����� ������ ���� ������� ��������� �����������
         // ����� ��������� ����� ��������� ������. ����� ��� �������������� �������� �����. �� ���� ��������������� ��������� �����
         public static void getRows(String host, Integer port, String storeName, String key, ARRAY[] res_out) throws SQLException, UnsupportedEncodingException {
            // System.out.println("1connect to " +storeName + " on " + host + ":" + port );
            //
            // ������� ���������� � ����������
            Storage storage = new Storage(host, port.intValue(), storeName);
            // 
            // ������� ������ �� ���������
            ArrayList<StorageRow> rows = storage.getRowList(Key.fromString(key));
            
            int i = 0;
            Object[][] result = new Object[rows.size()][2];
            
            for (StorageRow row : rows ) {
                result[i][0] = row.getKey();
                result[i][1] = row.getValue();
                i++;
            } 
            
            //
            // ������ ������ �������� �� ���������
            Connection conn = new OracleDriver().defaultConnection();
            ArrayDescriptor descriptor = ArrayDescriptor.createDescriptor("NOSQLSTORAGEROWLIST", conn);
            res_out[0] = new ARRAY(descriptor, conn, result);
            //
            // ������� ���������� � ����������
            storage.close();
        }
        
         // ----------------------------------------------- ��������������� ������� ------------------------------------------------
         
         
         //
         // �������� ������ �� ��������� �� ����� major �����. ��� ������� ����� ���� ����� �� ��������.
         // ����� ��� �������������� �������� �����. �� ���� ��������������� ��������� �����
         public static Integer getRowsCount(String host, Integer port, String storeName, String key) throws SQLException {
            // System.out.println("connect to " +storeName + " on " + host + ":" + port );
            //
            // ������� ���������� � ����������
            Storage storage = new Storage(host, port.intValue(), storeName);
            // 
            // ������� ������ �� ���������
            int result = storage.getRowsCount(Key.fromString(key));
            //
            // ������� ���������� � ����������
            storage.close();
            //
            // ������ ���������
            return result;
        }   
        
    }
/
