import 'dart:convert';

import 'dart:io';

import 'package:http/http.dart' as http;

const URL = "https://api.hgbrasil.com/finance?format=json-cors&key=828d8c27";

class HGFinanceAPI {

  Future getDolarData() async {
    var response = await http.get(URL);

    var hgJson = json.decode(response.body);

    var dolar = hgJson["results"]["currencies"]["USD"]["buy"];

    return dolar;
  }
}