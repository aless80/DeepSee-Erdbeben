/// This class contains a cube based on DeepSee.Study.Patients. 
/// <p>This class also contains utility methods used by this cube.
Class Ale.ErdbebenCube Extends %DeepSee.CubeDefinition [ DependsOn = Ale.Erdbeben ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="Erdbeben" displayName="Erdbeben" description="Represents earthquakes in Germany from www.hlug.de/start/geologie/erdbeben/aktuelle-ereignisse.html" disabled="false" abstract="false" sourceClass="Ale.Erdbeben" owner="_SYSTEM" nullReplacement="None" countMeasureName="%COUNT" countMeasureCaption="Erdbeben Count" bucketSize="8" bitmapChunkInMemory="false" defaultListing="Erdbeben listing" precompute="0" disableListingGroups="false">
  <dimension name="PlatzD" displayName="Platz" disabled="false" hasAll="true" allCaption="Alle Erdbeben" allDisplayName="Alle Erdbeben" type="data" calendar="gregorian" iKnowType="entity"  showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" >
      <level name="Regio" disabled="false" sourceProperty="Regio" list="false" useDisplayValue="true" useAsFilter="true" >
        
      </level>
      <level name="Ort" disabled="false" sourceProperty="%ID" list="false" nullReplacement="N.A." useDisplayValue="false" sort="asc numeric" useAsFilter="true" >
        <property name="Ortsname" disabled="false" sourceProperty="Ortsname"  sort="asc" isName="true" isDescription="false" isReference="true" useDisplayValue="true">
          
        </property>
      </level>
    </hierarchy>
  </dimension>
  <dimension name="MagnitudeD" displayName="Magnitude" disabled="false" hasAll="true" allCaption="Alle Erdbeben" allDisplayName="Alle Erdbeben" type="data" calendar="gregorian" iKnowType="entity"  showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" >
      <level name="Magnitude" disabled="false" sourceProperty="Magnitude" list="false" useDisplayValue="true" sort="asc" useAsFilter="true" >
      </level>
    </hierarchy>
  </dimension>
  <dimension name="BreiteD" displayName="Breite" disabled="false" hasAll="true" allCaption="Alle Erdbeben" allDisplayName="Alle Erdbeben" type="data" calendar="gregorian" iKnowType="entity"  showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" >
      <level name="Breite" displayName="Breite" description="Breite" disabled="false" sourceProperty="Breite" factName="DxBreite" list="false" useDisplayValue="false" sort="asc numeric" useAsFilter="true" >
      </level>
    </hierarchy>
  </dimension>
  <dimension name="LängeD" displayName="Länge" disabled="false" hasAll="true" allCaption="Alle Erdbeben" allDisplayName="Alle Erdbeben" type="data" calendar="gregorian" iKnowType="entity"  showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" >
      <level name="Länge" disabled="false" sourceProperty="Länge" list="false" useDisplayValue="true" sort="asc numeric" useAsFilter="true" >
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TiefeD" displayName="Tiefe" disabled="false" hasAll="true" allCaption="Alle Erdbeben" allDisplayName="Alle Erdbeben" type="data" calendar="gregorian" iKnowType="entity"  showHierarchies="default">
    <hierarchy name="H1" displayName="H1" disabled="false" >
      <level name="Tiefe" disabled="false" sourceProperty="Tiefe" list="false" useDisplayValue="true" sort="asc numeric" useAsFilter="true" >
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Typ" disabled="false" hasAll="false" allCaption="All Other" allDisplayName="Other" type="data"  showHierarchies="default">
    <hierarchy name="H1" disabled="false" >
      <level name="Typ" disabled="false" sourceProperty="Typ" list="false" useDisplayValue="true" sort="desc" useAsFilter="true" >
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ErdbebenID" disabled="false" hasAll="false" allCaption="All Other" allDisplayName="Other" type="data"  showHierarchies="default">
    <hierarchy name="H1" disabled="false" >
      <level name="ErdbebenID" disabled="false" sourceProperty="ErdbebenID" list="false" useDisplayValue="true" sort="asc numeric" useAsFilter="true" >
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Datum" disabled="false" hasAll="false" allCaption="All DatumZeit2" allDisplayName="DatumZeit2" sourceExpression="%source.ErdbebensDatum" type="time" calendar="gregorian" iKnowType="entity"  showHierarchies="default">
    <hierarchy name="H1" disabled="false" >
      <level name="Datum" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" sort="desc" useAsFilter="true" >
      </level>
    </hierarchy>
    
  </dimension>
  <dimension name="Zeit" disabled="false" hasAll="false" allCaption="All Zeit" allDisplayName="Zeit" type="data"  showHierarchies="default">
    <hierarchy name="H1" disabled="false" >
      <level name="Zeit" disabled="false" sourceExpression="$ZT(%source.ErdbebensZeit)" list="false" useDisplayValue="true" sort="desc" useAsFilter="true" >
      </level>
    </hierarchy>
  </dimension>
  <measure name="Magnitude" disabled="false" sourceProperty="Magnitude" aggregate="AVG" type="number"  searchable="false">
  </measure>
  <measure name="Tiefe" disabled="false" sourceProperty="Tiefe" aggregate="AVG" type="number"  searchable="false">
  </measure>
  <measure name="Latitude" disabled="false" sourceProperty="Breite" aggregate="AVG" type="number"  searchable="false">
    
  </measure>
  <measure name="Longitude" disabled="false" sourceProperty="Länge" aggregate="AVG" type="number"  searchable="false">
    
  </measure>
  <measure name="Breite" disabled="false" sourceProperty="Breite" aggregate="AVG" type="number"  searchable="false">
  </measure>
  <measure name="Länge" disabled="false" sourceProperty="Länge" aggregate="AVG" type="number"  searchable="false">
  </measure>
  <listing name="Erdbeben listing" displayName="Erdbeben listing" disabled="false" listingType="table" fieldList="%ID,ErdbebenID,ErdbebensDatum,ErdbebensZeit,Breite,Länge,Magnitude,Ortsname,Tiefe,Typ,erdCount,Files" orderBy="ErdbebensDatum,ErdbebensZeit">
  </listing>
</cube>
}

Storage Default
{
<Data name="ErdbebenCubeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Ale.ErdbebenCubeD</DataLocation>
<DefaultData>ErdbebenCubeDefaultData</DefaultData>
<IdLocation>^Ale.ErdbebenCubeD</IdLocation>
<IndexLocation>^Ale.ErdbebenCubeI</IndexLocation>
<StreamLocation>^Ale.ErdbebenCubeS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

Parameter DOMAIN = "PATIENTSAMPLE";

}

