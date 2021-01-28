CLASS zcm_rap DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    CONSTANTS:
      BEGIN OF bestelldatum_vor_systemdatum,
        msgid TYPE symsgid VALUE 'ZRAP_MSG',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'Bestelldatum',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF bestelldatum_vor_systemdatum .

      CONSTANTS:
      BEGIN OF bestelldatum_vor_abholdatum,
        msgid TYPE symsgid VALUE 'ZRAP_MSG',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'Bestelldatum',
        attr2 TYPE scx_attrname VALUE 'Abholdatum',
        attr3 TYPE scx_attrname VALUE 'BestellID',
        attr4 TYPE scx_attrname VALUE '',
      END OF bestelldatum_vor_abholdatum .

       CONSTANTS:
      BEGIN OF bestellid_unbekannt,
        msgid TYPE symsgid VALUE 'ZRAP_MSG',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'BestellID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF bestellid_unbekannt .

    METHODS constructor
      IMPORTING
        severity   TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid     LIKE if_t100_message=>t100key OPTIONAL
        previous   TYPE REF TO cx_root OPTIONAL
        bestelldatum TYPE zbestelldate OPTIONAL
        abholdatum TYPE zabholdate OPTIONAL
        bestellid TYPE zb_id OPTIONAL.

        DATA bestelldatum TYPE zbestelldate READ-ONLY.
        DATA abholdatum TYPE zabholdate READ-ONLY.
        DATA bestellid TYPE zb_id READ-ONLY.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcm_rap IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->if_abap_behv_message~m_severity = severity.

    me->bestelldatum = bestelldatum.
    me->abholdatum = abholdatum.
    me->bestellid = |{ bestellid ALPHA = OUT }|.

  ENDMETHOD.
ENDCLASS.
