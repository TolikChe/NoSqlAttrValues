import oracle.kv.Key;
import oracle.kv.Value;

/**
 * Created by Anatoly.Cherkasov on 06.02.14.
 * Класс для удобного хранения пар ключ значение. Позволяет скрыть реализацию key - value из NoSql
 */
public class StorageRow {
    private Key key;
    private byte[] value;

    StorageRow(Key key, byte[] value){
        this.key = key;
        this.value = value;
    }


    public byte[] getValue() {
        return value;
    }

    public Key getKey() {
        return key;
    }
}
