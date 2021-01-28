CLASS z_container DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z_container IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.

    DATA itab TYPE TABLE OF zcontainer_table.

    itab = VALUE #(
        ( containeruuid = '21D5290E594C1EDA93815057FD946624' containerid = '1' ak_id = '11D5290E594C1EDA93815057FD946624' b_id = '31D5290E594C1EDA93815057FD946624' verfuegbarkeit = 'Nein' gewicht = '0' )
        ( containeruuid = '31D5290E594C1EDA93815057FD946624' containerid = '2' ak_id = '11D5290E594C1EDA93815057FD946624' b_id = '31D5290E594C1EDA93815057FD946624' verfuegbarkeit = 'Nein' gewicht = '0' )
         ).

    DELETE FROM zcontainer_table.

    INSERT zcontainer_table FROM TABLE @itab.

    out->write( |{ sy-dbcnt } container entries inserted successfully!| ).

    ENDMETHOD.
ENDCLASS.
