CLASS z_container_kunden DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z_container_kunden IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.

    DATA itab TYPE TABLE OF zkunde_table.

    itab = VALUE #(
        ( kundenuuid = '01D5290E594C1EDA93815057FD946624' kundenid = '1' vorname = 'Ingo' nachname = 'Zamperoni' plz = '54321' ort = 'Testort' strasse = 'Goethestraße' hausnummer = '20' firma = 'Ingo & Söhne' ansprechpartner = 'Richard Zamperoni' )
        ( kundenuuid = '01D5290E594C1EDA93815057FD946625' kundenid = '2' vorname = 'Rainer' nachname = 'Müller' plz = '12345' ort = 'Testcity' strasse = 'Schillerstraße' hausnummer = '30' firma = '' ansprechpartner = '' )
        ( kundenuuid = '01D5290E594C1EDA93815057FD946626' kundenid = '3' vorname = 'Jürgen' nachname = 'Maier' plz = '72189' ort = 'Vöhringen' strasse = 'Panoramastraße' hausnummer = '7' firma = 'Testfirma' ansprechpartner = 'Marc Richter' )
        ( kundenuuid = '01D5290E594C1EDA93815057FD946627' kundenid = '4' vorname = 'Stefan' nachname = 'Bauer' plz = '72172' ort = 'Sulz' strasse = 'Hauptstraße' hausnummer = '16' firma = 'Testcompany' ansprechpartner = 'Andreas Zimmermann' )
        ( kundenuuid = '01D5290E594C1EDA93815057FD946628' kundenid = '5' vorname = 'Patrick' nachname = 'Rauch' plz = '78628' ort = 'Rottweil' strasse = 'Königsstraße' hausnummer = '32' firma = '' ansprechpartner = '' )
         ).

    DELETE FROM zkunde_table.

    INSERT zkunde_table FROM TABLE @itab.

    out->write( |{ sy-dbcnt } customer entries inserted successfully!| ).

    ENDMETHOD.
ENDCLASS.
