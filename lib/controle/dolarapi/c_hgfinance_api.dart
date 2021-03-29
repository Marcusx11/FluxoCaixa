


import 'package:fluxo_caixa/modelo/dolarapi/hg_finance_api.dart';

class CHGFinanceAPI {

  Future getValorInDolar(double valor) async {
    var valorCompraDolar = await HGFinanceAPI().getDolarData();

    //var dolarParsed = double.parse(valorCompraDolar);

    return valor * valorCompraDolar;
  }
}