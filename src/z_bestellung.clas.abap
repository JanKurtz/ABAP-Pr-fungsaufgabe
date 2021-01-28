CLASS z_bestellung DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z_bestellung IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.

    DATA itab TYPE TABLE OF zbestell_table.

    itab = VALUE #(
        ( bestelluuid = '31D5290E594C1EDA93815057FD946624' bestellid = '1' kunid = '01D5290E594C1EDA93815057FD946625' bestelldatum = '20200216' abholdatum = '20200220' status = 'Offen' kommentar = 'ja' updatedatum = '20190613111041.2251330')
        ( bestelluuid = '41D5290E594C1EDA93815057FD946624' bestellid = '2' kunid = '01D5290E594C1EDA93815057FD946624' bestelldatum = '20000523' abholdatum = '20000526' status = 'Offen' kommentar = 'ok' updatedatum = '20200613111041.2251330')
         ).

    DELETE FROM zbestell_table.

    INSERT zbestell_table FROM TABLE @itab.

    out->write( |{ sy-dbcnt } order entries inserted successfully!| ).

    ENDMETHOD.
ENDCLASS.
