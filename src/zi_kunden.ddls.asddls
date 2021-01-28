@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datenmodell für Kunden'
define root view entity ZI_Kunden
  as select from zkunde_table as Kunde

  composition [0..*] of ZI_Bestellung as _Bestellung

{
  key kundenuuid      as KundenUUID,
      kundenid        as KundenID,
      vorname         as Vorname,
      nachname        as Nachname,
      plz             as Postleitzahl,
      ort             as Ort,
      strasse         as Strasse,
      hausnummer      as Hausnummer,
      firma           as Firma,
      ansprechpartner as Ansprechpartner,

      /* associations */
      _Bestellung
}
