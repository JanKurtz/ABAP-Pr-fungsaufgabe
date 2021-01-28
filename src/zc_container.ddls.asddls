@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View für Container'
@Metadata.allowExtensions: true

@UI: {
 headerInfo: { typeName: 'Container', typeNamePlural: 'Container', title: { type: #STANDARD, value: 'ContainerID' } } }

@Search.searchable: true
define view entity ZC_Container
  as projection on ZI_Container

{
  key ContainerUUID,
  key AbfallkategorieUUID,
  key BestellUUID,
      //Zuordnung von Bestellungen zu Containern
      //Abholdatum automatisch mit Abholdatum aus Bestellung füllen
      @Consumption.valueHelpDefinition: [ {entity: {name: 'ZC_Bestellung', element: 'BestellID'},
                                                additionalBinding: [ { localElement: 'Abholdatum',    element: 'Abholdatum',   usage: #RESULT },
                                                                     { localElement: 'BestellUUID',    element: 'BestellUUID',   usage: #RESULT } ] } ]
      BestellID,
      @Search.defaultSearchElement: true
      ContainerID,
      Abfallkategorie,
      Verfuegbarkeit,
      Gewicht,
      Abholdatum,

      /* associations */
      _Abfallkategorie : redirected to parent ZC_Kategorie
}
