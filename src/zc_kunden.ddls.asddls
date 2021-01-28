@EndUserText.label: 'Projection View für Kunden'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

@UI: {
 headerInfo: { typeName: 'Kunde', typeNamePlural: 'Kunden', title: { type: #STANDARD, value: 'KundenID' } } }

@Search.searchable: true
define root view entity ZC_Kunden
  as projection on ZI_Kunden

{
  key KundenUUID,
      @Search.defaultSearchElement: true
      KundenID,
      Vorname,
      Nachname,
      Postleitzahl,
      Ort,
      Strasse,
      Hausnummer,
      Firma,
      Ansprechpartner,
      
      /* Associations */
      _Bestellung : redirected to composition child ZC_Bestellung
}
