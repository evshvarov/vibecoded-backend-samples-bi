/// Swagger/OpenAPI spec for Product CRUD and listing.
Class HoleFoods.api.spec Extends %REST.Spec
{

// spec

Parameter HandleCorsRequest = 1;

Parameter CONTENTTYPE = "application/json";

XData OpenAPI [ MimeType = application/json ]
{
{
  "swagger": "2.0",
  "info": {
    "title": "HoleFoods Product API",
    "version": "1.0.0"
  },
  "basePath": "/holefoods/api",
  "consumes": [
    "application/json"
  ],
  "produces": [
    "application/json"
  ],
  "paths": {
    "/_spec": {
      "get": {
        "summary": "Get OpenAPI spec",
        "operationId": "GetSpec",
        "responses": {
          "200": {
            "description": "Swagger spec JSON",
            "schema": {
              "type": "object"
            }
          }
        }
      }
    },
    "/products": {
      "get": {
        "tags": [
          "Product"
        ],
        "summary": "List all products",
        "operationId": "ListProducts",
        "responses": {
          "200": {
            "description": "All products",
            "schema": {
              "type": "array",
              "items": {
                "$ref": "#/definitions/Product"
              }
            }
          }
        }
      },
      "post": {
        "tags": [
          "Product"
        ],
        "summary": "Create product",
        "operationId": "CreateProduct",
        "parameters": [
          {
            "name": "body",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/Product"
            }
          }
        ],
        "responses": {
          "201": {
            "description": "Created product",
            "schema": {
              "$ref": "#/definitions/Product"
            }
          }
        }
      }
    },
    "/products/{sku}": {
      "get": {
        "tags": [
          "Product"
        ],
        "summary": "Get product by SKU",
        "operationId": "GetProduct",
        "parameters": [
          {
            "name": "sku",
            "in": "path",
            "required": true,
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "Product",
            "schema": {
              "$ref": "#/definitions/Product"
            }
          },
          "404": {
            "description": "Not found"
          }
        }
      },
      "put": {
        "tags": [
          "Product"
        ],
        "summary": "Update product by SKU",
        "operationId": "UpdateProduct",
        "parameters": [
          {
            "name": "sku",
            "in": "path",
            "required": true,
            "type": "string"
          },
          {
            "name": "body",
            "in": "body",
            "required": true,
            "schema": {
              "$ref": "#/definitions/Product"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "Updated product",
            "schema": {
              "$ref": "#/definitions/Product"
            }
          },
          "404": {
            "description": "Not found"
          }
        }
      },
      "delete": {
        "tags": [
          "Product"
        ],
        "summary": "Delete product by SKU",
        "operationId": "DeleteProduct",
        "parameters": [
          {
            "name": "sku",
            "in": "path",
            "required": true,
            "type": "string"
          }
        ],
        "responses": {
          "204": {
            "description": "Deleted"
          },
          "404": {
            "description": "Not found"
          }
        }
      }
    }
  },
  "definitions": {
    "Product": {
      "type": "object",
      "properties": {
        "SKU": {
          "type": "string"
        },
        "Category": {
          "type": "string"
        },
        "Name": {
          "type": "string"
        },
        "Price": {
          "type": "number",
          "format": "float",
          "minimum": 0
        }
      },
      "required": [
        "SKU",
        "Name"
      ]
    }
  }

}
}

}
