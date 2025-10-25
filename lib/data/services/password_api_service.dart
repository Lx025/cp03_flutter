import 'dart:convert';
import 'package:http/http.dart' as http;

class PasswordApiService {
  final String _baseUrl =
      "https://safekey-api-a1bd9aa97953.herokuapp.com";

  Future<String> generatePassword({
    required double length,
    required bool useUppercase,
    required bool useNumbers,
    required bool useSymbols,
  }) async {
    final uri = Uri.parse('$_baseUrl/generate');
    
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'length': length.toInt(),
          'use_uppercase': useUppercase,
          'use_numbers': useNumbers,
          'use_symbols': useSymbols,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['password'];
      } else {

        final data = json.decode(response.body);
        throw Exception(data['error'] ?? 'Falha ao gerar senha');
      }
    } catch (e) {

      throw Exception('Erro de conexão: ${e.toString()}');
    }
  }
}