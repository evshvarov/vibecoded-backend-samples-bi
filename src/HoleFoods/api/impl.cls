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
        d ..%SetHeader("X-Error", "Status error: "_$System.Status.GetErrorText(sc))
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

/// List transactions
ClassMethod ListTransactions(startDate As %String = "", endDate As %String = "", outletId As %String = "", productSku As %String = "") As %DynamicObject
{
    s ^AAA="entered ListTransactions"
    If '$Data(startDate) Set startDate = ""
    If '$Data(endDate) Set endDate = ""
    If '$Data(outletId) Set outletId = ""
    If '$Data(productSku) Set productSku = ""
    Set productSku = $ZStrip(productSku, "<>W")
    Set startH = 0
    Set endH = $Piece($H, ",", 1)
    Set outletNum = 0

    If startDate '= "" {
        Set startH = $ZDATEH(startDate, 3)
        If startH < 0 {
            Do ..%SetStatusCode(400)
            Do ..%SetHeader("X-Error", "Invalid startDate format")
            Quit {}
        }
    }

    If endDate '= "" {
        Set endH = $ZDATEH(endDate, 3)
        If endH < 0 {
            Do ..%SetStatusCode(400)
            Do ..%SetHeader("X-Error", "Invalid endDate format")
            Quit {}
        }
    }

    If outletId '= "" {
        Set outletNum = +outletId
        If outletNum <= 0 {
            Do ..%SetStatusCode(400)
            Do ..%SetHeader("X-Error", "Invalid outletId format")
            Quit {}
        }
    }

    s ^AAA="after outletId check in ListTransactions"

    Set result = []
   //set outletNum=+outletNum
    s ^AAA("startH")=startH
    s ^AAA("endH")=endH
    s ^AAA("outletNum")=outletNum
    s ^AAA("productSku")=productSku
    
    set rset = ##class(HoleFoods.Transaction).TransactionsListFunc(startH, endH, outletNum, productSku)
    if rset.%SQLCODE<0 {
        d ..%SetStatusCode(500)
        d ..%SetHeader("X-Error", rset.%Message)
        return "" 
    }
    s ^AAA="after TransactionsListFunc call in ListTransactions"
    
    While rset.%Next() {
        Set item = {}
        Set item.TransactionId = rset.%Get("TransactionId")
        Set item.DateOfSale = $ZDT(rset.%Get("DateOfSale"),3)
        Set item.Actual = rset.%Get("Actual")
        Set item.AmountOfSale = rset.%Get("AmountOfSale")
        Set item.UnitsSold = rset.%Get("UnitsSold")
        Set item.Discount = rset.%Get("Discount")
        Set item.ProductSKU = rset.%Get("ProductSKU")
        Set item.ProductName = rset.%Get("ProductName")
        Set item.OutletId = rset.%Get("OutletId")
        Set item.OutletCity = rset.%Get("OutletCity")
        Do result.%Push(item)
    }

   
    Quit result
}

/// Get sales summary
ClassMethod GetSalesSummary(startDate As %String = "", endDate As %String = "", outletId As %String = "") As %DynamicObject
{
    If '$Data(startDate) Set startDate = ""
    If '$Data(endDate) Set endDate = ""
    If '$Data(outletId) Set outletId = ""
    Set startH = 0
    Set endH = $Piece($H, ",", 1)
    Set outletNum = 0

    If startDate '= "" {
        Set startH = $ZDATEH(startDate, 3)
        If startH < 0 {
            Do ..%SetStatusCode(400)
            Quit {}
        }
    }

    If endDate '= "" {
        Set endH = $ZDATEH(endDate, 3)
        If endH < 0 {
            Do ..%SetStatusCode(400)
            Quit {}
        }
    }

    If outletId '= "" {
        Set outletNum = +outletId
        If outletNum <= 0 {
            Do ..%SetStatusCode(400)
            Quit {}
        }
    }
    Set summary = {}
    Set totalRset = ##class(HoleFoods.Transaction).SalesSummaryFunc(startH, endH, outletNum)
    If totalRset.%SQLCODE < 0 {
        d ..%SetHeader("X-Error", totalRset.%Message)
        Do ..%SetStatusCode(500)
        Quit {}
    }
    If totalRset.%Next() {
        Set summary.TotalSales = +totalRset.%Get("TotalSales")
        Set summary.UnitsSold = +totalRset.%Get("UnitsSold")
    } Else {
        Set summary.TotalSales = 0
        Set summary.UnitsSold = 0
    }

    Set summary.Items = []
    Set rset = ##class(HoleFoods.Transaction).SalesBySkuFunc(startH, endH, outletNum)
    If rset.%SQLCODE < 0 {
        d ..%SetHeader("X-Error", rset.%Message)
        Do ..%SetStatusCode(500)
        Quit {}
    }
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
        d ..%SetHeader("X-Error", "Status error: "_$System.Status.GetErrorText(sc))
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
        d ..%SetHeader("X-Error", "Status error: "_$System.Status.GetErrorText(sc))
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
        d ..%SetHeader("X-Error", "Status error: "_$System.Status.GetErrorText(sc))
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
        d ..%SetHeader("X-Error", "Status error: "_$System.Status.GetErrorText(sc))
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
