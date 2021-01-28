@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datenmodell für Container'

define view entity ZI_Container
  as select from zcontainer_table as Container

  association to parent ZI_Kategorie as _Abfallkategorie on $projection.AbfallkategorieUUID = _Abfallkategorie.AbfallkategorieUUID
  
  association [1..1] to ZI_Bestellung as _Bestellung on $projection.BestellUUID = _Bestellung.BestellUUID

{
  key containeruuid         as ContainerUUID,
      key ak_id             as AbfallkategorieUUID,
      key b_id              as BestellUUID,
      containerid           as ContainerID,
      _Abfallkategorie.Name as Abfallkategorie,
      _Bestellung.BestellID as BestellID,
      verfuegbarkeit        as Verfuegbarkeit,
      gewicht               as Gewicht,
      abholdatum            as Abholdatum,

      /* Public associations */
      _Abfallkategorie,
      _Bestellung

}
