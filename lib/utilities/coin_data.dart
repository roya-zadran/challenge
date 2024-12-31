import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coin_tracker/models/coin_model.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC/Bitcoin',
  'ETH/Ethereum',
  'LTC/Litecoin',
];

class CoinData {
  Future<List<CoinModel>> getCoinData(String currency) async {
    List<CoinModel> cryptoPrices = [];

    try {
      for (String crypto in cryptoList) {
        String symbol = crypto.split('/')[0]; // Extract the symbol, e.g., BTC
        String name = crypto.split('/')[1]; // Extract the name, e.g., Bitcoin

        var url = Uri.parse(
            'https://api.coingecko.com/api/v3/simple/price?ids=$symbol&vs_currencies=$currency');
        var response = await http.get(url);

        if (response.statusCode == 200) {
          var decodedData = jsonDecode(response.body);
          double price = decodedData[symbol.toLowerCase()][currency.toLowerCase()]?.toDouble() ?? 0.0;

          CoinModel coinModel = CoinModel(
            icon: symbol.toLowerCase(),
            name: name,
            price: price,
          );
          cryptoPrices.add(coinModel);
        } else {
          print('Failed to fetch data for $crypto: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error occurred while fetching coin data: $e');
    }

    return cryptoPrices;
  }
}
