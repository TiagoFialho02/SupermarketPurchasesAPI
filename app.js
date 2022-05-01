var express = require('express'); 
const app = express();
const requestHandlers = require("./www/scripts/request-handlers");

app.get('/getItemsByBarCode/:BarCode?', requestHandlers.getProductByBarCode);

app.get('/getItemsByName/:Name?', requestHandlers.getProductsByName);

app.listen(8080, function () {
    console.log("Server running at http://localhost:8080");
});