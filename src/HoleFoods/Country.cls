/// Use or operation of this code is subject to acceptance of the license available in the code repository for this code.
/// This specifies the country within the HoleFoods demo.
Class HoleFoods.Country Extends %Persistent
{

/// Region in which this country is located.
Property Region As Region;

/// Name of this country.
Property Name As %String(MAXLEN = 90);

Storage Default
{
<Data name="CountryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Region</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^HoleFoods.CountryD</DataLocation>
<DefaultData>CountryDefaultData</DefaultData>
<ExtentSize>14</ExtentSize>
<IdLocation>^HoleFoods.CountryD</IdLocation>
<IndexLocation>^HoleFoods.CountryI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Name">
<AverageFieldSize>7.93</AverageFieldSize>
<Selectivity>7.1429%</Selectivity>
</Property>
<Property name="Region">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>25.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^HoleFoods.CountryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
