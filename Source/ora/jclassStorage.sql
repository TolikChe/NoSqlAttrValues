DROP JAVA SOURCE "Storage";

CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "Storage" as 
    import oracle.kv.*;
    import  java.sql.*;
    import  java.lang.*;
    import  java.math.*;
    import java.io.*;
    import oracle.sql.*;
 
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
        //System.out.println("Storage Opened");
    }

    /**
     * Закрываем соединение с хранилищем
     */
    public void close(){
        store.close();
        //System.out.println("Storage Closed");
    }


    /**************************** Функции добавления строк в хранилище ***************************/

    /**
     * Добавление строки в Хранилище
     * @param key ключ
     * @param value значение
     */
    public void addRow(Key key, byte[] value){
        store.put(key, Value.createValue(value));
    }     


    /**
     * Добавление списка строк в Хранилище
     * @param storageRowArrayList список строк для добавления
     */
    public void addRowList(ArrayList<StorageRow> storageRowArrayList){
        for (StorageRow sr : storageRowArrayList) {
            this.addRow(Key.fromString(sr.getKey()), sr.getValue().getBytes());
        }
    }
    
    /**************************** Функции удаления строк из хранилища ******************************/
    
    /**
     * Удаление строки из Хранилища
     * @param key Полный ключ
     */
    public int deleteRow(Key key) {
        if (store.delete(key)) 
            return 1;
        return 0;
    }
    
    /**
     * Удаление списка строк из Хранилища
     * @param keyArrayListList Коллекция полных ключей
     */
    public void deleteRowList(ArrayList<Key> keyArrayListList) {
        for (Key k : keyArrayListList){
            this.deleteRow(k);
        }
    }    
    
    /**
     * Удаление списка строк из Хранилища по части ключа (полному major ключу)
     * @param key Ключ по которому будем получать значение. Ключ обязан иметь целый majorKey но может быть не полным
     */
    public int deleteRowList(Key key) throws NullPointerException
    {
        return store.multiDelete(key, null, Depth.PARENT_AND_DESCENDANTS );
    }
    
    /**
     * Удалим строки, которые подходят под нужный ключ или часть ключа. Будет работаь медленнее чем остальные но чистит больше так как работает и по части ключа.
     * @param key Целый ключ или часть ключа
     */
    public int clearStorage(Key key) {
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
        return result;
    }    
    
    /**************************** Функции получения строк из хранилища ******************************/

    /**
     * Получение одного значения из Хранилища по полному ключу
     * @param key Ключ по которому будем получать значение.  Ключ передается в форме /major/-/minor. Ключ передается полностью
     * @return Строка - значение для этого ключа
     */
    public String getRowValue(Key key) throws NullPointerException, UnsupportedEncodingException
    {
        ValueVersion valueVersion = store.get(key);
        Value value = valueVersion.getValue();
        return new String(value.getValue(), "UTF-8");
    }

    /**
     * Получение списка строк из Хранилища по части ключа (полному major ключу)
     * @param key Ключ по которому будем получать значение. Ключ обязан иметь целый majorKey
     * @return Значение в виде объекта типа ArrayList<StorageRow>
     */
    public ArrayList<StorageRow> getRowList(Key key) throws NullPointerException, UnsupportedEncodingException
    {
        // Сначала попробуем поискать строки как есил бы нам передали ключ с целой major частью ключа
        ArrayList<StorageRow> result = new ArrayList<StorageRow>();
        KeyValueVersion tmp;
        Iterator<KeyValueVersion> resultFormBase = store.multiGetIterator(Direction.FORWARD, 1, key, null, Depth.PARENT_AND_DESCENDANTS);
        while (resultFormBase.hasNext()) {
            tmp = resultFormBase.next();
            result.add(new StorageRow(tmp.getKey().toString(), new String(tmp.getValue().getValue(), "UTF-8")));
        }
        // Если нчиего не нашли и у ключа не задано минорной части то будем искать как будто передали не целую часть major ключа
        // Эта функция умеет искать по части major ключа
        if (result.size() == 0 && key.getMinorPath().size() == 0) {        
            resultFormBase = store.storeIterator(Direction.UNORDERED, 1, key, null, Depth.PARENT_AND_DESCENDANTS);
            while (resultFormBase.hasNext()) {
                tmp = resultFormBase.next();
                result.add(new StorageRow(tmp.getKey().toString(), new String(tmp.getValue().getValue(), "UTF-8")));
            }
        }
        // Вернем результат        
        return result;
    }


    /****************************** Вспомогательные функции ***********************************/


    /**
     * Получим Число строк которые подходят под нужный ключ или часть ключа
     * @param key Целый ключ или часть ключа
     * @return Количество строк подходящих под нужный ключ
     */
    public int getRowsCount (Key key){
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
/
