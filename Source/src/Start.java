import oracle.kv.Key;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;

/**
 * Created by Anatoly.Cherkasov on 06.02.14.
 *
 * В этой версии значение не хранится в ключе. Оно может быть очень большим и это послеет снидение производительности
 * Поэтому значение хранится в части Value
 * Эта версия имеет слудующую структуру ключа
 * /cms_attr_value/etyp_etyp_id/entity_id/~/adat_adat_id/oper_id
 * Значение хранится НЕ в ключе !!!
 *
 */

public class Start {


    public static void main(String[] args) throws UnsupportedEncodingException {

        /**
         * Координаты для связи с хранилищем
         */
        // String storeHost = "localhost";
        String storeHost = "192.168.56.102";
        int storePort = 5000;
        String storeName = "kvstore" ;

        //
        // Откроем соединение с хранилищем
        Storage kv = new Storage(storeHost, storePort, storeName);


        // Вот так раскрывается ключ
        //---------------------------------/cms_attr_value/etyp_etyp_id/entity_id/~/adat_adat_id/oper_id

        // Простые операции с одиночными ключами. Добавить. Получить. Удалить.
/*
        {

            System.out.println("");
            System.out.println("Test 1. Add single attr.");
            kv.addRow(Key.fromString("/cms_attr_value/12/101/-/150/some_oper_id_123"), "str_txt".getBytes());
            kv.addRow(Key.fromString("/cms_attr_value/12/102/-/150/some_oper_id_123"), "test_test".getBytes());
            //
            System.out.println("Test 2. Get single attr.");
            System.out.println( new String(kv.getRowValue(Key.fromString("/cms_attr_value/12/101/-/150/some_oper_id_123")), "UTF-8"));
            System.out.println( new String(kv.getRowValue(Key.fromString("/cms_attr_value/12/102/-/150/some_oper_id_123")), "UTF-8"));
            //
            //System.out.println("Test 3. Delete single attr.");
            //kv.deleteRow(Key.fromString("/cms_attr_value/12/101/-/150/some_oper_id_123"));
            //kv.deleteRow(Key.fromString("/cms_attr_value/12/102/-/150/some_oper_id_123"));
            //
            // System.out.println( new String(kv.getRowValue(Key.fromString("/cms_attr_value/12/101/-/150/some_oper_id_123")), "UTF-8"));
            // System.out.println( new String(kv.getRowValue(Key.fromString("/cms_attr_value/12/102/-/150/some_oper_id_123")), "UTF-8"));
            //

            System.out.println("Test 4. Add multy rows.");
            Random y = new Random();
            for (int x = 90; x < 110; x++) {
                while (y.nextBoolean())
                    System.out.println("/cms_attr_value/12/" + x + "/-/"+ y.nextInt() +"/some_oper_id_123" +":" + ("str_txt_" + x).getBytes());
                    kv.addRow(Key.fromString("/cms_attr_value/12/" + x + "/-/"+ y.nextInt() +"/some_oper_id_123"), ("str_txt_" + x).getBytes());
            }

            System.out.println("Test 5. Get row list by key.");
            // получение ключа по полному ключу (бредовый вариант)
            System.out.println("Try 1.");
            ArrayList<StorageRow> rows = kv.getRowList(Key.fromString("/cms_attr_value/12/101"));
            System.out.println(rows.size());
            for (StorageRow r : rows) {
                System.out.println(r.getKey().toString() + " : " + r.getValue());
            }
            System.out.println("Try 2.");
            ArrayList<StorageRow> rows2 = kv.getRowList(Key.fromString("/cms_attr_value/12/101/-/150"));
            System.out.println(rows2.size());
            for (StorageRow r : rows2) {
                System.out.println(r.getKey().toString() + " : " + r.getValue());
            }
            System.out.println("Try 3.");
            ArrayList<StorageRow> rows3 = kv.getRowList(Key.fromString("/cms_attr_value/12/101/-/150/some_oper_id_123"));
            System.out.println(rows3.size());
            for (StorageRow r : rows3) {
                System.out.println(r.getKey().toString() + " : " + r.getValue());
            }



            StorageRow[] rows = new StorageRow[3];

            rows[0] = new StorageRow(Key.fromString("/cms_attr_value/12/101/-/150/some_oper_id_123"), "str_txt2".getBytes());
            rows[1] = new StorageRow(Key.fromString("/cms_attr_value/12/101/-/150/some_oper_id_123"), "str_txt2".getBytes());
            rows[2] = new StorageRow(Key.fromString("/cms_attr_value/12/101/-/150/some_oper_id_123"), "str_txt2".getBytes());

            kv.addRowList(new ArrayList(Arrays.asList(rows)));
           }



            System.out.println("Try 4.");
            ArrayList<StorageRow> rows4 = kv.getRowList(Key.fromString("/cms_attr_value/12/100/-/150"));
            System.out.println(rows4.size());
            for (StorageRow r : rows4) {
                System.out.println(r.getKey().toString() + " : " + r.getValue());
            }

*/



            System.out.println(kv.getRowCount(Key.fromString("/cms_attr_value")));

            /*
            kv.clearStorage(Key.fromString("/cms_attr_value"));

            System.out.println(kv.getRowCount(Key.fromString("/cms_attr_value")));
            */

        kv.close();
    }
}
