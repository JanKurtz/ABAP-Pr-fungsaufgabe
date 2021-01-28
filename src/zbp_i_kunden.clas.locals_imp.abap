CLASS lhc_Kunden DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS CalculateKundenNr FOR DETERMINE ON SAVE
      IMPORTING keys FOR Kunden~CalculateKundenNr.

ENDCLASS.

CLASS lhc_Kunden IMPLEMENTATION.

  METHOD CalculateKundenNr.

  READ ENTITIES OF ZI_Kunden IN LOCAL MODE
        ENTITY Kunden
          FIELDS ( kundenid )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_kunde).

    DELETE lt_kunde WHERE kundenid IS NOT INITIAL.
    CHECK lt_kunde IS NOT INITIAL.

    "Get max travelID
    SELECT SINGLE FROM zkunde_table FIELDS MAX( kundenid ) INTO @DATA(lv_max_kundenid).

    "update involved instances
    MODIFY ENTITIES OF ZI_Kunden IN LOCAL MODE
      ENTITY Kunden
        UPDATE FIELDS ( kundenid )
        WITH VALUE #( FOR ls_kunde IN lt_kunde INDEX INTO i (
                           %key      = ls_kunde-%key
                           kundenid  = lv_max_kundenid + i ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.

ENDCLASS.
