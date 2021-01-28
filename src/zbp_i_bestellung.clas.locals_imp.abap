CLASS lhc_Bestellung DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

  CONSTANTS:
      BEGIN OF bestellung_status,
        offen     TYPE c LENGTH 128  VALUE 'Offen',
        ausgeliefert TYPE c LENGTH 128  VALUE 'Ausgeliefert',
        abgeschlossen     TYPE c LENGTH 128  VALUE 'Abgeschlossen',
        abgebrochen     TYPE c LENGTH 128  VALUE 'Fehlgeschlagen',
      END OF bestellung_status.


    METHODS CalculateBestellNr FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Bestellung~CalculateBestellNr.

    METHODS setStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Bestellung~setStatus.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Bestellung~validateDates.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Bestellung RESULT result.

    METHODS ausgeliefert FOR MODIFY
      IMPORTING keys FOR ACTION Bestellung~ausgeliefert RESULT result.

    METHODS abgeschlossen FOR MODIFY
      IMPORTING keys FOR ACTION Bestellung~abgeschlossen RESULT result.

    METHODS abgebrochen FOR MODIFY
      IMPORTING keys FOR ACTION Bestellung~abgebrochen RESULT result.

ENDCLASS.

CLASS lhc_Bestellung IMPLEMENTATION.

  METHOD CalculateBestellNr.

  READ ENTITIES OF ZI_Kunden IN LOCAL MODE
        ENTITY Bestellung
          FIELDS ( bestellid )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_bestellung).

    DELETE lt_bestellung WHERE bestellid IS NOT INITIAL.
    CHECK lt_bestellung IS NOT INITIAL.

    "Get max travelID
    SELECT SINGLE FROM zbestell_table FIELDS MAX( bestellid ) INTO @DATA(lv_max_bestellid).

    "update involved instances
    MODIFY ENTITIES OF ZI_Kunden IN LOCAL MODE
      ENTITY Bestellung
        UPDATE FIELDS ( bestellid )
        WITH VALUE #( FOR ls_bestellung IN lt_bestellung INDEX INTO i (
                           %key      = ls_bestellung-%key
                           bestellid  = lv_max_bestellid + i ) )
    REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD setStatus.
  READ ENTITIES OF ZI_Kunden IN LOCAL MODE
      ENTITY Bestellung
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(stati).

    DELETE stati WHERE Status IS NOT INITIAL.
    CHECK stati IS NOT INITIAL.

    MODIFY ENTITIES OF ZI_Kunden IN LOCAL MODE
    ENTITY Bestellung
      UPDATE
        FIELDS ( Status )
        WITH VALUE #( FOR statu IN stati
                      ( %tky         = statu-%tky
                        Status = bestellung_status-offen ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validateDates.
  READ ENTITIES OF zi_Kunden IN LOCAL MODE
      ENTITY Bestellung
        FIELDS ( BestellID bestelldatum abholdatum ) WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen).


    LOOP AT bestellungen INTO DATA(bestellung).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = bestellung-%tky
                       %state_area = 'VALIDATE_DATES' )
        TO reported-bestellung.

      IF bestellung-abholdatum < bestellung-bestelldatum.
        APPEND VALUE #( %tky = bestellung-%tky ) TO failed-bestellung.
        APPEND VALUE #( %tky               = bestellung-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcm_rap(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcm_rap=>bestelldatum_vor_abholdatum
                                                 bestelldatum = bestellung-bestelldatum
                                                 abholdatum   = bestellung-abholdatum
                                                 BestellID  = bestellung-BestellID )
                        %element-bestelldatum = if_abap_behv=>mk-on
                        %element-abholdatum   = if_abap_behv=>mk-on ) TO reported-bestellung.

      ELSEIF bestellung-bestelldatum < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky               = bestellung-%tky ) TO failed-bestellung.
        APPEND VALUE #( %tky               = bestellung-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcm_rap(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcm_rap=>bestelldatum_vor_systemdatum
                                                 bestelldatum = bestellung-bestelldatum )
                        %element-bestelldatum = if_abap_behv=>mk-on ) TO reported-bestellung.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
  READ ENTITIES OF zi_kunden IN LOCAL MODE
      ENTITY Bestellung
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen)
      FAILED failed.

    result =
      VALUE #(
        FOR bestellung IN bestellungen
          LET delivered =   COND #( WHEN bestellung-Status = bestellung_status-ausgeliefert
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              finished =   COND #( WHEN bestellung-Status = bestellung_status-abgeschlossen
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
              canceled =   COND #( WHEN bestellung-Status = bestellung_status-abgebrochen
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
              "canceled =   COND #( WHEN statu-Status = stat-abgebrochen
              "                        THEN if_abap_behv=>fc-o-disabled
               "                       ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky                 = bestellung-%tky
              %action-ausgeliefert = delivered
              %action-abgeschlossen = finished
              %action-abgebrochen = canceled
             " %action-abgebrochen = canceled
             ) ).
  ENDMETHOD.

  METHOD ausgeliefert.
  " Set the new overall status
    MODIFY ENTITIES OF zi_kunden IN LOCAL MODE
      ENTITY Bestellung
         UPDATE
           FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Status = bestellung_status-ausgeliefert ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zi_kunden IN LOCAL MODE
      ENTITY Bestellung
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen).

    result = VALUE #( FOR bestellung IN bestellungen
                        ( %tky   = bestellung-%tky
                          %param = bestellung ) ).
  ENDMETHOD.

  METHOD abgeschlossen.
  " Set the new overall status
    MODIFY ENTITIES OF zi_kunden IN LOCAL MODE
      ENTITY Bestellung
         UPDATE
           FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Status = bestellung_status-abgeschlossen ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zi_kunden IN LOCAL MODE
      ENTITY Bestellung
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen).

    result = VALUE #( FOR bestellung IN bestellungen
                        ( %tky   = bestellung-%tky
                          %param = bestellung ) ).
  ENDMETHOD.

  METHOD abgebrochen.
  " Set the new overall status
    MODIFY ENTITIES OF zi_kunden IN LOCAL MODE
      ENTITY Bestellung
         UPDATE
           FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             Status = bestellung_status-abgebrochen ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zi_kunden IN LOCAL MODE
      ENTITY Bestellung
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(bestellungen).

    result = VALUE #( FOR bestellung IN bestellungen
                        ( %tky   = bestellung-%tky
                          %param = bestellung ) ).
  ENDMETHOD.

ENDCLASS.
