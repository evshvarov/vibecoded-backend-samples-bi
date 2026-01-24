/// Business logic class defined by OpenAPI in HoleFoods.api.spec<br/>
/// Created Jan 24, 2026 11:47:54
Class HoleFoods.api.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Get OpenAPI spec
ClassMethod GetSpec() As %DynamicObject
{
    set specname=$p(..%ClassName(1),".impl")
    Set spec = {}.%FromJSON(##class(%Dictionary.CompiledXData).%OpenId(specname_".spec||OpenAPI").Data)
	Set url = $Select(%request.Secure:"https",1:"http") _ "://"_$Get(%request.CgiEnvs("SERVER_NAME")) _ ":" _ $Get(%request.CgiEnvs("SERVER_PORT")) _ %request.Application
	Set spec.servers = [{"url" : (url)}]
	Quit spec
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

    Set sc = product.%Delete()
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
