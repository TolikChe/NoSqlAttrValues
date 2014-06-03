/* Formatted on 02/06/2014 11:47:35 (QP5 v5.252.13127.32847) */
DROP JAVA SOURCE "StorageRow";

CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "StorageRow"
   AS 
   
/**
 * Created by Anatoly.Cherkasov on 06.02.14.
 * Класс для удобного хранения пар ключ значение. Позволяет скрыть реализацию key - value из NoSql
 */
public class StorageRow {
    private String key;
    private String value;

    StorageRow(String key, String value){
        this.key = key;
        this.value = value;
    }


    public String getValue() {
        return value;
    }

    public String getKey() {
        return key;
    }
}
