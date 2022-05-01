var axios = require("axios").default;

var ExternalAPILinks = {
    itemsAxiosOptions: 'https://www.brocade.io/api/items/',
    itemsSearchAxiosOptions: 'https://www.brocade.io/api/items?query='
}

var itemsAxiosOptions = {
    method: 'GET',
    url: ExternalAPILinks.itemsAxiosOptions,
}

var itemsSearchAxiosOptions = {
    method: 'GET',
    url: ExternalAPILinks.itemsSearchAxiosOptions,
}


function getProductByBarCode(req, res) {
    itemsAxiosOptions.url += req.params.BarCode
    axios.request(itemsAxiosOptions).then(function (response){
        res.send(response.data);
    }).catch(function(error){
        console.log(error);
    });
    itemsAxiosOptions.url = ExternalAPILinks.itemsAxiosOptions
}

function getProductsByName(req, res) {
    itemsSearchAxiosOptions.url += req.params.Name
    axios.request(itemsSearchAxiosOptions).then(function (response){
        res.send(response.data);
    }).catch(function(error){
        console.log(error);
    });
    itemsSearchAxiosOptions.url = ExternalAPILinks.itemsSearchAxiosOptions
}

module.exports.getProductByBarCode = getProductByBarCode;
module.exports.getProductsByName = getProductsByName;