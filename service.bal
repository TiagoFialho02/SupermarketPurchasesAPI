import ballerina/http;
import ballerinax/mongodb;

# A service representing a network-accessible API
# bound to port `9090`.
 
# + _id - n
# + bar_code - n
# + brand_name - n
# + name - n
# + price - n
# + size - n
# + date - n
# 
type productItem record {
    string _id;
    string bar_code;
    string brand_name;
    string name;
    string price;
    string size;
    string date;
};
 
isolated string products = "";
type LineStream stream<string, Error?>;
configurable string host = "data.mongodb-api.com";
configurable int port = 27017;
configurable string username = "SuperMarketPurchasesAdmin";
configurable string password = "1z2x3c4v5b";
configurable string database = "SuperMarketPurchases";
configurable string collection = "Products";

service / on new http:Listener(9090) {
    # search product by name in MongoDb
    # + productName - the input string product name
    # + return - json name with hello message or error
    resource function get SupermarketPurchases/getProductsByName(string productName) returns json|error {
                // Send a response back to the caller.
        mongodb:ConnectionConfig mongoConfig = {
            host: host,
            port: port,
            username: username,
            password: password,
            options: {sslEnabled: false, serverSelectionTimeout: 20000, url: "mongodb+srv://SuperMarketPurchasesAdmin:1z2x3c4v5b@supermarketpurchases.ivgfu.mongodb.net/SuperMarketPurchases?retryWrites=true&w=majority"}
        };
        
        mongodb:Client mongoClient = check new (mongoConfig, database);
        stream<productItem, error?> result;
        if(productName != "-1"){
            map<json> queryString = {name: productName};
            result = check mongoClient->find(collection, (), queryString);
        }else{
            result = check mongoClient->find(collection, (), ());
        }
        lock{
            products = "{";
        }
        check result.forEach(isolated function(productItem tempProduct){
            lock{
                products += ("{bar_code: " + tempProduct.bar_code + "," + 
                            "brand_name: " + tempProduct.brand_name + "," +
                            "name: " + tempProduct.name + "," +
                            "price: " + tempProduct.price + "," +
                            "size: " + tempProduct.size + "}");
            }
        });

        lock{
            products += "}";
        }
        mongoClient->close();

        int code = 0;
        // verifies if theres any product with that name on the database 
        lock{
            if(products == "{}"){
               code = 200;
            }
        }

        if(code == 200){
            return brocadeAPIGetProductsByName(productName);
        }else{
            lock{
                return products.toJson();
            }
        }
    }

    resource function get SupermarketPurchases/getProductsByBarCode(string productBarCode) returns json|error {
                // Send a response back to the caller.
        mongodb:ConnectionConfig mongoConfig = {
            host: host,
            port: port,
            username: username,
            password: password,
            options: {sslEnabled: false, serverSelectionTimeout: 20000, url: "mongodb+srv://SuperMarketPurchasesAdmin:1z2x3c4v5b@supermarketpurchases.ivgfu.mongodb.net/SuperMarketPurchases?retryWrites=true&w=majority"}
        };
        
        mongodb:Client mongoClient = check new (mongoConfig, database);
        stream<productItem, error?> result;
        if(productBarCode != "-1"){
            map<json> queryString = {bar_code: productBarCode};
            result = check mongoClient->find(collection, (), queryString);
        }else{
            result = check mongoClient->find(collection, (), ());
        }
        lock{
            products = "{";
        }
        check result.forEach(isolated function(productItem tempProduct){
            lock{
                products += ("{bar_code: " + tempProduct.bar_code + "," + 
                            "brand_name: " + tempProduct.brand_name + "," +
                            "name: " + tempProduct.name + "," +
                            "price: " + tempProduct.price + "," +
                            "size: " + tempProduct.size + "}");
            }
        });

        lock{
            products += "}";
        }
        mongoClient->close();

        int code = 0;
        // verifies if theres any product with that name on the database 
        lock{
            if(products == "{}"){
               code = 200;
            }
        }

        if(code == 200){
            return brocadeAPIGetProductsByBarCode(productBarCode);
        }else{
            lock{
                return products.toJson();
            }
        }
    }

    resource function post SupermarketPurchases/postProduct(string req_bar_code, string req_brand_name, string req_name, string req_price, string req_size, string req_date) returns string|error {
        // Send a response back to the caller.
        mongodb:ConnectionConfig mongoConfig = {
            host: host,
            port: port,
            username: username,
            password: password,
            options: {sslEnabled: false, serverSelectionTimeout: 20000, url: "mongodb+srv://SuperMarketPurchasesAdmin:1z2x3c4v5b@supermarketpurchases.ivgfu.mongodb.net/SuperMarketPurchases?retryWrites=true&w=majority"}
        };
        mongodb:Client mongoClient = check new (mongoConfig, database);
        map<json> product = {bar_code: req_bar_code,
                            brand_name: req_brand_name,
                            name: req_name,
                            price: req_price,
                            size: req_size,
                            date: req_date};	
        check mongoClient->insert(product, collection);
        mongoClient->close();
        return "Inserted";
    }
}

# search product by name in brocade API
# + productName - the input string product
# + return - string name with hello message or error
function brocadeAPIGetProductsByName(string productName) returns string {
    // Send a response back to the caller.
    json response;
    do {
        http:Client brocade_itemByName = check new ("https://www.brocade.io/api");
	    response = check brocade_itemByName->get("/items?query=" + productName);
    } on fail var e{
    	return e.toString();
    }
    return response.toString();
}

# search product by bar code in brocade API
# + productBarCode - the input string barCode
# + return - string name with hello message or error
function brocadeAPIGetProductsByBarCode(string productBarCode) returns string {
    // Send a response back to the caller.
    json response;
    do {
	    // Send a response back to the caller.
	    http:Client brocade_itemByName = check new ("https://www.brocade.io/api");
        response = check brocade_itemByName->get("/items/" + productBarCode);
    } on fail var e {
    	return e.toString();
    }
    return response.toString();
}
