APIUrlHeader = "https://97b99f16-22bb-410f-95cc-ceec57525e37-prod.e1-us-east-azure.choreoapis.dev/" + 
            "dvpf/supermarketpurchasesapi/1.0.0";
EXTERNAL_API_KEY="eyJraWQiOiJnYXRld2F5X2NlcnRpZmljYXRlX2FsaWFzIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiI1ZTc5YzczYy1hNmY1LTQ1OGEtYmYyZi00YmNlNzg1ZDgyM2VAY2FyYm9uLnN1cGVyIiwiaXNzIjoiaHR0cHM6XC9cL3N0cy5jaG9yZW8uZGV2OjQ0M1wvb2F1dGgyXC90b2tlbiIsImtleXR5cGUiOiJQUk9EVUNUSU9OIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1YnNjcmliZXJUZW5hbnREb21haW4iOm51bGwsIm5hbWUiOiJTdXBlcm1hcmtldFB1cmNoYXNlc0FQSSIsImNvbnRleHQiOiJcLzk3Yjk5ZjE2LTIyYmItNDEwZi05NWNjLWNlZWM1NzUyNWUzN1wvZHZwZlwvc3VwZXJtYXJrZXRwdXJjaGFzZXNhcGlcLzEuMC4wIiwicHVibGlzaGVyIjoiY2hvcmVvX3Byb2RfYXBpbV9hZG1pbiIsInZlcnNpb24iOiIxLjAuMCIsInN1YnNjcmlwdGlvblRpZXIiOm51bGx9XSwiZXhwIjoxNjUxNDkyMTkxLCJ0b2tlbl90eXBlIjoiSW50ZXJuYWxLZXkiLCJpYXQiOjE2NTE0MzIxOTEsImp0aSI6ImJmOWUxNTQ3LWFmN2UtNGJlOS04ODcwLWQ1NGU5OWEwM2MzMyJ9.Gopd9Q09PQg-NyZVognXCgYN2S2aJcJsqw0gKttxUdy-lEr4S2iv3pO98SHI7VfNdGLniHe1WlpBrkPiIX6vmshEQKAuKY6nHNNo01km_W64tcP2Qzpi0L5SIJ365Zs1Uq5rokCnnFH8cNIGjcCCGYNi1fXaqDuAvkHvzsVp_kpCP386PAXXN09prMgYM6-x8HpROxugroDAC92LPOTqTpeQZogE9vEjlyUWDMbgcpWNQ-cNXLoZPzbax76zsqVxGxS3s7qsJs2HQlWCwtWt8kr4S4rhsiYSHytjq6uIm8WYyk6_ma-inQ0hzASclp_bmfy3-faYXLHchdin9S8KJpZ5xfsOy9EfquFKPKnJg7VsrF2kgFkEm3tH3dcUEzHOp5xoSIpBUDp8UXgPzEsJFqT3Lr8LPS4TBHK0w_sWRBcquVCpCPPe4qUWZxiA_NMVlXIAsgBfsI-a-8CYmHNU_Gl1EbExDTzzuJF1qilg8GVsOgvmvUKFbQYx92SlmYAAk0dxlLYM1n2PdFzXHnUG8aLplipx2i6GdUQt_Dh3B3E5CUZIVYmRzGbVml2jYKHVfJ_twxSE9DZ-LJIIKolGMO_ESgiig4B-kuMLieliDZw0nVP1EuCD5r4s1CrF_38YYYGPPhvz98xMjFiqoCcJXuLS7LhsNwNMstt6AYCdK6U";
urlHeader = "https://data.mongodb-api.com/app/data-bfkyg/endpoint/data/beta/action/findOne"
API_KEY = "2MvPXwenF28sqdbZCqVLTn1k89CfVXL0Q2hGPWfKS5DzCxlhN4LNXH46HVvLsSkV"
function getProductsFromAPI() {

    products = [];
    productNameInput = document.getElementById("APIProductNameInput")
    res = document.getElementById("res");
    if (productNameInput.value != "") {
        var products = [];
        var url = APIUrlHeader + "/brocadeAPI/getProductsByName?productName=" + productNameInput.value;
        var xhr = new XMLHttpRequest();
        xhr.responseType = "json";
        xhr.open("GET", url, true);
        xhr.setRequestHeader("API-Key", EXTERNAL_API_KEY)
        xhr.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                xhr.response.forEach(s => {
                        products.push(new Product(1, s.brand_name, s.gtin14, s.name, s.size));
                        res.innerHTML += s.brand_name + '</br>';
                        res.innerHTML += s.gtin14 + '</br>';
                        res.innerHTML += s.name + '</br>';
                        res.innerHTML += s.size + '</br></br>';
                });
            }
        };
        xhr.send();

    } 
    else {
        res.innerHTML = "preencha a caixa de texto!";
    }
}

function getProducts() {

    products = [];
    productNameInput = document.getElementById("productNameInput")
    res = document.getElementById("res");
    if (productNameInput.value != "") {
        var data = JSON.stringify({
            "dataSource": "SuperMarketPurchases",
            "database": "SuperMarketPurchases",
            "collection": "Products",
            "filter": { "name": "Exfoliating Cucumber Cleansing Towelettes" }
        });
        var products = [];
        var url = urlHeader;
        var xhr = new XMLHttpRequest();
        xhr.responseType = 'json';
        xhr.open('POST', url, true);
        xhr.setRequestHeader("Content-Length", "<calculated when request is sent>");
        xhr.setRequestHeader("Host", "<calculated when request is sent>");
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.setRequestHeader("api-key", API_KEY);
        xhr.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                xhr.response.forEach(s => {
                        products.push(new Product(1, s.brand_name, s.bar_code, s.name, s.size));
                        res.innerHTML += s.brand_name + '</br>';
                        res.innerHTML += s.gtin14 + '</br>';
                        res.innerHTML += s.name + '</br>';
                        res.innerHTML += s.size + '</br></br>';
                });
            }
            console.log(xhr)
        };
        xhr.send(data);
    }
    else {
        res.innerHTML = "preencha a caixa de texto!";
    }
}

class Product {
    constructor(id, brand_name, BarCode, Description, size) {
        this.id = id;
        this.brand_name = brand_name;
        this.BarCode = BarCode;
        this.Description = Description;
        this.size = size;
    }
}