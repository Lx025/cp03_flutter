import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cp_3/data/services/auth_service.dart';
import 'package:cp_3/data/services/password_service.dart';
import 'package:cp_3/models/password_model.dart';
import 'package:cp_3/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final PasswordService _passwordService = PasswordService();
  
  final Map<String, bool> _visibility = {};

  void _logout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _copyToClipboard(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Senha copiada para o clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("Erro: Usuário não logado")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Senhas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Sair",
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(user.email),
          _buildPremiumBanner(),
          Expanded(
            child: StreamBuilder<List<PasswordModel>>(
              stream: _passwordService.getPasswords(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                      child: Text("Erro ao carregar senhas."));
                }
                final passwords = snapshot.data;
                if (passwords == null || passwords.isEmpty) {
                  return const Center(
                    child: Text("Nenhuma senha salva ainda."),
                  );
                }


                return ListView.builder(
                  itemCount: passwords.length,
                  itemBuilder: (context, index) {
                    final p = passwords[index];
                    final docId = p.id!;
                    final isVisible = _visibility.putIfAbsent(docId, () => false);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ListTile(
                        title: Text(p.label),
                        subtitle: Text(isVisible ? p.password : "••••••••"),
                        leading: const Icon(Icons.vpn_key),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(isVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _visibility[docId] = !isVisible;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red.shade300),
                              onPressed: () {
                                _passwordService.deletePassword(docId);
                              },
                            ),
                          ],
                        ),
                        onTap: () => _copyToClipboard(p.password),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.newPassword);
        },
        tooltip: "Gerar Nova Senha",
      ),
    );
  }

  Widget _buildHeader(String? email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Text(
        "Logado como: ${email ?? 'N/A'}",
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/premium_banner.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}