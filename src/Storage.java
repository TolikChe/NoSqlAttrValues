import oracle.kv.*;

import java.io.UnsupportedEncodingException;
import java.util.*;

/**
 * Created by Anatoly.Cherkasov on 14.02.14.
 * Класс харнилище для взаимодействия с NoSql
 */
public class Storage {


    private KVStore store;

    private String storeHost;
    private int storePort;
    private String storeName;

    /**
     * Конструктор открывает соедние с хранилищем
     * @param storeHost Хост на котором расположено хранилище
     * @param storePort Порт к которому прицеплено хранилище
     * @param storeName Имя хранилища
     */
    Storage(String storeHost, int storePort, String storeName){
        this.storeHost = storeHost;
        this.storePort = storePort;
        this.storeName = storeName;

        KVStoreConfig kconfig = new KVStoreConfig(storeName, storeHost + ":" + storePort);
        store = KVStoreFactory.getStore(kconfig);
        System.out.println("Storage Opened");
    }

    /**
     * Закрываем соединение с хранилищем
     */
    public void close(){
        store.close();
        System.out.println("Storage Closed");
    }



    /**************************** Функции для работы с одиночными строками ******************************/

    /**
     * Добавление строки в Хранилище
     * @param key ключ
     * @param value значение
     */
    public void addRow(Key key, byte[] value){
        store.put(key, Value.createValue(value));
        System.out.println("Row added");
    }

    /**
     * Получение одного значения из Хранилища по полному ключу
     * @param key Ключ по которому будем получать значение.  Ключ передается в форме /major/-/minor. Ключ передается полностью
     * @return Значение в виде массива байт для этого ключа
     */
    public byte[] getRowValue(Key key) throws NullPointerException
    {
        byte[] val = null;
        ValueVersion valueVersion = store.get(key);
        Value value = valueVersion.getValue();
        val = value.getValue();
        return val;
    }

    /**
     * Получение одного значения из Хранилища по полному ключу
     * @param key Ключ по которому будем получать значение.  Ключ передается в форме /major/-/minor. Ключ передается полностью
     * @return Значение в виде объекта типа StorageRow
     */
    public StorageRow getRow(Key key) throws NullPointerException, UnsupportedEncodingException {
        ValueVersion valueVersion = store.get(key);
        Value value = valueVersion.getValue();
        return new StorageRow(key.toString(), new String(value.getValue(), "UTF-8"));
    }

    /**
     * Удаление строки из Хранилища
     * @param key ключ
     */
    public void deleteRow(Key key) {
        store.delete(key);
        System.out.println("Row deleted");
    }


    /**************************** Функции для работы со списком строк **************************************/


    /**
     * Добавление списка строк в Хранилище
     * @param storageRowArrayList список строк для добавления
     */
    public void addRowList(ArrayList<StorageRow> storageRowArrayList){
        for (StorageRow sr : storageRowArrayList) {
            this.addRow(Key.fromString(sr.getKey()), sr.getValue().getBytes());
        }
        System.out.println(storageRowArrayList.size() + " rows added");
    }

    /**
     * Удаление строки из Хранилища
     * @param keyArrayListList Коллекция ключей
     */
    public void deleteRowList(ArrayList<Key> keyArrayListList) {
        for (Key k : keyArrayListList){
            this.deleteRow(k);
        }
        System.out.println(keyArrayListList.size() + " rows deleted");
    }

    /********************************** Функции для работы с частью ключа *********************************/


    /**
     * Получение списка строк из Хранилища по части ключа (полному major ключу)
     * @param key Ключ по которому будем получать значение. Ключ обязан иметь целый majorKey
     * @return Значение в виде объекта типа ArrayList<StorageRow>
     */
    public ArrayList<StorageRow> getRowList(Key key) throws NullPointerException, UnsupportedEncodingException
    {

        System.out.println(key.getMinorPath().toString() + " ***  " + key.getMinorPath().size() );
        // Сначала попробуем поискать строки как есил бы нам передали ключ с целой major частью ключа
        ArrayList<StorageRow> result = new ArrayList<StorageRow>();
        KeyValueVersion tmp;
        Iterator<KeyValueVersion> resultFormBase = store.multiGetIterator(Direction.FORWARD, 1, key, null, Depth.PARENT_AND_DESCENDANTS);
        while (resultFormBase.hasNext()) {
            tmp = resultFormBase.next();
            result.add(new StorageRow(tmp.getKey().toString(), new String(tmp.getValue().getValue(), "UTF-8")));
        }

        System.out.printf( " + "+ result.size() );

        // Если нчиего не нашли то будем искать как будто передали не целую часть major ключа
        if ( result.size() == 0 && key.getMinorPath().size() == 0 ) {
            resultFormBase = store.storeIterator(Direction.UNORDERED, 1, key, null, Depth.PARENT_AND_DESCENDANTS);
            while (resultFormBase.hasNext()) {
                tmp = resultFormBase.next();
                result.add(new StorageRow(tmp.getKey().toString(), new String(tmp.getValue().getValue(), "UTF-8")));
            }
        }
        // Вернем результат
        return result;
    }

    /**
     * Удаление списка строк из Хранилища по части ключа (полному major ключу)
     * @param key Ключ по которому будем получать значение. Клю обязан иметь целый majorKey
     */
    public int deleteRowList(Key key) throws NullPointerException
    {
        return store.multiDelete(key, null, Depth.PARENT_AND_DESCENDANTS );
    }


    /***********************************************************************************************/


    /**
     * Получим Числострок которые подходят под нужный ключ или часть ключа
     * @param key Целый ключ или часть ключа
     * @return Количество строк подходящих под нужный ключ
     */
    public int getRowCount (Key key){
        int result = 0;
        // Получим итератор для ключей по заданному
        Iterator<Key> keys;
        // Эта функция не работает если задан major-ключ полностью
        // Сначала вызовем ее, если она ничего не вернула то попробуем вызвать другой вариант который работает только по полному ключу
        keys = store.storeKeysIterator(Direction.UNORDERED, 0, key, null, Depth.PARENT_AND_DESCENDANTS);
        // Пробежим итератор и посчитаем количество
        while (keys.hasNext()){
            keys.next();
            result++;
        }
        // Если предыдущая функция ничего не нашла то попробуем вызывать эту. Она работает только если ключ передан полностью.
        if (result == 0 ) {
            keys = store.multiGetKeysIterator(Direction.FORWARD, 0, key, null, Depth.PARENT_AND_DESCENDANTS);
            // Пробежим итератор и посчитаем количество
            while (keys.hasNext()){
                keys.next();
                result++;
            }
        }
        // Вернем результат
        return result;
    }


    public void clearStorage(Key key) {
        int result = 0;
        // Получим итератор для ключей по заданному
        Iterator<Key> keys;
        // Эта функция не работает если задан major-ключ полностью
        // Сначала вызовем ее, если она ничего не вернула то попробуем вызвать другой вариант который работает только по полному ключу
        keys = store.storeKeysIterator(Direction.UNORDERED, 0, key, null, Depth.PARENT_AND_DESCENDANTS);
        // Пробежим итератор и посчитаем количество
        while (keys.hasNext()){
            this.deleteRow(keys.next());
            result++;
        }
        // Если предыдущая функция ничего не нашла то попробуем вызывать эту. Она работает только если ключ передан полностью.
        if (result == 0 ) {
            keys = store.multiGetKeysIterator(Direction.FORWARD, 0, key, null, Depth.PARENT_AND_DESCENDANTS);
            // Пробежим итератор и посчитаем количество
            while (keys.hasNext()){
                this.deleteRow(keys.next());
                result++;
            }
        }
    }


    /**********************************************************************************************/

    /**
     * Ниже идут геттеры и сеттеры для приватных полей
     */
    public String getStoreHost() {
        return storeHost;
    }

    public int getStorePort() {
        return storePort;
    }

    public String getStoreName() {
        return storeName;
    }

}
