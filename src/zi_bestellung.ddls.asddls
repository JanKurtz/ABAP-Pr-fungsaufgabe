@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datenmodell für Bestellung'
define view entity ZI_Bestellung
  as select from zbestell_table as Bestellung

  association to parent ZI_Kunden as _Kunden on $projection.KundenUUID = _Kunden.KundenUUID

{
  key bestelluuid  as BestellUUID,
      key kunid        as KundenUUID,
      bestellid    as BestellID,
      bestelldatum as Bestelldatum,
      abholdatum   as Abholdatum,
      status       as Status,
      kommentar    as Kommentar,
      @Semantics.systemDateTime.lastChangedAt: true
      updatedatum  as Aktualisierung,

      /* Public associations */
      _Kunden
}
