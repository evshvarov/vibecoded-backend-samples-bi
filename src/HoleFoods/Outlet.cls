/// Use or operation of this code is subject to acceptance of the license available in the code repository for this code.
/// This represents a Sales Outlet for the HoleFoods demo.
Class HoleFoods.Outlet Extends %Persistent
{

/// Country in which this city is located.
Property Country As Country;

/// City name of this location.
Property City As %String(MAXLEN = 100);

/// Population of this city.
Property Population As %Integer(MINVAL = 0);

/// Type of outlet: "retail", "web", etc.
Property Type As %String(MAXLEN = 50);

/// Latitude of this location.
Property Latitude As %Double;

/// Longitude of this location.
Property Longitude As %Double;

Storage Default
{
<Data name="OutletDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Country</Value>
</Value>
<Value name="3">
<Value>City</Value>
</Value>
<Value name="4">
<Value>Population</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>Latitude</Value>
</Value>
<Value name="7">
<Value>Longitude</Value>
</Value>
</Data>
<DataLocation>^HoleFoods.OutletD</DataLocation>
<DefaultData>OutletDefaultData</DefaultData>
<ExtentSize>35</ExtentSize>
<IdLocation>^HoleFoods.OutletD</IdLocation>
<IndexLocation>^HoleFoods.OutletI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(1,3,6,9,12,15,17,19,21,23,25,27,29,31,33,35),$lb(0,0,0,0,1,1,1,0,1,1,1,1,0,1,1),"")</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="City">
<AverageFieldSize>9.37</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" AMSTERDAM"," ATLANTA"," BEIJING"," BRASILIA"," FRANKFURT"," LOS ANGELES"," MANCHESTER"," MONTREAL"," MUNICH"," NICE"," PARIS"," ROME"," SAO PAOLO"," SHANGHAI"," TOKYO"," VANCOUVER"),$lb(2,1,2,1,1,1,2,2,1,1,1,1,2,1,1),$lb(541150547,1297306693,1414283598,1096043585,1111837002,1162431049,1380012873,1112686931,1179795790,1179795790,1280267040,1280267040,1296125507,1095648072,1330533458,1330533458,1431193923,1297436233,1313424197,1313424197,1346458185,1346458185,1380928837,1380928837,1396789024,1095704656,1212239431,1397244238,1414482777,1414482777,1447120451,542523726))</Histogram>
<Selectivity>2.8571%</Selectivity>
</Property>
<Property name="Country">
<AverageFieldSize>3.49</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(1,2,3,5,6,7,8,10,11,11,12,12,12,12,13,14),$lb(0,0,0,0,0,0,0,1,2,1,2,2,2,1,1),"")</Histogram>
<Selectivity>7.1429%</Selectivity>
</Property>
<Property name="Latitude">
<AverageFieldSize>10</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(-31.42800000000000082,-22.89399999999999835,18.96000000000000085,33.7569999999999979,35.62299999999999756,40.78499999999999659,41.86699999999999733,42.36119999999999663,43.70900000000000318,45.43800000000000239,47.58500000000000085,48.84400000000000119,50.09700000000000131,51.2120000000000033,52.35999999999999943,53.46999999999999886),$lb(1,0,0,1,0,1,1,1,1,1,1,0,1,1,1),"")</Histogram>
<Selectivity>2.8571%</Selectivity>
</Property>
<Property name="Longitude">
<AverageFieldSize>9.83</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(-123.1089999999999947,-118.2639999999999958,-87.63899999999999579,-73.96389999999999532,-70.56199999999999761,-43.22800000000000153,-2.237000000000000099,2.169000000000000039,4.338000000000000078,4.87699999999999978,8.678000000000000824,11.5779999999999994,13.40199999999999925,77.5870000000000033,121.465999999999994,139.703000000000003),$lb(2,1,1,2,1,1,0,0,2,0,0,1,0,0,1),"")</Histogram>
<Selectivity>2.8571%</Selectivity>
</Property>
<Property name="Population">
<AverageFieldSize>5.03</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(15804,461496,1830000,2455903,3263497,5000000,5278904,5600000,6200000,7145472,7287555,9785747,11150249,12369000,16738000,19306183),$lb(0,0,0,0,0,1,1,0,0,1,0,0,1,1,1),"")</Histogram>
<Selectivity>2.8571%</Selectivity>
</Property>
<Property name="Type">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "),$lb(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,536870912))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^HoleFoods.OutletS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
