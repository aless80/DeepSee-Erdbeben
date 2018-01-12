Class Ale.Erdbeben Extends %Persistent
{

Property erdCount As %Integer;

Property ErdbebenID As %String;

Property ErdbebensDatum As %Date;

Property ErdbebensZeit As %Time;

Property Ortsname As %String;

Property Regio As %String;

Property Magnitude As %Numeric;

Property Breite As %Numeric;

Property Länge As %Numeric;

Property Tiefe As %Integer;

Property Typ As %String;

Property Files As %String(MAXLEN = 250);

/// To get the data run: Do ##class(Ale.Erdbeben).GenerateData()
/// 
/// GetRawTextFromLink derives the server name and URL from <var>pLink</var> and then uses these to target a
/// <class>%Net.HttpRequest</class> at the article, returning its raw content as a string.
ClassMethod GetRawTextFromLink(pLink As %String, Output pSC As %Status) As %String
{
	I $D(pLink)=0 { //CHANGE/RM
		S pLink="http://www.hlug.de/start/geologie/erdbeben/aktuelle-ereignisse.html"
		S pLink=$e(pLink,$find(pLink,"http://"),*) 										
	}
	set pSC = $$$OK, tRawText = ""
	try {
		// derive server and path from pLink
		set pLink = $zstrip(pLink,"<>W")
			
		set tFirstSlash = $find(pLink,"/")
		set tServer = $e(pLink,1,tFirstSlash-2)
		set tPath = $e(pLink,tFirstSlash-1,*)
		
		//Create SLLConfigs
		S namespace=$Namespace
		zn "%SYS"
		S st=##class(Security.SSLConfigs).Create("Temp")
		S conf=##class(Security.SSLConfigs).%OpenId("Temp")
		S conf.VerifyPeer=0
		zn namespace		
		
		// send the HTTP request for the article
		set tRequest = ##class(%Net.HttpRequest).%New()
		set tRequest.Server = tServer
		Set tRequest.SSLConfiguration="Temp"
		set tSC = tRequest.Get(tPath)
		
		//Delete the SSLConfigs
		Zn "%SYS"
		Set st=##class(Security.SSLConfigs).Delete("Temp")
		Zn namespace
		If 'tSC{
			zn namespace
			W !,$System.Status.DisplayError(tSC)
			Quit 
		}
		quit:$$$ISERR(tSC)
		set len = 32000
		while len>0 {
			set tString = tRequest.HttpResponse.Data.Read(.len, .pSC)
			quit:$$$ISERR(pSC)
			set tRawText = tRawText _ tString
		}
		
	} catch (ex) {
		set pSC = ex.AsStatus()
	}
	quit tRawText
}

ClassMethod GetTableFromRawText(raw As %String, Output table As %Status) As %String
{
 	I $D(raw)=0 { 
	 	S raw=..GetRawTextFromLink() 
 	}
	S begin=$find(raw,"<table class=""tx-pgerdbeben"">")
	S end=$find(raw,"</table>",begin)
	S table=$E(raw,begin,end)
	Q table
}

/// run:  Do ##class(Ale.Erdbeben).GetDataFromTable(,.line,.erdCount)
ClassMethod GetDataFromTable(pLink As %String, ByRef line As %String, Output erdCount As %Integer) As %Status
{
	/*The last version of the raw text of table in pLink above looks like this:
	<tr><th>Datum/Uhrzeit</th>  ... title of the table ... 	<th>Typ</th>
	</tr>
	<tr class= "tr-odd">
		<td title="Zeit UTC:30.07.2015 12:22:38">30.07.2015 14:22:38</td>
		<td>Florstadt (Hessen, DE)</td>
		<td><a target="_blank" href="/fileadmin/messwerte/erdbebendienst/hlug2015ouqd.bulletin.txt">Bulletin</a> 
		<a target="_blank" href="/fileadmin/messwerte/erdbebendienst/hlug2015ouqd.pdf">PDF</a> 
		<a href="/fileadmin/messwerte/erdbebendienst/hlug2015ouqd.traces.png" title="Ereignis hlug2015ouqd" rel="lightbox[lb5]">Seismogramm</a></td>
		<td>1.60</td>
		<td>50.32</td>
		<td>8.85</td>
		<td>10</td>
		<td>A</td>
	<tr class= "tr-even"><td title="Zeit ....
	*/	
	//As List of %String
	IF $D(pLink)=0 {
		S raw=..GetRawTextFromLink()
	} ELSE {
		S raw=..GetRawTextFromLink(pLink)
		}
 	S table=..GetTableFromRawText(raw)
	S trbegin=1
 	S tdbegin=1
 	S tdend=1
 	S i=1
 	while 1 {
 		S trbegin=$find(table,"<tr class= ""tr-",trbegin)
		QUIT:(trbegin=0) 
 		S j=0
   		FOR {
	   		//Q:(i>3) //test
	   		S tdbegin=$find(table,"<td",tdbegin) //have to split this:
	   		S tdbegin=$find(table,">",tdbegin)   //because of the first field 
   			S tdend=$find(table,"</td>",tdbegin)-6
 			S line(i,$I(j))=$E(table,tdbegin,tdend)
	 		Q:$E(table,tdend+6,tdend+20)="<tr class= ""tr-"
	 	}
	 	
		//Fix some fields: 	1 is date time, 2 is Location
		//					3 are the pdf files
		//					4 to 8 are: Magnitude,Breite,Länge,Tiefe,Typ
		//9 is region or "Germany"
		S line(i,9) = $PIECE(line(i,2)," (",2)
		S line(i,2) = $PIECE(line(i,2)," (",1)
		S line(i,9)=$REPLACE(line(i,9),")","")
		S line(i,9)=$REPLACE(line(i,9),", DE","")
		//Grab those three files and store them in line(n,3,1:3)
  		S files=line(i,3)
  		S line(i,3)="files"
  		S www="http://www.hlug.de"
  		S pdf1begin=$find(files,"href=""")
  		S line(i,3,1)=www_$E(files,pdf1begin,$find(files,"""",pdf1begin)-2)
  		S pdf2begin=$find(files,"href=""",pdf1begin)
  		S line(i,3,2)=www_$E(files,pdf2begin,$find(files,"""",pdf2begin)-2)
  		S pdf3begin=$find(files,"href=""",pdf2begin)
  		S line(i,3,3)=www_$E(files,pdf3begin,$find(files,"""",pdf3begin)-2)
  		S i=i+1
  		
 		//Security stop
 		break:(i=666)
 		}
 	S erdCount=i-1
 	W !,"I found "_erdCount_" lines",!! 
 	Q $$$OK
}

// run: Do ##class(Ale.Erdbeben).GenerateData()

ClassMethod GenerateData(maxCount As %Integer) As %Status
{
    Set status=$$$OK
    Write !, "Deleting Erdbeben data..."
    //first kill extent and kill extents of child tables (none for Ale.Erdbeben)
    Do ..%KillExtent()
    
    Write !, "Adding Erdbeben..."
	IF $DATA(maxCount)=0 {
		Set status=..GetErdbeben()
	} ELSE {
		Set status=..GetErdbeben(maxCount)
	}    
    Quit status
}

/// run: Do ##class(Ale.Erdbeben).GetErdbeben() and then build the Erdbeben cube
ClassMethod GetErdbeben(records As %Integer) As %Status
{
	W !,"Parsing data from http://www.hlug.de/start/geologie/erdbeben/aktuelle-ereignisse.html",!
	D ..%KillExtent()
	S status=..GetDataFromTable(,.line, .erdCount) 
	IF $DATA(records)=0 {
	S records=erdCount
	}
	For n = 1:1:records {
		Set erd=##class(Ale.Erdbeben).%New()
    	Set erd.erdCount=records
    	Set erd.ErdbebenID=n
    	Set erd.ErdbebensDatum=$ZDATEH($PIECE($TRANSLATE(line(n,1),".","/")," ",1),4)
 		Set erd.ErdbebensZeit=$ZTIMEH($PIECE($TRANSLATE(line(n,1),".","/")," ",2),4)
    	Set erd.Ortsname=line(n,2)
 		Set erd.Magnitude=line(n,4)
 		Set erd.Breite=line(n,5)
 		Set erd.Länge=line(n,6)
 		Set erd.Tiefe=line(n,7)
 		Set erd.Typ=line(n,8)
 		Set erd.Regio=line(n,9)
 		Set erd.Files=line(n,3,1)_"\n "_line(n,3,2)_"\n "_line(n,3,3)
 		Set status=erd.%Save()
	}
	//Do ##class(%DeepSee.Utils).%ProcessFact("Erdbeben",id)
	
	If $$$ISERR(status) {Do $System.Status.DisplayError(status) Write !, "Erdbeben save error"}
	Write !
    Write records," erdbenen stored in Ale.erdbeben"
    Quit status
}

Storage Default
{
<Data name="ErdbebenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>erdCount</Value>
</Value>
<Value name="3">
<Value>ErdbebenID</Value>
</Value>
<Value name="4">
<Value>ErdbebensDatum</Value>
</Value>
<Value name="5">
<Value>ErdbebensZeit</Value>
</Value>
<Value name="6">
<Value>Ortsname</Value>
</Value>
<Value name="7">
<Value>Regio</Value>
</Value>
<Value name="8">
<Value>Magnitude</Value>
</Value>
<Value name="9">
<Value>Breite</Value>
</Value>
<Value name="10">
<Value>Länge</Value>
</Value>
<Value name="11">
<Value>Tiefe</Value>
</Value>
<Value name="12">
<Value>Typ</Value>
</Value>
<Value name="13">
<Value>Files</Value>
</Value>
</Data>
<DataLocation>^Ale.ErdbebenD</DataLocation>
<DefaultData>ErdbebenDefaultData</DefaultData>
<IdLocation>^Ale.ErdbebenD</IdLocation>
<IndexLocation>^Ale.ErdbebenI</IndexLocation>
<StreamLocation>^Ale.ErdbebenS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

