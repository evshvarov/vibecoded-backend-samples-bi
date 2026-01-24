/// Business logic class defined by OpenAPI in HoleFoods.api.spec<br/>
/// Created Jan 24, 2026 11:47:54
Class HoleFoods.api.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 1;

/// Get OpenAPI spec
ClassMethod GetSpec() As %DynamicObject
{
    set specname=$p(..%ClassName(1),".impl")
    Set spec = {}.%FromJSON(##class(%Dictionary.CompiledXData).%OpenId(specname_".spec||OpenAPI").Data)
	Set url = $Select(%request.Secure:"https",1:"http") _ "://"_$Get(%request.CgiEnvs("SERVER_NAME")) _ ":" _ $Get(%request.CgiEnvs("SERVER_PORT")) _ %request.Application
	Set spec.servers = [{"url" : (url)}]
	Quit spec
}

/// List sales outlets
ClassMethod ListOutlets() As %DynamicObject
{
    Set result = []
    Set stmt = ##class(%SQL.Statement).%New()
    Set sc = stmt.%Prepare("SELECT o.%Id AS OutletId, o.City, o.Type, c.Name AS Country FROM HoleFoods.Outlet o LEFT JOIN HoleFoods.Country c ON o.Country = c.%Id ORDER BY c.Name, o.City")
    If $$$ISERR(sc) {
        Do ..%SetStatusCode(500)
        Quit result
    }

    Set rset = stmt.%Execute()
    While rset.%Next() {
        Set item = {}
        Set item.OutletId = rset.%Get("OutletId")
        Set item.City = rset.%Get("City")
        Set item.Type = rset.%Get("Type")
        Set item.Country = rset.%Get("Country")
        Do result.%Push(item)
    }

    Quit result
}

/// Get sales summary
ClassMethod GetSalesSummary(startDate As %String = "", endDate As %String = "", outletId As %String = "") As %DynamicObject
{
    Set where = "WHERE t.Actual = 1"
    Set startH = ""
    Set endH = ""
    Set outletNum = ""

    If startDate '= "" {
        Set startH = $ZDATEH(startDate, 3)
        If startH < 0 {
            Do ..%SetStatusCode(400)
            Quit {}
        }
        Set where = where_" AND t.DateOfSale >= "_startH
    }

    If endDate '= "" {
        Set endH = $ZDATEH(endDate, 3)
        If endH < 0 {
            Do ..%SetStatusCode(400)
            Quit {}
        }
        Set where = where_" AND t.DateOfSale <= "_endH
    }

    If outletId '= "" {
        Set outletNum = +outletId
        If outletNum <= 0 {
            Do ..%SetStatusCode(400)
            Quit {}
        }
        Set where = where_" AND t.Outlet = "_outletNum
    }

    Set summary = {}
    Set totalStmt = ##class(%SQL.Statement).%New()
    Set sc = totalStmt.%Prepare("SELECT SUM(t.AmountOfSale) AS TotalSales, SUM(t.UnitsSold) AS UnitsSold FROM HoleFoods.Transaction t "_where)
    If $$$ISERR(sc) {
        Do ..%SetStatusCode(500)
        Quit {}
    }

    Set totalRset = totalStmt.%Execute()
    If totalRset.%Next() {
        Set summary.TotalSales = +totalRset.%Get("TotalSales")
        Set summary.UnitsSold = +totalRset.%Get("UnitsSold")
    } Else {
        Set summary.TotalSales = 0
        Set summary.UnitsSold = 0
    }

    Set summary.Items = []
    Set stmt = ##class(%SQL.Statement).%New()
    Set sc = stmt.%Prepare("SELECT p.SKU, p.Name, SUM(t.AmountOfSale) AS TotalSales, SUM(t.UnitsSold) AS UnitsSold FROM HoleFoods.Transaction t JOIN HoleFoods.Product p ON t.Product = p.%Id "_where_" GROUP BY p.SKU, p.Name ORDER BY TotalSales DESC")
    If $$$ISERR(sc) {
        Do ..%SetStatusCode(500)
        Quit {}
    }

    Set rset = stmt.%Execute()
    While rset.%Next() {
        Set item = {}
        Set item.SKU = rset.%Get("SKU")
        Set item.Name = rset.%Get("Name")
        Set item.TotalSales = +rset.%Get("TotalSales")
        Set item.UnitsSold = +rset.%Get("UnitsSold")
        Do summary.Items.%Push(item)
    }

    Quit summary
}

/// List all products
ClassMethod ListProducts() As %DynamicObject
{
    Set result = []
    Set stmt = ##class(%SQL.Statement).%New()
    Set sc = stmt.%Prepare("SELECT SKU, Category, Name, Price FROM HoleFoods.Product")
    If $$$ISERR(sc) {
        Do ..%SetStatusCode(500)
        Quit {}
    }

    Set rset = stmt.%Execute()
    While rset.%Next() {
        Set item = {}
        Set item.SKU = rset.%Get("SKU")
        Set item.Category = rset.%Get("Category")
        Set item.Name = rset.%Get("Name")
        Set item.Price = rset.%Get("Price")
        Do result.%Push(item)
    }

    Quit result
}

/// Create product<br/>
/// The method arguments hold values for:<br/>
///     body<br/>
ClassMethod CreateProduct(body As %DynamicObject) As %DynamicObject
{
    If '$IsObject(body) {
        Do ..%SetStatusCode(400)
        Quit {}
    }

    Set product = ##class(HoleFoods.Product).%New()
    Set product.SKU = body.%Get("SKU")
    Set product.Name = body.%Get("Name")
    Set product.Category = body.%Get("Category")
    Set product.Price = body.%Get("Price")

    Set sc = product.%Save()
    If $$$ISERR(sc) {
        Do ..%SetStatusCode(500)
        Quit {}
    }

    Do ..%SetStatusCode(201)
    Quit ..ProductToDynamic(product)
}

/// Get product by SKU<br/>
/// The method arguments hold values for:<br/>
///     sku<br/>
ClassMethod GetProduct(sku As %String) As %DynamicObject
{
    Set product = ##class(HoleFoods.Product).%OpenId(sku)
    If '$IsObject(product) {
        Do ..%SetStatusCode(404)
        Quit {}
    }

    Quit ..ProductToDynamic(product)
}

/// Update product by SKU<br/>
/// The method arguments hold values for:<br/>
///     sku<br/>
///     body<br/>
ClassMethod UpdateProduct(sku As %String, body As %DynamicObject) As %DynamicObject
{
    If '$IsObject(body) {
        Do ..%SetStatusCode(400)
        Quit {}
    }

    Set product = ##class(HoleFoods.Product).%OpenId(sku)
    If '$IsObject(product) {
        Do ..%SetStatusCode(404)
        Quit {}
    }

    If body.%IsDefined("SKU"), body.%Get("SKU") '= sku {
        Do ..%SetStatusCode(400)
        Quit {}
    }
    If body.%IsDefined("Name") {
        Set product.Name = body.%Get("Name")
    }
    If body.%IsDefined("Category") {
        Set product.Category = body.%Get("Category")
    }
    If body.%IsDefined("Price") {
        Set product.Price = body.%Get("Price")
    }

    Set sc = product.%Save()
    If $$$ISERR(sc) {
        Do ..%SetStatusCode(500)
        Quit {}
    }

    Quit ..ProductToDynamic(product)
}

/// Delete product by SKU<br/>
/// The method arguments hold values for:<br/>
///     sku<br/>
ClassMethod DeleteProduct(sku As %String) As %DynamicObject
{
    Set product = ##class(HoleFoods.Product).%OpenId(sku)
    If '$IsObject(product) {
        Do ..%SetStatusCode(404)
        Quit {}
    }

    Set sc = ##class(HoleFoods.Product).%DeleteId(sku)
    If $$$ISERR(sc) {
        Do ..%SetStatusCode(500)
        Quit {}
    }

    Do ..%SetStatusCode(204)
    Quit {}
}

ClassMethod ProductToDynamic(product As HoleFoods.Product) As %DynamicObject [ Private ]
{
    Set item = {}
    Set item.SKU = product.SKU
    Set item.Category = product.Category
    Set item.Name = product.Name
    Set item.Price = product.Price
    Quit item
}

}
