import oracle.kv.Key;
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
