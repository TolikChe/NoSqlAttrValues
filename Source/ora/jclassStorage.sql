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
 * ����� ��������� ��� �������������� � NoSql
 */
public class Storage {


    private KVStore store;

    private String storeHost;
    private int storePort;
    private String storeName;

    /**
     * ����������� ��������� ������� � ����������
     * @param storeHost ���� �� ������� ����������� ���������
     * @param storePort ���� � �������� ���������� ���������
     * @param storeName ��� ���������
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
     * ��������� ���������� � ����������
     */
    public void close(){
        store.close();
        //System.out.println("Storage Closed");
    }


    /**************************** ������� ���������� ����� � ��������� ***************************/

    /**
     * ���������� ������ � ���������
     * @param key ����
     * @param value ��������
     */
    public void addRow(Key key, byte[] value){
        store.put(key, Value.createValue(value));
    }     


    /**
     * ���������� ������ ����� � ���������
     * @param storageRowArrayList ������ ����� ��� ����������
     */
    public void addRowList(ArrayList<StorageRow> storageRowArrayList){
        for (StorageRow sr : storageRowArrayList) {
            this.addRow(Key.fromString(sr.getKey()), sr.getValue().getBytes());
        }
    }
    
    /**************************** ������� �������� ����� �� ��������� ******************************/
    
    /**
     * �������� ������ �� ���������
     * @param key ������ ����
     */
    public int deleteRow(Key key) {
        if (store.delete(key)) 
            return 1;
        return 0;
    }
    
    /**
     * �������� ������ ����� �� ���������
     * @param keyArrayListList ��������� ������ ������
     */
    public void deleteRowList(ArrayList<Key> keyArrayListList) {
        for (Key k : keyArrayListList){
            this.deleteRow(k);
        }
    }    
    
    /**
     * �������� ������ ����� �� ��������� �� ����� ����� (������� major �����)
     * @param key ���� �� �������� ����� �������� ��������. ���� ������ ����� ����� majorKey �� ����� ���� �� ������
     */
    public int deleteRowList(Key key) throws NullPointerException
    {
        return store.multiDelete(key, null, Depth.PARENT_AND_DESCENDANTS );
    }
    
    /**
     * ������ ������, ������� �������� ��� ������ ���� ��� ����� �����. ����� ������� ��������� ��� ��������� �� ������ ������ ��� ��� �������� � �� ����� �����.
     * @param key ����� ���� ��� ����� �����
     */
    public int clearStorage(Key key) {
        int result = 0;
        // ������� �������� ��� ������ �� ���������
        Iterator<Key> keys;
        // ��� ������� �� �������� ���� ����� major-���� ���������
        // ������� ������� ��, ���� ��� ������ �� ������� �� ��������� ������� ������ ������� ������� �������� ������ �� ������� �����
        keys = store.storeKeysIterator(Direction.UNORDERED, 0, key, null, Depth.PARENT_AND_DESCENDANTS);
        // �������� �������� � ��������� ����������
        while (keys.hasNext()){
            this.deleteRow(keys.next());
            result++;
        }
        // ���� ���������� ������� ������ �� ����� �� ��������� �������� ���. ��� �������� ������ ���� ���� ������� ���������.
        if (result == 0 ) {
            keys = store.multiGetKeysIterator(Direction.FORWARD, 0, key, null, Depth.PARENT_AND_DESCENDANTS);
            // �������� �������� � ��������� ����������
            while (keys.hasNext()){
                this.deleteRow(keys.next());
                result++;
            }
        }
        return result;
    }    
    
    /**************************** ������� ��������� ����� �� ��������� ******************************/

    /**
     * ��������� ������ �������� �� ��������� �� ������� �����
     * @param key ���� �� �������� ����� �������� ��������.  ���� ���������� � ����� /major/-/minor. ���� ���������� ���������
     * @return ������ - �������� ��� ����� �����
     */
    public String getRowValue(Key key) throws NullPointerException, UnsupportedEncodingException
    {
        ValueVersion valueVersion = store.get(key);
        Value value = valueVersion.getValue();
        return new String(value.getValue(), "UTF-8");
    }

    /**
     * ��������� ������ ����� �� ��������� �� ����� ����� (������� major �����)
     * @param key ���� �� �������� ����� �������� ��������. ���� ������ ����� ����� majorKey
     * @return �������� � ���� ������� ���� ArrayList<StorageRow>
     */
    public ArrayList<StorageRow> getRowList(Key key) throws NullPointerException, UnsupportedEncodingException
    {
        // ������� ��������� �������� ������ ��� ���� �� ��� �������� ���� � ����� major ������ �����
        ArrayList<StorageRow> result = new ArrayList<StorageRow>();
        KeyValueVersion tmp;
        Iterator<KeyValueVersion> resultFormBase = store.multiGetIterator(Direction.FORWARD, 1, key, null, Depth.PARENT_AND_DESCENDANTS);
        while (resultFormBase.hasNext()) {
            tmp = resultFormBase.next();
            result.add(new StorageRow(tmp.getKey().toString(), new String(tmp.getValue().getValue(), "UTF-8")));
        }
        // ���� ������ �� ����� � � ����� �� ������ �������� ����� �� ����� ������ ��� ����� �������� �� ����� ����� major �����
        // ��� ������� ����� ������ �� ����� major �����
        if (result.size() == 0 && key.getMinorPath().size() == 0) {        
            resultFormBase = store.storeIterator(Direction.UNORDERED, 1, key, null, Depth.PARENT_AND_DESCENDANTS);
            while (resultFormBase.hasNext()) {
                tmp = resultFormBase.next();
                result.add(new StorageRow(tmp.getKey().toString(), new String(tmp.getValue().getValue(), "UTF-8")));
            }
        }
        // ������ ���������        
        return result;
    }


    /****************************** ��������������� ������� ***********************************/


    /**
     * ������� ����� ����� ������� �������� ��� ������ ���� ��� ����� �����
     * @param key ����� ���� ��� ����� �����
     * @return ���������� ����� ���������� ��� ������ ����
     */
    public int getRowsCount (Key key){
        int result = 0;
        // ������� �������� ��� ������ �� ���������
        Iterator<Key> keys;
        // ��� ������� �� �������� ���� ����� major-���� ���������
        // ������� ������� ��, ���� ��� ������ �� ������� �� ��������� ������� ������ ������� ������� �������� ������ �� ������� �����
        keys = store.storeKeysIterator(Direction.UNORDERED, 0, key, null, Depth.PARENT_AND_DESCENDANTS);
        // �������� �������� � ��������� ����������
        while (keys.hasNext()){
            keys.next();
            result++;
        }
        // ���� ���������� ������� ������ �� ����� �� ��������� �������� ���. ��� �������� ������ ���� ���� ������� ���������.
        if (result == 0 ) {
            keys = store.multiGetKeysIterator(Direction.FORWARD, 0, key, null, Depth.PARENT_AND_DESCENDANTS);
            // �������� �������� � ��������� ����������
            while (keys.hasNext()){
                keys.next();
                result++;
            }
        }
        // ������ ���������
        return result;
    }




    /**********************************************************************************************/

    /**
     * ���� ���� ������� � ������� ��� ��������� �����
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
