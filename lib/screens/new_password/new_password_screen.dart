
import 'package:flutter/material.dart';
import 'package:cp_3/data/services/auth_service.dart';
import 'package:cp_3/data/services/password_api_service.dart';
import 'package:cp_3/data/services/password_service.dart';
import 'package:cp_3/models/password_model.dart';
import 'package:cp_3/widgets/password_result_widget.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final PasswordApiService _apiService = PasswordApiService();
  final PasswordService _passwordService = PasswordService();
  final AuthService _authService = AuthService();


  String _generatedPassword = "Clique em Gerar";
  bool _isLoading = false;
  bool _showOptions = false;


  double _length = 16.0;
  bool _useUppercase = true;
  bool _useNumbers = true;
  bool _useSymbols = true;

  @override
  void initState() {
    super.initState();

  }

  Future<void> _generatePassword() async {
    setState(() => _isLoading = true);
    try {
      final password = await _apiService.generatePassword(
        length: _length,
        useUppercase: _useUppercase,
        useNumbers: _useNumbers,
        useSymbols: _useSymbols,
      );
      setState(() {
        _generatedPassword = password;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao gerar senha: ${e.toString()}'), 
              backgroundColor: Colors.red),
        );

      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _savePassword() async {
    if (_generatedPassword == "Clique em Gerar" || _generatedPassword == "Falha ao gerar") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gere uma senha válida antes de salvar.")),
      );
      return;
    }

    final String? label = await _showSaveDialog();
    if (label == null || label.isEmpty) return; 

    final user = _authService.currentUser;
    if (user == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro: Usuário não autenticado.")),
      );
      return; 
    }

    final newPassword = PasswordModel(
      label: label,
      password: _generatedPassword,
      userId: user.uid,
    );

    setState(() => _isLoading = true); 
    try {
      await _passwordService.addPassword(newPassword);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Senha salva com sucesso!"),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Erro ao salvar senha no Firestore: ${e.toString()}"),
              backgroundColor: Colors.red),
        );
      }
    } finally {
       if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<String?> _showSaveDialog() {
    final TextEditingController labelController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Salvar Senha"),
          content: Form( 
            key: formKey,
            child: TextFormField( 
              controller: labelController,
              decoration: const InputDecoration(
                labelText: "Rótulo*", 
                hintText: "Ex: Facebook, E-mail Pessoal...",
              ),
              autofocus: true,
              validator: (value) { 
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, digite um rótulo.';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {

                if (formKey.currentState!.validate()) {
                    Navigator.pop(context, labelController.text.trim());
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void _showAppInfo() {
    showAboutDialog(
      context: context,
      applicationName: "SafeKey",
      applicationVersion: "1.0.0",
      applicationLegalese: "© 2025 Leonardo e Vitória/Fiap",
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text("Aplicativo seguro para gerar e gerenciar suas senhas."),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerar Nova Senha"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAppInfo,
            tooltip: "Sobre o app",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

             if (_isLoading && _generatedPassword == "Clique em Gerar")
              const Center(child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: CircularProgressIndicator(),
              ))
            else 
              PasswordResultWidget(
                password: _generatedPassword,
                onRegenerate: _generatePassword,
              ),
            const SizedBox(height: 24),

          
            ExpansionPanelList(
              elevation: 1,
              expandedHeaderPadding: EdgeInsets.zero,
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  _showOptions = !isExpanded; 
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {

                    return ListTile(
                      title: Text(isExpanded ? "Ocultar opções" : "Mostrar opções de Geração"),
                       trailing: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                       ),
                       onTap: () {
                         setState(() {
                           _showOptions = !isExpanded;
                         });
                       },
                    );
                  },
                  body: _buildOptions(),
                  isExpanded: _showOptions,
                  canTapOnHeader: true,
                ),
              ],
            ),
             const SizedBox(height: 24),


             ElevatedButton(
               onPressed: _isLoading ? null : _generatePassword,
               style: ElevatedButton.styleFrom(
                 padding: const EdgeInsets.symmetric(vertical: 16),
               ),
               child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                      : const Text("Gerar Senha"),
             ),
             const SizedBox(height: 80),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.save),
        label: const Text("Salvar Senha"),
        onPressed: _isLoading ? null : _savePassword,
      ),
    );
  }


  Widget _buildOptions() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0), 
      child: Column(
        children: [

          Row(
            children: [
              const Text("Tamanho da senha:"),
              Expanded(
                child: Slider(
                  value: _length,
                  min: 8,
                  max: 64,
                  divisions: (64 - 8), 
                  label: _length.round().toString(), 
                  onChanged: (value) {
                    setState(() => _length = value);
                  },
                ),
              ),

              Text(_length.round().toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),

          SwitchListTile(
            title: const Text("Incluir letras maiúsculas (A-Z)"),
            value: _useUppercase,
            onChanged: (val) => setState(() => _useUppercase = val),
             contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text("Incluir números (0-9)"),
            value: _useNumbers,
            onChanged: (val) => setState(() => _useNumbers = val),
             contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text("Incluir símbolos (!@#\$)"),
            value: _useSymbols,
            onChanged: (val) => setState(() => _useSymbols = val),
             contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}