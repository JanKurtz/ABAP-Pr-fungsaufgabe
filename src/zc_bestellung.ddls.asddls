@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View für Bestellung'
@Metadata.allowExtensions: true

@UI: {
 headerInfo: { typeName: 'Bestellung', typeNamePlural: 'Bestellungen', title: { type: #STANDARD, value: 'BestellID' } } }

@Search.searchable: true
define view entity ZC_Bestellung
  as projection on ZI_Bestellung
{
  key BestellUUID,
      key KundenUUID,
      @Search.defaultSearchElement: true
      BestellID,
      Bestelldatum,
      Abholdatum,
      Status,
      Kommentar,
      Aktualisierung,

      /* associations */
      _Kunden : redirected to parent ZC_Kunden
}
