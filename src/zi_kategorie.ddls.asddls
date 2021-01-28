@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datenmodell für Abfallkategorien'

define root view entity ZI_Kategorie
  as select from zkategorie_table as Kategorie
  
  composition [0..*] of ZI_Container as _Container

{
  key kategorieuuid as AbfallkategorieUUID,
      kategorieid   as AbfallkategorieID,
      name          as Name,
      @Semantics.amount.currencyCode : 'waehrung'
      preis         as Preis,
      waehrung      as Waehrung,
      
      /* associations */
      _Container
}
