/// Use or operation of this code is subject to acceptance of the license available in the code repository for this code.
/// Instances of this class represent specific transactions within
/// the HoleFoods demo.<br/>
/// This table combines both "actual" data and "budget" data so that the sample cube
/// can show comparisons between the two.<br/>
/// Actual records will have a true value for the Actual property.<br/>
/// Budget records will have a false value for the Actual property. The budget value will
/// be stored in the TargetAmount property. Budget values are set for each city, product, and
/// month (using the first day of the month).
Class HoleFoods.Transaction Extends (%Persistent, %JSON.Adaptor) [ SqlTableName = SalesTransaction ]
{

/// Track changes to this class.
Parameter DSTIME = "auto";

Index DateOfSale On DateOfSale;

Index Product On Product [ Type = bitmap ];

Index Outlet On Outlet [ Type = bitmap ];

/// If true, this represents an actual sale
/// otherwise this represents a sales target.
Property Actual As %Boolean;

/// Date of this sale.
Property DateOfSale As %Date;

/// Product sold.
Property Product As HoleFoods.Product;

/// Store or other outlet in which the sale occurred.
Property Outlet As HoleFoods.Outlet;

/// Channel product was sold through: "Retail" or "Online".
Property Channel As %String(DISPLAYLIST = ",Retail,Online", VALUELIST = ",1,2");

/// Actual amount of this sale.
Property AmountOfSale As %Numeric(SCALE = 2);

/// Units sold.
Property UnitsSold As %Integer;

/// Discount amount.
Property Discount As %Numeric(SCALE = 2);

/// For budget items, this is the target value for a period,region, and product.
Property TargetAmount As %Numeric(SCALE = 2);

/// Customer comment on this transaction (if any).
Property Comment As %String(MAXLEN = 500);

/// US Zipcode of customer (if provided).
Property ZipCode As %String(MAXLEN = 25);

/// Latitude of customer (determined from zip code).
Property Latitude As %Double;

/// Longitude of customer (determined from zip code).
Property Longitude As %Double;

/// Total sales and units sold with optional filters.
Query SalesSummary(startDate As %Date = 0, endDate As %Date = 0, outletId As %Integer = 0) As %SQLQuery [ SqlProc ]
{
SELECT
    SUM(t.AmountOfSale) AS TotalSales,
    SUM(t.UnitsSold) AS UnitsSold
FROM HoleFoods.SalesTransaction t
WHERE t.Actual = 1
  AND (:startDate = 0 OR t.DateOfSale >= :startDate)
  AND (:endDate = 0 OR t.DateOfSale <= :endDate)
  AND (:outletId = 0 OR t.Outlet = :outletId)
}

/// Sales totals by SKU with optional filters.
Query SalesBySku(startDate As %Date = 0, endDate As %Date = 0, outletId As %Integer = 0) As %SQLQuery [ SqlProc ]
{
SELECT
    p.SKU AS SKU,
    p.Name AS Name,
    SUM(t.AmountOfSale) AS TotalSales,
    SUM(t.UnitsSold) AS UnitsSold
FROM HoleFoods.SalesTransaction t
JOIN HoleFoods.Product p ON t.Product = p.%Id
WHERE t.Actual = 1
  AND (:startDate = 0 OR t.DateOfSale >= :startDate)
  AND (:endDate = 0 OR t.DateOfSale <= :endDate)
  AND (:outletId = 0 OR t.Outlet = :outletId)
GROUP BY p.SKU, p.Name
ORDER BY TotalSales DESC
}

/// List transactions with optional filters.
Query TransactionsList(startDate As %Date = 0, endDate As %Date = 0, outletId As %Integer = 0, productSku As %String = "") As %SQLQuery [ SqlProc ]
{
SELECT
    t.%Id AS TransactionId,
    t.DateOfSale AS DateOfSale,
    t.Actual AS Actual,
    t.AmountOfSale AS AmountOfSale,
    t.UnitsSold AS UnitsSold,
    t.Discount AS Discount,
    p.SKU AS ProductSKU,
    p.Name AS ProductName,
    o.%Id AS OutletId,
    o.City AS OutletCity
FROM HoleFoods.SalesTransaction t
JOIN HoleFoods.Product p ON t.Product = p.%Id
LEFT JOIN HoleFoods.Outlet o ON t.Outlet = o.%Id
WHERE (:startDate = 0 OR t.DateOfSale >= :startDate)
  AND (:endDate = 0 OR t.DateOfSale <= :endDate)
  AND (:outletId = 0 OR t.Outlet = :outletId)
  AND (:productSku = '' OR p.SKU = :productSku)
ORDER BY t.DateOfSale DESC
}

Storage Default
{
<Data name="TransactionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Actual</Value>
</Value>
<Value name="3">
<Value>DateOfSale</Value>
</Value>
<Value name="4">
<Value>Product</Value>
</Value>
<Value name="5">
<Value>Outlet</Value>
</Value>
<Value name="6">
<Value>Channel</Value>
</Value>
<Value name="7">
<Value>AmountOfSale</Value>
</Value>
<Value name="8">
<Value>UnitsSold</Value>
</Value>
<Value name="9">
<Value>Discount</Value>
</Value>
<Value name="10">
<Value>TargetAmount</Value>
</Value>
<Value name="11">
<Value>Comment</Value>
</Value>
<Value name="12">
<Value>ZipCode</Value>
</Value>
<Value name="13">
<Value>Latitude</Value>
</Value>
<Value name="14">
<Value>Longitude</Value>
</Value>
</Data>
<DataLocation>^HoleFoods.TransactionD</DataLocation>
<DefaultData>TransactionDefaultData</DefaultData>
<IdLocation>^HoleFoods.TransactionD</IdLocation>
<IndexLocation>^HoleFoods.TransactionI</IndexLocation>
<StreamLocation>^HoleFoods.TransactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
