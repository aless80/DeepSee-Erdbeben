# DeepSee-ErdBeben
This repository contains the source classes to be used in DeepSee, InterSystem's Business Intelligence platform: 

[DeepSee](http://www.intersystems.com/our-products/embedded-technologies/deepsee/ "DeepSee")


The source class parse the content of this webpage listing recent hearthquakes (Erdbeben) in the Hessen region. The source is an example of how to parse data from a website using Caché Objectscript code and display the data in a DeepSee dashboard. The data is extracted from this page: 

[Hessisches Landesamt für Umwelt und Geologie](http://www.hlug.de/start/geologie/erdbeben/aktuelle-ereignisse.html "")

After cloning this repository, the source class, cube class, pivot and dashboard can be imported as usual using Studio or Atelier, or from terminal as follows:

```
Set path="<path-to-local-files>"
Write $system.OBJ.Load(path_"Erdbeben.cls","cf")
Write $system.OBJ.Load(path_"ErdbebenCube.cls","cf")
Do ##class(%DeepSee.UserLibrary.Utils).%Import(path_"Erdbeben-Erdbeben.pivot.DFI",1)
Do ##class(%DeepSee.UserLibrary.Utils).%Import(path_"Erdbeben-Erdbeben_Karte.pivot.DFI",1)
Do ##class(%DeepSee.UserLibrary.Utils).%Import(path_"Erdbeben-Erdbeben.dashboard.DFI",1)
```

If your instance does not support UDL formatting please use the .xml files in the xml directory. 
To generate data based on the name frequency in the 1990s in the US and to build the DeepSee cube please run: 

```
Do ##class(Ale.Erdbeben).GenerateData() 
Do ##class(%DeepSee.Utils).%BuildCube("Erdbeben")
```

Screenshot of the "Erdbeben" dashboard:

![Alt text](https://github.com/aless80/DeepSee-Erdbeben/blob/master/DeepSee_dashboard.png "DeepSee-Erdbeben Dashboard")

