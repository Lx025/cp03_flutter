import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cp_3/data/repositories/settings_repository.dart';
import 'package:cp_3/routes.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _dontShowAgain = false;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Bem-vindo ao SafeKey',
      'subtitle': 'Seu gerenciador de senhas pessoal e seguro.',
      'lottie': 'assets/lottie/intro1.json',
    },
    {
      'title': 'Gere Senhas Fortes',
      'subtitle': 'Crie senhas complexas com nossa API integrada.',
      'lottie': 'assets/lottie/intro2.json',
    },
    {
      'title': 'Acesse de Onde Quiser',
      'subtitle': 'Suas senhas salvas na nuvem com segurança.',
      'lottie': 'assets/lottie/intro3.json',
    },
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _finishIntro();
    }
  }

  void _onBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _finishIntro() async {
    final settingsRepo = SettingsRepository();
    await settingsRepo.setShowIntro(!_dontShowAgain);
    
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Lottie.asset(
                            page['lottie']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page['title']!,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['subtitle']!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),


            Visibility(
              visible: isLastPage,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _dontShowAgain,
                      onChanged: (val) {
                        setState(() {
                          _dontShowAgain = val ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text('Não mostrar essa introdução novamente.'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),


            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  if (_currentPage > 0)
                    TextButton(
                      onPressed: _onBack,
                      child: const Text('Voltar'),
                    )
                  else
                    const SizedBox(width: 80), 


                  ElevatedButton(
                    onPressed: _onNext,
                    child: Text(isLastPage ? 'Concluir' : 'Avançar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}