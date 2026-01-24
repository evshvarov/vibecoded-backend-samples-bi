/// Use or operation of this code is subject to acceptance of the license available in the code repository for this code.
/// This specifies a geographic region within the HoleFoods demo.
Class HoleFoods.Region Extends %Persistent
{

/// Name of this region.
Property Name As %String(MAXLEN = 80);

Storage Default
{
<Data name="RegionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^HoleFoods.RegionD</DataLocation>
<DefaultData>RegionDefaultData</DefaultData>
<ExtentSize>4</ExtentSize>
<IdLocation>^HoleFoods.RegionD</IdLocation>
<IndexLocation>^HoleFoods.RegionI</IndexLocation>
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
<AverageFieldSize>9.5</AverageFieldSize>
<Selectivity>25.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^HoleFoods.RegionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
