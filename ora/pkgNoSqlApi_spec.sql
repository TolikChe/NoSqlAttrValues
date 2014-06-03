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
   -------------------------------------------- ���������� ����� --------------------------------
    
  /* 
     04.03.2013 �������� �.
   * ���������:
       addRow
   * ��������:
       ���������� ����� ������ � ���������
   * ���������:
        p_host            IN  varchar2    ���� �� ������� ������� ������ NoSql
        p_port            IN  NUMBER     ���� ����� �� ������� ������� ������ NoSql
        p_storeName  IN  varchar2  ��� ��������� NoSql
        p_key             IN varchar2   ����, ������� ����� �������� � ��������� 
        p_value           IN varchar2   �������� ��� �����, ������� ����� �������� � ���������
   * ������������ ��������:
        ���
   * ����������:
        �������� ��� ����� ����� ��������� �� Java 
   * ����������:
        ���
   */    
    procedure addRow (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2, p_value in varchar2 );
    --
  /* 
     04.03.2013 �������� �.
   * ���������:
       addRows
   * ��������:
       ���������� ������� ����� � ���������
   * ���������:
        p_host            IN  varchar2                          ���� �� ������� ������� ������ NoSql
        p_port            IN  NUMBER                           ���� ����� �� ������� ������� ������ NoSql
        p_storeName  IN  varchar2                           ��� ��������� NoSql
        p_in_array      IN NOSQLSTORAGEROWLIST  ������ ������, ������� ����� �������� � ��������� 
   * ������������ ��������:
        ���
   * ����������:
        �������� ��� ����� ����� ��������� �� Java 
   * ����������:
        ���
   */    
    procedure addRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_in_array in NOSQLSTORAGEROWLIST);
    --
    ----------------------------------------------------------------------------------------------------------------------------------------
    ------------------------------------------------------- �������� ����� -------------------------------------------------------------
    --
  /* 
     04.03.2013 �������� �.
   * �������:
       deleteRow
   * ��������:
       �������� ����� ������ �� ���������
   * ���������:
        p_host            IN  varchar2       ���� �� ������� ������� ������ NoSql
        p_port            IN  NUMBER        ���� ����� �� ������� ������� ������ NoSql
        p_storeName  IN  varchar2       ��� ��������� NoSql
        p_key             IN varchar2        ���� �������, ������� ����� ������� �� ��������� 
   * ������������ ��������:
        ���� ������ ������� ������� �� ������������ 1. ���� ������ �� ������� ��� �� ������� �� 0.
   * ����������:
        �������� ��� ����� ����� ��������� �� Java
   * ����������:
        ���
   */         
    function deleteRow (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return number;
    --
  /* 
     04.03.2013 �������� �.
   * �������:
       deleteRows
   * ��������:
       �������� ����� �� ��������� �� �����.
   * ���������:
        p_host            IN  varchar2       ���� �� ������� ������� ������ NoSql
        p_port            IN  NUMBER        ���� ����� �� ������� ������� ������ NoSql
        p_storeName  IN  varchar2       ��� ��������� NoSql
        p_key             IN varchar2        ����� �����, �� ������� ����� ������� ��� ������ ������� �� ����. ��������� ������ ���� major �����.  
   * ������������ ��������:
        ����� ��������� �����
   * ����������:
        �������� ��� ����� ����� ��������� �� Java
   * ����������:
        ���
   */
    function deleteRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return number;
    --
  /* 
     04.03.2013 �������� �.
   * �������:
       deleteRows
   * ��������:
       �������� ������ ����� �� ���������.
   * ���������:
        p_host            IN  varchar2       ���� �� ������� ������� ������ NoSql
        p_port            IN  NUMBER        ���� ����� �� ������� ������� ������ NoSql
        p_storeName  IN  varchar2       ��� ��������� NoSql
        p_in_array      IN varchar_table ������ ������, ������� ����� ������� �� ���������  
   * ������������ ��������:
        ����� ��������� �����
   * ����������:
        �������� ��� ����� ����� ��������� �� Java
   * ����������:
        ���
   */
    function deleteRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_in_array in varchar_table) return number;
    

/* 
     04.03.2013 �������� �.
   * �������:
       clearStorage
   * ��������:
       �������� ����� �� ���������. ����� ������������ ����� ����, ����� ����� � ���� ���� ����� ������ ��� major
   * ���������:
        p_host            IN  varchar2       ���� �� ������� ������� ������ NoSql
        p_port            IN  NUMBER        ���� ����� �� ������� ������� ������ NoSql
        p_storeName  IN  varchar2       ��� ��������� NoSql
        p_key             IN varchar2        ����� �����, �� ������� ����� ������� ��� ������ ������� �� ����.
   * ������������ ��������:
        ����� ��������� �����
   * ����������:
        �������� ��� ����� ����� ��������� �� Java
   * ����������:
        ���
   */
    function clearStorage (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return number;    
    
    --
    ----------------------------------------------------------------------------------------------------------------------------------------------
    ---------------------------------------------------- ��������� ����� ---------------------------------------------------------------------
    --
  /* 
     04.03.2013 �������� �.
   * �������:
       getRowValue
   * ��������:
       ��������� �������� ����� ������ �� ��������� �� ������� �����
   * ���������:
        p_host            IN  varchar2       ���� �� ������� ������� ������ NoSql
        p_port            IN  NUMBER        ���� ����� �� ������� ������� ������ NoSql
        p_storeName  IN  varchar2       ��� ��������� NoSql
        p_key             IN varchar2        ������ ����.
   * ������������ ��������:
        �������� ������
   * ����������:
        �������� ��� ����� ����� ��������� �� Java
   * ����������:
        ���
   */  
    function getRowValue (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return varchar2;    
    --
  /* 
     04.03.2013 �������� �.
   * ���������:
       getRows
   * ��������:
       ��������� ������ ����� �� ���������.
   * ���������:
        p_host            IN  varchar2       ���� �� ������� ������� ������ NoSql
        p_port            IN  NUMBER        ���� ����� �� ������� ������� ������ NoSql
        p_storeName  IN  varchar2       ��� ��������� NoSql
        p_key             IN varchar2        ����� �����, �� ������� ����� �������� ��� ������ ������� �� ����. ��������� ������ ���� major �����. ����� ������� ���� ���������.
        p_out_array    OUT NOSQLSTORAGEROWLIST ������ �����, ������� ������� ��� ���������� ����  
   * ������������ ��������:
        ���
   * ����������:
        �������� ��� ����� ����� ��������� �� Java
   * ����������:
        ���
   */    
    procedure getRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2, p_out_array out NOSQLSTORAGEROWLIST);    
    --
  /* 
     04.03.2013 �������� �.
   * �������:
       getRows
   * ��������:
       ��������� ����� �� ��������� ����� ���������� sql �������.
   * ���������:
        p_host            IN  varchar2       ���� �� ������� ������� ������ NoSql
        p_port            IN  NUMBER        ���� ����� �� ������� ������� ������ NoSql
        p_storeName  IN  varchar2       ��� ��������� NoSql
        p_key             IN varchar2        ����� �����, �� ������� ����� �������� ��� ������ ������� �� ����. ��������� ������ ���� major �����. ����� ������� ���� ���������.
   * ������������ ��������:
        ������ ����������� ��������� ������� cms_attr_value
   * ����������:
        �������� ��� ����� ����� ��������� �� Java
   * ����������:
        ���
   */  
    function getRows (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return t_cms_attr_value_list pipelined;
   
    -----------------------------------------------------------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------- ��������������� ������� ----------------------------------------------------
    --
  /* 
     04.03.2013 �������� �.
   * �������:
       getRowsCount
   * ��������:
       ��������� ����� ����� �� ���������� ����� 
   * ���������:
        p_host            IN  varchar2       ���� �� ������� ������� ������ NoSql
        p_port            IN  NUMBER        ���� ����� �� ������� ������� ������ NoSql
        p_storeName  IN  varchar2       ��� ��������� NoSql
        p_key             IN varchar2        ����� �����, �� ������� ����� �������� ����� ����� ������� �� ����. ��������� ������ ���� major �����. ����� ������� ���� ���������.
   * ������������ ��������:
         ����� �����, ���������� �� �����
   * ����������:
        �������� ��� ����� ����� ��������� �� Java
   * ����������:
        ���
   */
    function getRowsCount (p_host in varchar2, p_port in number , p_storeName in varchar2, p_key in varchar2) return number;
    
end;
/