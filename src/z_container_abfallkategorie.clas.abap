CLASS z_container_abfallkategorie DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z_container_abfallkategorie IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.

    DATA itab TYPE TABLE OF zkategorie_table.

    itab = VALUE #(
        ( kategorieuuid = '11D5290E594C1EDA93815057FD946624' kategorieid = '1' name = 'Mineralische Bauabfälle' preis = '100' waehrung = 'EUR' )
        ( kategorieuuid = '21D5290E594C1EDA93815057FD946624' kategorieid = '2' name = 'Gemischte Bauabfälle' preis = '90' waehrung = 'EUR' )
        ( kategorieuuid = '31D5290E594C1EDA93815057FD946624' kategorieid = '3' name = 'Holz' preis = '30' waehrung = 'EUR' )
        ( kategorieuuid = '41D5290E594C1EDA93815057FD946624' kategorieid = '4' name = 'Metall' preis = '50' waehrung = 'EUR' )
        ( kategorieuuid = '51D5290E594C1EDA93815057FD946624' kategorieid = '5' name = 'Schrott' preis = '40' waehrung = 'EUR' )
        ( kategorieuuid = '61D5290E594C1EDA93815057FD946624' kategorieid = '6' name = 'kunststoffhaltige Bauabfälle' preis = '80' waehrung = 'EUR' )
        ( kategorieuuid = '71D5290E594C1EDA93815057FD946624' kategorieid = '7' name = 'Erde' preis = '20' waehrung = 'EUR' )
        ( kategorieuuid = '81D5290E594C1EDA93815057FD946624' kategorieid = '8' name = 'Boden' preis = '10' waehrung = 'EUR' )
         ).

    DELETE FROM zkategorie_table.

    INSERT zkategorie_table FROM TABLE @itab.

    out->write( |{ sy-dbcnt } category entries inserted successfully!| ).

    ENDMETHOD.
ENDCLASS.
