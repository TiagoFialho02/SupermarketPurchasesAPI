import ballerina/http;
import ballerinax/mongodb;
import ballerina/log;
# A service representing a network-accessible API
# bound to port `9090`.

# + _id - n
# + bar_code - n
# + brand_name - n
# + name - n
# + price - n
# + size - n
# + date - n
type Product record {
    string _id;
    string bar_code;
    string brand_name;
    string name;
    string price;
    string size;
    string date;
};

configurable string host = "data.mongodb-api.com";
configurable int port = 27017;
configurable string username = "SuperMarketPurchasesAdmin";
configurable string password = "1z2x3c4v5b";
configurable string database = "SuperMarketPurchases";
configurable string collection = "Products";
service / on new http:Listener(9090) {
    # search product by name in brocade API
    # + productName - the input string product
    # + return - string name with hello message or error
    resource function get brocadeAPI/getProductsByName(string productName) returns json|error {
        // Send a response back to the caller.
        http:Client brocade_itemByName = check new ("https://www.brocade.io/api");
        json products = check brocade_itemByName->get("/items?query=" + productName);
        return products;
    }

    # search product by bar code in brocade API
    # + productBarCode - the input string barCode
    # + return - string name with hello message or error
    resource function get brocadeAPI/getProductsByBarCode(string productBarCode) returns json|error {
        // Send a response back to the caller.
        http:Client brocade_itemByName = check new ("https://www.brocade.io/api");
        json products = check brocade_itemByName->get("/items/" + productBarCode);
        return products;
    }

    # search product by name in MongoDb
    # + product - the input string product
    # + return - json name with hello message or error
     resource function get SupermarketPurchases/getProductsByName(string product) returns json|error {
        // Send a response back to the caller.
        mongodb:ConnectionConfig mongoConfig = {
            host: host,
            port: port,
            username: username,
            password: password,
            options: {sslEnabled: false, serverSelectionTimeout: 20000, url: "mongodb+srv://SuperMarketPurchasesAdmin:1z2x3c4v5b@supermarketpurchases.ivgfu.mongodb.net/SuperMarketPurchases?retryWrites=true&w=majority"}
        };
        
        mongodb:Client mongoClient = check new (mongoConfig, database);
        stream<Product, error?> result;
        if(product != "-1"){
            map<json> queryString = {name: product};
            result = check mongoClient->find(collection, (), queryString);
        }else{
            result = check mongoClient->find(collection, (), ());
        }
        //json x = {};
        check result.forEach(function(Product tempProduct){
            log:printInfo("{{bar_code: " + tempProduct.bar_code + "," + 
                          "brand_name: " + tempProduct.brand_name + "," +
                          "name: " + tempProduct.name + "," +
                          "price: " + tempProduct.price + "," +
                          "size: " + tempProduct.size + "}}");
           
            //x= tempProduct.toJson();
        });
        
        mongoClient->close();
        
        return "";
    
    }

}