import 'package:flutter/material.dart';
import '../../domain/models/user.dart';
import '../../domain/services/authentication_service.dart';
import 'home_screen.dart';
import 'nutri_ai_screen.dart';
import 'diary_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  final AuthenticationService authService;

  const MainScreen({Key? key, required this.user, required this.authService})
    : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;
  late final List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();

    // Definindo as telas que serão exibidas
    _screens = [
      HomeScreen(
        user: widget.user,
        authService: widget.authService,
      ), // Showcase
      NutriAIScreen(user: widget.user), // NutriAI
      DiaryScreen(user: widget.user), // Meu diário
      ProfileScreen(
        user: widget.user,
        authService: widget.authService,
      ), // Perfil
    ];

    // Definindo os itens da barra de navegação
    _navItems = const [
      BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Showcase'),
      BottomNavigationBarItem(
        icon: Icon(Icons.restaurant_menu),
        label: 'NutriAI',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: 'Meu diário',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barra de navegação
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: _navItems,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              elevation: 0,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              showUnselectedLabels: true,
            ),

            // Indicador de seleção (a linha verde na parte inferior)
            SizedBox(
              height: 3,
              child: Row(
                children: List.generate(
                  _navItems.length,
                  (index) => Expanded(
                    child: Container(
                      color: _selectedIndex == index
                          ? Colors.green
                          : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
