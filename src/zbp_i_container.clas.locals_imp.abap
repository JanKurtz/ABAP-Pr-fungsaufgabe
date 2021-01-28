CLASS lhc_Container DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

  CONSTANTS:
      BEGIN OF verfueg,
        ja     TYPE c LENGTH 2  VALUE 'Ja', " verfügbar
        nein TYPE c LENGTH 4  VALUE 'Nein', " nicht verfügbar
      END OF verfueg.

    METHODS CalculateContainerNr FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Container~CalculateContainerNr.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Container RESULT result.

    METHODS nichtverfuegbar FOR MODIFY
      IMPORTING keys FOR ACTION Container~nichtverfuegbar RESULT result.

    METHODS verfuegbar FOR MODIFY
      IMPORTING keys FOR ACTION Container~verfuegbar RESULT result.

    METHODS setVerfuegbarkeit FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Container~setVerfuegbarkeit.

    METHODS validateBestellung FOR VALIDATE ON SAVE
      IMPORTING keys FOR Container~validateBestellung.

ENDCLASS.

CLASS lhc_Container IMPLEMENTATION.

  METHOD CalculateContainerNr.

  READ ENTITIES OF ZI_Kategorie IN LOCAL MODE
        ENTITY Container
          FIELDS ( containerid )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_container).

    DELETE lt_container WHERE containerid IS NOT INITIAL.
    CHECK lt_container IS NOT INITIAL.

    "Get max travelID
    SELECT SINGLE FROM zcontainer_table FIELDS MAX( containerid ) INTO @DATA(lv_max_containerid).

    "update involved instances
    MODIFY ENTITIES OF ZI_Kategorie IN LOCAL MODE
      ENTITY Container
        UPDATE FIELDS ( containerid )
        WITH VALUE #( FOR ls_container IN lt_container INDEX INTO i (
                           %key      = ls_container-%key
                           containerid  = lv_max_containerid + i ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD get_instance_features.
  " Read the travel status of the existing travels
    READ ENTITIES OF zi_kategorie IN LOCAL MODE
      ENTITY Container
        FIELDS ( Verfuegbarkeit ) WITH CORRESPONDING #( keys )
      RESULT DATA(containers)
      FAILED failed.

    result =
      VALUE #(
        FOR contain IN containers
          LET is_accepted =   COND #( WHEN contain-Verfuegbarkeit = verfueg-ja
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              is_rejected =   COND #( WHEN contain-Verfuegbarkeit = verfueg-nein
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky                 = contain-%tky
              %action-verfuegbar = is_accepted
              %action-nichtverfuegbar = is_rejected
             ) ).
  ENDMETHOD.

  METHOD nichtverfuegbar.
   " Set the new overall status
    MODIFY ENTITIES OF zi_kategorie IN LOCAL MODE
      ENTITY Container
         UPDATE
           FIELDS ( Verfuegbarkeit )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Verfuegbarkeit = verfueg-nein ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zi_kategorie IN LOCAL MODE
      ENTITY Container
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(containers).

    result = VALUE #( FOR contain IN containers
                        ( %tky   = contain-%tky
                          %param = contain ) ).
  ENDMETHOD.

  METHOD verfuegbar.
  " Set the new overall status
    MODIFY ENTITIES OF zi_kategorie IN LOCAL MODE
      ENTITY Container
         UPDATE
           FIELDS ( Verfuegbarkeit )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Verfuegbarkeit = verfueg-ja ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zi_kategorie IN LOCAL MODE
      ENTITY Container
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(containers).

    result = VALUE #( FOR contain IN containers
                        ( %tky   = contain-%tky
                          %param = contain ) ).
  ENDMETHOD.

  METHOD setVerfuegbarkeit.
  " Read relevant travel instance data
    READ ENTITIES OF ZI_Kategorie IN LOCAL MODE
      ENTITY Container
        FIELDS ( Verfuegbarkeit ) WITH CORRESPONDING #( keys )
      RESULT DATA(containers).

    " Remove all travel instance data with defined status
    DELETE containers WHERE Verfuegbarkeit IS NOT INITIAL.
    CHECK containers IS NOT INITIAL.

    " Set default travel status
    MODIFY ENTITIES OF ZI_Kategorie IN LOCAL MODE
    ENTITY Container
      UPDATE
        FIELDS ( Verfuegbarkeit )
        WITH VALUE #( FOR contain IN containers
                      ( %tky         = contain-%tky
                        Verfuegbarkeit = verfueg-ja ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validateBestellung.
  " Read relevant travel instance data
    READ ENTITIES OF zi_kategorie IN LOCAL MODE
      ENTITY Container
        FIELDS ( BestellID ) WITH CORRESPONDING #( keys )
      RESULT DATA(containers).

    DATA bestellungen TYPE SORTED TABLE OF zi_bestellung WITH UNIQUE KEY bestellid.

    " Optimization of DB select: extract distinct non-initial customer IDs
    bestellungen = CORRESPONDING #( containers DISCARDING DUPLICATES MAPPING bestellid = BestellID EXCEPT * ).
    DELETE bestellungen WHERE bestellid IS INITIAL.
    IF bestellungen IS NOT INITIAL.
      " Check if customer ID exist
      SELECT FROM zi_bestellung FIELDS bestellid
        FOR ALL ENTRIES IN @bestellungen
        WHERE bestellid = @bestellungen-bestellid
        INTO TABLE @DATA(bestellungen_db).
    ENDIF.

    " Raise msg for non existing and initial customerID
    LOOP AT containers INTO DATA(container).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = container-%tky
                       %state_area = 'VALIDATE_Bestellung' )
        TO reported-container.

      IF container-BestellID IS INITIAL OR NOT line_exists( bestellungen_db[ bestellid = container-BestellID ] ).
        APPEND VALUE #(  %tky = container-%tky ) TO failed-container.

        APPEND VALUE #(  %tky        = container-%tky
                         %state_area = 'VALIDATE_Bestellung'
                         %msg        = NEW zcm_rap(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_rap=>bestellid_unbekannt
                                           bestellid = container-BestellID )
                         %element-BestellID = if_abap_behv=>mk-on )
          TO reported-container.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
