import ballerina/http;
# A service representing a network-accessible API
# bound to port `9090`.
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


    # + product - the input string product
    # + return - string name with hello message or error
    resource function get SupermarketPurchases/getProducts(string product) returns json|error {
        // Send a response back to the caller.
       return "to cá";
    }

}
