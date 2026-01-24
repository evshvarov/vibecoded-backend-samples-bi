/// Use or operation of this code is subject to acceptance of the license available in the code repository for this code.
/// This represents a Product within the HoleFoods demo.
Class HoleFoods.Product Extends (%Persistent, %JSON.Adaptor)
{

Index KEY On SKU [ IdKey ];

/// Category of this product.
Property Category As %String(MAXLEN = 100);

/// Name of this product.
Property Name As %String(MAXLEN = 120);

/// SKU for this product.
Property SKU As %String(MAXLEN = 22);

/// List price for this product.
Property Price As %Numeric(MINVAL = 0);

Storage Default
{
<Data name="ProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Category</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Price</Value>
</Value>
</Data>
<DataLocation>^HoleFoods.ProductD</DataLocation>
<DefaultData>ProductDefaultData</DefaultData>
<ExtentSize>17</ExtentSize>
<IdLocation>^HoleFoods.ProductD</IdLocation>
<IndexLocation>^HoleFoods.ProductI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>9</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb("SKU-101","SKU-192","SKU-199","SKU-203","SKU-204","SKU-222","SKU-223","SKU-287","SKU-296","SKU-451","SKU-601","SKU-708","SKU-709","SKU-712","SKU-900","SKU-928"),$lb(5,6,4,6,5,6,5,5,4,4,4,6,5,4,5),$lb(1397445933,808517632,959578112,838860800,956301312,825833728,842019584,855638016,872415232,808714240,842137600,838860800,855638016,842203136,943128576,943128576,959840256,842610176,875901184,875901184,909127936,909127936,925906944,939524096,956301312,809041920,825360384,925970944,959459328,808452096,842530816,1397445933))</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="Category">
<AverageFieldSize>7.65</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" CANDY"," CEREAL"," FRUIT"," FRUIT"," PASTA"," PASTA"," PASTA"," SEAFOOD"," SNACK"," SNACK"," SNACK"," SNACK"," SNACK"," SNACK"," VEGETABLE"," VEGETABLE"),$lb(2,1,7,1,7,7,1,2,7,7,7,7,7,1,11),$lb(541278542,1095648345,1163019585,1128616517,1179800905,0,0,1179800905,1346458452,0,0,0,0,1346458452,1397047622,1161905743,1312899915,0,0,0,0,0,0,0,0,0,0,1397637443,1447380805,0,0,542524743))</Histogram>
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="Name">
<AverageFieldSize>17.71</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" BAGELS (DOZEN)"," BUNDT CAKE"," CHEERIOS (BOX)"," DONUTS (DOZEN)"," FREE-RANGE DONUTS (DOZEN)"," FRUIT LOOPS (BOX)"," LIFESAVERS (ROLL)"," ONION RING"," ONION RING"," PENNE (BOX)"," PINEAPPLE RINGS (CAN)"," PRETZELS (BAG)"," SWISS CHEESE (SLICED)"," TORTELLINI (FROZEN)"," UNSALTED PRETZELS (BAG)"," ZITI (BOX)"),$lb(2,1,1,1,3,1,1,12,1,2,2,1,1,1,1),$lb(541212999,1095189836,1431192660,1112886852,1128809797,1128809797,1146048085,1146048085,1179796805,1162161490,1430869024,1179800905,1279870533,1279870533,1330530639,0,0,1330530639,1346719310,1162759749,1229866305,1229866305,1380275290,1347568980,1398229331,1398229331,1414484564,1414484564,1431196481,1431196481,1514755145,542787924))</Histogram>
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="Price">
<AverageFieldSize>4.82</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(1.15,1.95,2.95,2.95,3.95,3.95,4.25,4.95,4.95,5.95,5.95,6.95,8.95,12.95,19.95,22.95),$lb(2,0,4,0,4,0,2,4,0,4,0,0,0,1,0),"")</Histogram>
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="SKU">
<AverageFieldSize>9</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="KEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^HoleFoods.ProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
