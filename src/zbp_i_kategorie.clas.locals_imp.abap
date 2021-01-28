CLASS lhc_Abfallkategorie DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateAbfallkategorieID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Abfallkategorie~calculateAbfallkategorieID.

ENDCLASS.

CLASS lhc_Abfallkategorie IMPLEMENTATION.

  METHOD calculateAbfallkategorieID.
  READ ENTITIES OF ZI_Kategorie IN LOCAL MODE
        ENTITY Abfallkategorie
          FIELDS ( AbfallkategorieID )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_kategorie).

    DELETE lt_kategorie WHERE AbfallkategorieID IS NOT INITIAL.
    CHECK lt_kategorie IS NOT INITIAL.

    "Get max travelID
    SELECT SINGLE FROM zkategorie_table FIELDS MAX( kategorieid ) INTO @DATA(lv_max_kategorieid).

    "update involved instances
    MODIFY ENTITIES OF ZI_Kategorie IN LOCAL MODE
      ENTITY Abfallkategorie
        UPDATE FIELDS ( AbfallkategorieID )
        WITH VALUE #( FOR ls_kategorie IN lt_kategorie INDEX INTO i (
                           %key      = ls_kategorie-%key
                           AbfallkategorieID  = lv_max_kategorieid + i ) )
    REPORTED DATA(lt_reported).
  ENDMETHOD.

ENDCLASS.
