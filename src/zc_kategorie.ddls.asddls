@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View für Abfallkategorie'
@Metadata.allowExtensions: true

@UI: {
 headerInfo: { typeName: 'Abfallkategorie', typeNamePlural: 'Abfallkategorien', title: { type: #STANDARD, value: 'AbfallkategorieID' } } }

@Search.searchable: true
define root view entity ZC_Kategorie 
    as projection on ZI_Kategorie
    
    {
  key AbfallkategorieUUID,
      @Search.defaultSearchElement: true
      AbfallkategorieID,  
      Name,   
      Preis,   
      Waehrung,
      
      /* Associations */
      _Container : redirected to composition child ZC_Container
    
}
