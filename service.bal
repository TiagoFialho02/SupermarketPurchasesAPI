import ballerina/http;
import ballerinax/mongodb;

const string host = "data.mongodb-api.com";
const int port = 27017;
const string username = "SuperMarketPurchasesAdmin";
const string password = "1z2x3c4v5b";
const string database = "SuperMarketPurchases";
const string collection = "Products";

const string mongoURL = "mongodb://" + username + ":" + password + "@supermarketpurchases-shard-00-00.ivgfu.mongodb.net:27017,supermarketpurchases-shard-00-01.ivgfu" + 
                        ".mongodb.net:27017,supermarketpurchases-shard-00-02.ivgfu.mongodb.net:27017/" + database + "?ssl=true&replicaSet=atlas-3o9ayk-shard-0&" + 
                        "authSource=admin&retryWrites=true&w=majority";

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

service / on new http:Listener(9090) {

    # search product by name in MongoDb
    # + productName - the input string product name
    # + return - json product with content or error
    resource function get SupermarketPurchases/getProductsByName(string productName) returns json|error {
        // Send a response back to the caller.
        mongodb:ConnectionConfig mongoConfig = {
            host: host,
            port: port,
            username: username,
            password: password,
            options: {sslEnabled: false, serverSelectionTimeout: 20000, url: mongoURL}
        };

        mongodb:Client mongoClient = check new (mongoConfig, database);
        stream<productItem, error?> result;
        map<json> queryString = {name: productName};

        if (productName != "-1") {
            result = check mongoClient->find(collection, (), queryString);
        } else {
            result = check mongoClient->find(collection, (), ());
        }
        lock {
            products = "{";
        }
        check result.forEach(isolated function(productItem tempProduct) {
            lock {
                products += ("{bar_code: " + tempProduct.bar_code + "," +
                            "brand_name: " + tempProduct.brand_name + "," +
                            "name: " + tempProduct.name + "," +
                            "price: " + tempProduct.price + "," +
                            "size: " + tempProduct.size + "}");
            }
        });

        lock {
            products += "}";
        }
        mongoClient->close();
        int code = 0;
        // verifies if theres any product with that name on the database 
        lock {
            if (products == "{}") {
                code = 200;
            }
        }

        if (code == 200) {
            return brocadeAPIGetProductsByName(productName);
        } else {
            lock {
                return products.toJson();
            }
        }

    }

    # search product by bar code in MongoDb
    # + productBarCode - the input string product bar code
    # + return - json product with content or error
    resource function get SupermarketPurchases/getProductsByBarCode(string productBarCode) returns json|error {
        // Send a response back to the caller.
        mongodb:ConnectionConfig mongoConfig = {
            host: host,
            port: port,
            username: username,
            password: password,
            options: {sslEnabled: false, serverSelectionTimeout: 20000, url: mongoURL}
        };

        mongodb:Client mongoClient = check new (mongoConfig, database);
        stream<productItem, error?> result;
        if (productBarCode != "-1") {
            map<json> queryString = {bar_code: productBarCode};
            result = check mongoClient->find(collection, (), queryString);
        } else {
            result = check mongoClient->find(collection, (), ());
        }
        lock {
            products = "{";
        }
        check result.forEach(isolated function(productItem tempProduct) {
            lock {
                products += ("{bar_code: " + tempProduct.bar_code + "," +
                            "brand_name: " + tempProduct.brand_name + "," +
                            "name: " + tempProduct.name + "," +
                            "price: " + tempProduct.price + "," +
                            "size: " + tempProduct.size + "}");
            }
        });

        lock {
            products += "}";
        }
        mongoClient->close();
        int code = 0;
        // verifies if theres any product with that name on the database 
        lock {
            if (products == "{}") {
                code = 200;
            }
        }
        if (code == 200) {
            return brocadeAPIGetProductsByBarCode(productBarCode);
        } else {
            lock {
                return products.toJson();
            }
        }
    }

    # post product in MongoDb
    # + req_bar_code - product bar code
    # + req_brand_name - product brand name
    # + req_name - product name
    # + req_price - product price
    # + req_size - product size
    # + req_date - product date
    # + return - string "inserted"
    resource function post SupermarketPurchases/postProduct(string req_bar_code, string req_brand_name, string req_name, string req_price, string req_size, string req_date) returns string|error {
        // Send a response back to the caller.
        mongodb:ConnectionConfig mongoConfig = {
            host: host,
            port: port,
            username: username,
            password: password,
            options: {sslEnabled: false, serverSelectionTimeout: 20000, url: mongoURL}
        };
        mongodb:Client mongoClient = check new (mongoConfig, database);
        map<json> product = {
            bar_code: req_bar_code,
            brand_name: req_brand_name,
            name: req_name,
            price: req_price,
            size: req_size,
            date: req_date
        };
        check mongoClient->insert(product, collection);
        mongoClient->close();
        return "Inserted";
    }
}

# search product by name in brocade API
# + productName - the input string product name
# + return - product in string
function brocadeAPIGetProductsByName(string productName) returns string {
    // Send a response back to the caller.
    json response;
    do {
        http:Client brocade_itemByName = check new ("https://www.brocade.io/api");
        response = check brocade_itemByName->get("/items?query=" + productName);
    } on fail var e {
        return e.toString();
    }
    return response.toString();
}

# search product by bar code in brocade API
# + productBarCode - the input string barCode
# + return - product in string
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
