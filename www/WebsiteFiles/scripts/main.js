urlHeader = "http://localhost:8080/";

function getProducts() {
    products = [];
    productNameInput = document.getElementById("productNameInput")
    if (productNameInput.value != "") {
        /**
         * Recolhe todos os dados da base de dados para dentro dos vetores dos determinados objetos
        */
        var products = [];
        var url = urlHeader + "getItemsByName/" + productNameInput.value;
        var xhr = new XMLHttpRequest();
        xhr.responseType = "json";
        xhr.open("GET", url, true);
        xhr.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                xhr.response.forEach(s => {
                        products.push(new Product(1, s.gtin14, s.name));
                });
            }
            productNameInput.innerHTML = products;
        };
    xhr.send();

    } 
    else {
        document.getElementById("res").innerHTML = "preencha a caixa de texto!";
    }
}